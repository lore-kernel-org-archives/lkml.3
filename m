Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaDVOb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:31:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43062 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbaDVObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:31:53 -0400
Date: Tue, 22 Apr 2014 16:31:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RFC 2/2] fs,proc: Respect FMODE_WRITE when opening
 /proc/pid/fd/N
Message-ID: <20140422143152.GA23716@amd.pavel.ucw.cz>
References: <cover.1398097304.git.luto@amacapital.net>
 <430cfc67aae9b9ad5eab4d293107285ad44c5fd9.1398097304.git.luto@amacapital.net>
 <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4T1P-g+wA6bZQe6=79-+QLmXReu4namcPifw-SZViqW-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Mon, Apr 21, 2014 at 6:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > This patch does this:
> 
> I can see _what_ the patch does, but your patch lacks any discussion
> _why_ it is needed. Can you provide at least one real example where
> this fixes a security issue?

Such as here?

http://www.securityfocus.com/archive/1/507386

> > This may break userspace.  If so, I would guess that anything broken
> > by it is either an actual exploit or is so broken that it doesn't
> > deserve to continue working.  If it breaks something important, then
> > maybe it will need a sysctl.
> 
> This patch breaks the following use-case:
> 
> fd = open("/run", O_RDWR | O_TMPFILE);
> sprintf(path, "/proc/self/fd/%d", fd);
> fd2 = open(buf, O_RDONLY);

You meant open(path, ) here?

> sprintf(path, "/proc/self/fd/%d", fd2);
> linkat(AT_FDCWD, path, AT_FDCWD, "/run/some_lock_file", AT_FOLLOW_SYMLINK);
> 
> I mean I explicitly create the object as _writable_ but then keep a
> read-only descriptor for debugging purposes (to make sure that the
> program no longer writes to the file). This is no security feature,
> but only a safety feature in case something goes wrong. But I still
> want to be able to create hard-links (I _do_ have write-permissions on
> the object/inode).

Does some real code do it? I believe this deserves to be broken -- you
explicitely opened that read-only...

     	  							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
