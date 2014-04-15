Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaDOW1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:27:52 -0400
Received: from imap.thunk.org ([74.207.234.97]:54786 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaDOW1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:27:50 -0400
Date: Tue, 15 Apr 2014 18:27:47 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][1/11][MANUX] Kernel compatibility : ext2
Message-ID: <20140415222747.GN4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
References: <534D3753.6080601@manux.info>
 <20140415200457.GH4456@thunk.org>
 <534DA90C.7000507@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DA90C.7000507@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:47:56PM +0200, Emmanuel Colbus wrote:
> 
> By the way, just asking : if this is an NFS version field, is the
> content of this field significant when no NFS has ever been used to
> export this filesystem?

No.  But ext4 may end up changing the value of the i_version field,
from one non-zero value to some other non-zero value field.

> My OS heavily uses chroots for security purposes (these are not true
> Linux-like chroots, but this isn't relevant). One of the issues of
> chroots is that one can escape from them, by simply having one process
> open a fd towards a directory, another one move the directory inside a
> second directory located outside of the first process' chroot, and then
> have the first process perform enough fchdir(fd, ".."); or something of
> the like.

If there a process which is out side of the chroot which is
cooperating to help someone breakout of the chroot, that means you
have a bad actor who is outside of the chroot already.  So why bother
worrying about this case?

The more interesting way to break out of a crhoot, which doesn't
require a 2nd process to help you escape, is to chroot while inside a
chroot:

	www.bpfh.net/simes/computing/chroot-break.html

And if you care about this problem, Linux has a much more general
solution using mount namespaces.  FreeBSD has its own a solution
involving restrictions on chroot:

www.freebsd.org/cgi/man.cgi?query=chroot&sektion=2&apropos=0&manpath=FreeBSD+4.0-RELEASE


> Alright, then. Here's what I plan to do :
> - In the short term, I'm going to continue with what I'm currently doing
> with ext2 filesystems, but warn my users against mounting such a
> filesystem in read-write mode if they're also mounting it with ext4 and
> exporting it with NFS;

The main issue is what is the goal of your creating your own OS?  If
it's for your own edication, that's great.  Have fun, it's a great way
to learn.  If you're going to actually try to market this to other
users, you should make sure you understand how much effort it takes to
support a new file system, let alone a new operating system.  Hurd
tried to go down a path somewhat like yours, and it's taken them
years, and the result from a performance point of view is still pretty
bad.  Keep in mind that ext2 has many limitations, including crash
recovery, performance, and scalability.

If you are planning on creating a production quality OS using ext2 as
its base, it does seem a little naive, though.

Regards,

						- Ted
