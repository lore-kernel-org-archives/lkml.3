Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3KFJwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:52:18 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46230 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3KFJwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:52:17 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21114.4427.769890.875410@gargle.gargle.HOWL>
Date: Wed, 6 Nov 2013 10:52:11 +0100
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Paul Moore <paul@paul-moore.com>, Richard Weinberger <richard@nod.at>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        libseccomp-discuss@lists.sourceforge.net,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
In-Reply-To: <20131106004058.GU16735@n2100.arm.linux.org.uk>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
	<CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
	<20131106004058.GU16735@n2100.arm.linux.org.uk>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux writes:
 > OABI compat was meant to allow a transition from OABI to EABI.  While
 > a lot of effort went in to the kernel side of that, which does allow
 > OABI based userspace to boot with an EABI kernel, and allows OABI built
 > test programs to run under an EABI kernel, actually being able to
 > migrate userland is far from trivial - and something that I've never
 > been able to do.  Hence, virtually all my long-running ARM machines
 > here are stuck with OABI, and I don't see that situation ever changing.

I did a live incremental upgrade from OABI to EABI on my systems years
ago.  What I did was to first patch my OABI glibc to look for .so files
in oabi/ subdirectories.  Then I moved all OABI .so files to oabi/
subdirectories, and deleted all OABI static .a libraries.  After that
it was "simply" a matter of rebuilding everything as EABI, in the right
order.  The main advantage over this compared to a bootstrap-from-scratch
(which I've done 4 times on different architectures) was that I had access
to fully functional utilities and build tools from the start.

I _might_ be able to locate the glibc patch I used; do you want it?

/Mikael
