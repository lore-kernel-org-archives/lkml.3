Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3JEXR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:17:58 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:45118 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3JEXR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:17:56 -0400
MIME-Version: 1.0
In-Reply-To: <1381014462.1974.162@driftwood>
References: <87li281wx6.fsf_-_@xmission.com>
	<1381014462.1974.162@driftwood>
Date: Sat, 5 Oct 2013 16:17:55 -0700
X-Google-Sender-Auth: 3F3Uwu_Cf9NMG2cSSHfTgOhgu88
Message-ID: <CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
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

On Sat, Oct 5, 2013 at 4:07 PM, Rob Landley <rob@landley.net> wrote:
>
> A todo item I've had _forever_ is fixing chroot() to not be broken so that
> you can trivially break out of a chroot via:

What drugs are you on?

Your example is moronic, and against all _documented_ uses of chroot.

>   chdir("/");
>   mkdir("sub");
>   chroot("sub");
>   chdir("./../../../../../../../..");

After you do a chroot(), you need to chdir *into* the root. The reason
chroot() itself doesn't do that is simple: you may still be doing
various setup stuff.

But your example is just stupid. Yes, chroot'ed environments can
generally be escaped, but your example escape is simply because you
didn't use chroot() correctly.

So learn this pattern: every time you use chroot, add a simple

  chdir("/");

immediately after the chroot call.

Then, if you decide that you want to do some setup in between the two
(like the interface allows), that's fine, but always start off with
that "chroot+chdir" pattern.

(Similarly, if it turns out that you want to chdir somewhere else,
like "/home/user" after the chroot, then you can obviously remove the
now superfluous chdir("/"), but you always conceptually start off with
that chroot/chdir pair)

             Linus
