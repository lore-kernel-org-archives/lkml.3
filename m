Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811Ab3BSXUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:20:47 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41220 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422Ab3BSXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130219124038.365937990@linutronix.de>
References: <20130219124038.365937990@linutronix.de>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 19 Feb 2013 18:20:13 -0500
X-Google-Sender-Auth: F5_UrN4JX2Yzj_mTTSUoJx1GlZc
Message-ID: <CAP=VYLoAzDbFdnLdXafv8dJSTg6PDm2DDSvWAbdcv_TKTrbsFg@mail.gmail.com>
Subject: Re: [patch 1/1] early_printk: Consolidate random copies of identical code
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 7:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The early console implementations are the same all over the
> place. Move the print function to kernel/printk and get rid of the
> copies.

Applied to 3.8, no new compile warnings for ppc32, boot tested with
CONFIG_EARLY_PRINTK=y and 8250 console on sbc8548 (ppc32).

Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Paul.
--

>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: x86@kernel.org
>
> ---
>  arch/arm/kernel/early_printk.c        |   17 +++--------------
>  arch/blackfin/kernel/early_printk.c   |    2 --
>  arch/microblaze/kernel/early_printk.c |   26 ++++----------------------
>  arch/mips/kernel/early_printk.c       |   11 +++++------
>  arch/powerpc/kernel/udbg.c            |    6 ++----
>  arch/sh/kernel/sh_bios.c              |    2 --
>  arch/sparc/kernel/setup_32.c          |    1 +
>  arch/sparc/kernel/setup_64.c          |    8 +++++++-
>  arch/tile/kernel/early_printk.c       |   27 +++++----------------------
>  arch/um/kernel/early_printk.c         |    8 +++++---
>  arch/unicore32/kernel/early_printk.c  |   12 ++++--------
>  arch/x86/kernel/early_printk.c        |   21 ++-------------------
>  include/linux/console.h               |    1 +
>  include/linux/printk.h                |    6 ++++++
>  kernel/printk.c                       |   30 +++++++++++++++++++++++-------
>  15 files changed, 68 insertions(+), 110 deletions(-)
>
