Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab3BSNDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:03:41 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:46500 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3BSNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:03:39 -0500
Date: Tue, 19 Feb 2013 14:03:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: Re: [patch 1/1] early_printk: Consolidate random copies of identical
 code
Message-ID: <20130219130334.GA11137@gmail.com>
References: <20130219124038.365937990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219124038.365937990@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The early console implementations are the same all over the
> place. Move the print function to kernel/printk and get rid of the
> copies.
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

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
