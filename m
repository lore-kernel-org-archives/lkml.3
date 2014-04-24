Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaDXCZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:25:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53498 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaDXCY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:24:59 -0400
Date: Thu, 24 Apr 2014 03:24:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: How do I make a clean mount namespace?
Message-ID: <20140424022457.GV18016@ZenIV.linux.org.uk>
References: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
 <CAFLxGvyn4q3VfRrAcjO6meZ1UJwRZ5-yeaMExGX5ogtnuAkPBQ@mail.gmail.com>
 <CALCETrUOEFwnYqKNtB3XKqsM1HNnOR9x-MXV8mjdR6ErUL3jGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUOEFwnYqKNtB3XKqsM1HNnOR9x-MXV8mjdR6ErUL3jGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 05:54:31PM -0700, Andy Lutomirski wrote:

> This requires CAP_SYS_ADMIN and it requires that the caller is not
> chrooted.  path must be a mountpoint and flags must be zero.
> 
> It lazy-unmounts everything outside path, and it moves path to /.
> When it's done, the current process's root is '/'.  If you want to
> retain temporary access to outside things, you can keep an fd open.
> If the old root is shared, it is made private.  It's okay for path to
> be shared (I think).
> 
> If other things are already running in the current mount namespace,
> then their root directory stays the same, so they keep working, but
> they may be a little confused.
> 
> I think this could replace pivot_root for most use cases, and it could
> simplify programs like switch_root.
> 
> Thoughts?

chdir(new);
pivot_root(".", old);
umount(old, MNT_DETACH);
chroot(".");
