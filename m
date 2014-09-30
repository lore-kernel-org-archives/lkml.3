Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaI3BOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:14:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54193 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3BOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:14:48 -0400
Date: Tue, 30 Sep 2014 02:14:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Removing shared subtrees?
Message-ID: <20140930011446.GQ7996@ZenIV.linux.org.uk>
References: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
 <20140930000924.GO7996@ZenIV.linux.org.uk>
 <CALCETrW8xvOr0WfyzqBUxZkw_PXckUh8AdGPxU3sd7=cLayPyQ@mail.gmail.com>
 <20140930002948.GP7996@ZenIV.linux.org.uk>
 <CALCETrVnXXjDjh9+vOGfFh08-wtjJeuC=n=PtNusOS_nq0puFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVnXXjDjh9+vOGfFh08-wtjJeuC=n=PtNusOS_nq0puFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 05:36:27PM -0700, Andy Lutomirski wrote:

> Ideally it would leave them around until the whole subtree had no
> references, at which point /mnt and everything under it would
> disappear with no side effects, because it has no references.

So, assuming you've got a stuck NFS mount with a bunch of local stuff
bound on top of it, in your ideal we'd have the latter all remaining
mounted until the server comes back.  Lovely, that...

> I suspect it detaches them immediately, especially after reading the
> rest of your email.

IOW, you *still* have not bothered to say man umount and read the manpage?

Quote:
       -l     Lazy  unmount.  Detach  the filesystem from the filesystem
              hierarchy now, and cleanup all references to the filesystem as
              soon as it is not busy anymore.  (Requires kernel 2.4.11 or
              later.)

> > Such an elegant way to say "I can't be arsed to read"...  For what it's
> > worth: MNT_DETACH is *not* "detach the subtree as whole, busy or not".
> > It's "unmount all mounts within the subtree, busy or not".  At which point
> > the self-LART you keep describing becomes quite easy to comprehend, doesn't
> > it?
> 
> Again, *I have no problem with the current semantics of umount -l*,
> except insofar as they interact really nastily with shared subtrees.
> I have a problem with bidirectional shared subtrees *in general*.

Pardon me, but it really looks like your problem is with reading.  In general
or not, but you are essentially complaining that your *guess* concerning the
semantics of this and that doesn't match the reality all that well, and its
combination with observed bits and pieces is really confusing.

BTW, I certainly agree that documentation of the mount-related utils and
syscalls could've been better.  But you clearly have never bothered to
read the existing one.  I'm sorry, but "I've used this utility with that
flag as root without ever checking what the manpage says about that
flag; results are painful and incomprehensible; whaddya mean, read the
fine manpage?" buys you very little sympathy.
