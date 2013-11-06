Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3KFWan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:30:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:32787 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3KFWal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:30:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
	<CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
Date: Wed, 6 Nov 2013 16:30:40 -0600
Message-ID: <CAHCPf3umr-v+2oWyjG3F0W=+qu_NoXVVSN95RAJdrjaLxWAfow@mail.gmail.com>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
From: Matt Sealey <neko@bakuhatsu.net>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Paul Moore <paul@paul-moore.com>,
        Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 6:14 PM, Kees Cook <keescook@chromium.org> wrote:
>
> Alternatively, CONFIG_SECCOMP_FILTER could depend on
> !CONFIG_OABI_COMPAT. That seems like the least work, given the desire
> to kill OABI in the real world. (Though I would note that at least
> Ubuntu's ARM kernels build with CONFIG_OABI_COMPAT; Chrome OS does
> not.)

I think CONFIG_OABI_COMPAT probably leaked in from the original
configurations of the kernel taken from Debian.

There were several big decisions they made (build for ARMv5 soft
float, then switch to ARMv7 softfp, then switch to ARMv7 hardfp, then
switch to using THUMB2 kernels) which would have just broken OABI
binaries at every step of the way since they had some subtle
implications in kernel configuration (note: Ubuntu have never, ever
enabled FPA emulation in the kernel, and all Debian's OABI userspace
is built for FPA, for example. A good chunk of the original Debian arm
port probably would just pitch a SIGILL if you ran it under an Ubuntu
kernel).

I would ignore anyone who enables it in a distribution, since they
probably weren't intending to enable it in the first place, and never
noticed the.. what.. 3-4KiB it adds to the kernel?

Matt Sealey <neko@bakuhatsu.net>
