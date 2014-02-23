Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBWB1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 20:27:50 -0500
Received: from chicago.guarana.org ([192.210.136.102]:41963 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaBWB1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 20:27:49 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Feb 2014 20:27:49 EST
Date: Sun, 23 Feb 2014 12:18:06 +1100
From: Kevin Easton <kevin@guarana.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Zuckerman, Boris" <borisz@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        DaveC@chicago.guarana.org
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140223011806.GA13677@chicago.guarana.org>
References: <a8df285f-de7f-4a3a-9a19-e0ad07ab3a5c@blur>
 <8e9349a1-d900-4c93-8dad-1e32f26529c2@blur>
 <20140220182932.GF18016@ZenIV.linux.org.uk>
 <CAKgNAkjFquLPDBXCS50pzVz0EiSfgvJjrG6cEVMFwKZopeHHBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkjFquLPDBXCS50pzVz0EiSfgvJjrG6cEVMFwKZopeHHBg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 07:01:31AM +0100, Michael Kerrisk (man-pages) wrote:
> Here's the fulll list from POSIX.1-2008/SUSv4 Section XSI 2.9.7:
> 
> [[
> 2.9.7 Thread Interactions with Regular File Operations
> 
> All of the following functions shall be atomic with respect to each
> other in the effects specified in
> POSIX.1-2008 when they operate on regular files or symbolic links:
> 
> chmod( )
> chown( )
> close( )
> creat( )
> dup2( )
> fchmod( )
> fchmodat( )
> fchown( )
> fchownat( )
> fcntl( )
> fstat( )
> fstatat( )
> ftruncate( )
> lchown( )
> link( )
> linkat( )
> lseek( )
> lstat( )
> open( )
> openat( )
> pread( )
> read( )
> readlink( )
> readlinkat( )
> readv( )
> pwrite( )
> rename( )
> renameat( )
> stat( )
> symlink( )
> symlinkat( )
> truncate( )
> unlink( )
> unlinkat( )
> utime( )
> utimensat( )
> utimes( )
> write( )
> writev( )
> 
> If two threads each call one of these functions, each call shall
> either see all of the specified effects
> of the other call, or none of them.
> ]]
> 
> I'd bet that there's a bunch of violations to be found, but the
> read/write f_pos case is one of the most egregious.
> 
> For example, I got curious about stat() versus rename(). If one
> stat()s a directory() while a subdirectory is being renamed to a new
> name within that directory, does the link count of the parent
> directory ever change--that is, could stat() ever see a changed link
> count in the middle of the rename()? My experiments suggest that it
> can. I suppose it would have to be a very unusual application that
> would be troubled by that, but it does appear to be a violation of
> 2.9.7.

A directory isn't a regular file or symlink, though, so the warranty
would seem to be void in that case.

If you {f}stat() a regular file that is being concurrently renamed() then
the link count shouldn't vary, though.

    - Kevin
