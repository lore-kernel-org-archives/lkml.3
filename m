Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaAOXdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:33:18 -0500
Received: from fieldses.org ([174.143.236.118]:37218 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaAOXdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:33:17 -0500
Date: Wed, 15 Jan 2014 18:33:14 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 05/11] vfs: add RENAME_NOREPLACE flag
Message-ID: <20140115233314.GB9457@fieldses.org>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-6-git-send-email-miklos@szeredi.hu>
 <20140115181955.GA5715@fieldses.org>
 <CALCETrVRfz0Ha-0Dr6X=6De9K6HACzcfryjEk633zAKjYxg6wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVRfz0Ha-0Dr6X=6De9K6HACzcfryjEk633zAKjYxg6wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:26:23AM -0800, Andy Lutomirski wrote:
> On Wed, Jan 15, 2014 at 10:19 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Wed, Jan 08, 2014 at 11:10:09PM +0100, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >>
> >> If this flag is specified and the target of the rename exists then the
> >> rename syscall fails with EEXIST.
> >
> > Why is this useful?
> 
> The trivial answer: to eliminate the race condition from 'mv -i'.
> 
> Another answer: there's a common pattern to atomically create a file
> with contents: open a temporary file, write to it, optionally fsync
> it, close it, then link(2) it to the final name, then unlink the
> temporary file.
> 
> The reason to use link(2) is because it won't silently clobber the destination.
> 
> This is annoying:
>  - It requires an extra system call that shouldn't be necessary.
>  - It doesn't work on (IMO sensible) filesystems that don't support
> hard links (e.g. vfat).
>  - It's not atomic -- there's an intermediate state where both files exist.
>  - It's ugly.
> 
> The new rename flag will make this totally sensible.

Makes sense, thanks!  Could that just get cut-n-pasted into the
changelog?  (Unless there's some obvious other place to put it.)

--b.

> 
> To be fair, on new enough kernels, you can also use O_TMPFILE and
> linkat to achieve the same thing even more cleanly.
