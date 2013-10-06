Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3JFAh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:37:27 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55707 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3JFAhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:37:25 -0400
MIME-Version: 1.0
In-Reply-To: <1381018693.1974.166@driftwood>
References: <87li281wx6.fsf_-_@xmission.com>
	<1381014462.1974.162@driftwood>
	<CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
	<CA+55aFxgUMnZts-RXFh1qL1u+De_HNdMrC34skyWurbzvqpUdg@mail.gmail.com>
	<1381018693.1974.166@driftwood>
Date: Sat, 5 Oct 2013 17:37:24 -0700
X-Google-Sender-Auth: Nd9WSny1HHahmO1IiGCBUY2Nxds
Message-ID: <CA+55aFzLh9Ey6RgkSq_Ny033TbcB0PHBVVejEaX65vLv=NC2Pg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 5:18 PM, Rob Landley <rob@landley.net> wrote:
>
> Which is why containers have all sorts of extra plumbing. But that extra
> plumbing is currently built on pivot_root(), not on chroot(). And I'd
> dismissed pivot_root() as residue from initramfs with all that kernel thread
> reparenting, so it seemed like the wrong tool for the job, but obviously
> I'll take your and Al's word it's not...

Yeah, chroot() really doesn't cut it if you allow root access - and
thus internal chroot() calls - as you noticed (I didn't realize that
your example was meant to be run _inside_ a chroot).

There are generally other ways to escape chroot too if you're root.
It's just too hard to plug. That doesn't make chroot() useless - it
just means that the uses are elsewhere (it's useful for various
non-security issues like development environments, but it can also be
useful as one small _part_ of some bigger model, like a VM etc).

pivot_root() does end up being a "better chroot than chroot" if you're
looking for containment. It may not be a pretty system call, but it
does avoid at least the most obvious gotchas with chroot()..

            Linus
