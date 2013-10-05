Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3JEXWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:22:19 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:61111 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3JEXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
References: <87li281wx6.fsf_-_@xmission.com>
	<1381014462.1974.162@driftwood>
	<CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
Date: Sat, 5 Oct 2013 16:22:15 -0700
X-Google-Sender-Auth: KPLvIdeZz3S5VEZ9ex6bcHo6KTQ
Message-ID: <CA+55aFxgUMnZts-RXFh1qL1u+De_HNdMrC34skyWurbzvqpUdg@mail.gmail.com>
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

On Sat, Oct 5, 2013 at 4:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So learn this pattern: every time you use chroot, add a simple
>
>   chdir("/");
>
> immediately after the chroot call.

.. btw, also make sure that you close all non-essential file
descriptors. Having any open directory file descriptors pointing to
outside the chroot is also a classic escape.

Even then, escaping chroot is usually fairly easy. Making a
escape-proof chroot is really quite hard. Basically impossible if you
allow root.

                 Linus
