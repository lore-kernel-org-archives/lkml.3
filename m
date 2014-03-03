Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaCCXy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:54:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaCCXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:54:58 -0500
Date: Mon, 3 Mar 2014 23:54:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303235456.GR18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
 <20140303212642.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
 <CA+55aFxszctXek3QCXPeDScdSQZvuzp+EXHdA5cZnG3CLeJ1XA@mail.gmail.com>
 <CA+55aFwjSAPx=6x6r9hN_1hH406=TCnAyb=6s0BLt9=YsKy_wA@mail.gmail.com>
 <20140303233902.GP18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303233902.GP18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 11:39:02PM +0000, Al Viro wrote:
> On Mon, Mar 03, 2014 at 03:23:55PM -0800, Linus Torvalds wrote:
> 
> > This just uses a "flags" field, and we currently only have two bits
> > that we use: FDPUT_FPUT and FDPUT_POS_UNLOCK. The first patch knows
> > that "fget_light()" writes 0/1 for that, which is the same as the
> > FDPUT_FPUT bit. I didn't bother to comment on it or clean it up, since
> > the second patch just removes that whole fget_light() mess.
> > 
> > Comments?
> 
> do_sendfile() is also there and this one is even more unpleasant ;-/
> We probably can ignore that one (until POSIX learns of its existence),
> thouhg...

OK, other than read/write/readv/writev/lseek we have only sendfile{,64} and
splice; everything else either deals with struct file that is guaranteed to
be not accessible by any syscall (e.g. coredump code) or is not a regular
file.  So the only question is whether we care for syscalls that are
out of scope for POSIX.
