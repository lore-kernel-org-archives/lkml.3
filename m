Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLaKNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 05:13:02 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:47294 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaKM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 05:12:59 -0500
MIME-Version: 1.0
In-Reply-To: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
Date: Wed, 31 Dec 2014 12:12:58 +0200
Message-ID: <CAHp75VcRmm3raZ8juLJJOyuDpuxLLg44UHNprwQ=b2hhvqHOsA@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86: Add IMR support to Quark/Galileo
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 7:23 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:
> This patchset adds an IMR driver to the kernel plus platform code for
> Intel Galileo Gen1/Gen2 boards.

[]

> Bryan O'Donoghue (2):
>   x86: Add Isolated Memory Regions for Quark X1000
>   platform/x86 Add Intel Galileo platform specific setup

I'm going to review this soon, but here few comments below.

>  arch/x86/Kconfig                     |  23 ++
>  arch/x86/include/asm/imr.h           |  79 ++++++
>  arch/x86/include/asm/intel-quark.h   |  31 ++

Could it be just a quark.h? Like for ce4100.
Those intel- prefixes in the modules looks awkward especially when
pathname consists x86 already.

>  arch/x86/kernel/Makefile             |   1 +
>  arch/x86/kernel/imr.c                | 529 +++++++++++++++++++++++++++++++++++
>  drivers/platform/x86/Kconfig         |  15 +
>  drivers/platform/x86/Makefile        |   1 +
>  drivers/platform/x86/intel_galileo.c | 175 ++++++++++++

Here what about to make an hierarchy like:
intel/galileo.c
intel/mid/... would be those modules with intel_mid_ prefixes in
future. See my proposal regarding to drivers/mfd [1]

>  8 files changed, 854 insertions(+)
>  create mode 100644 arch/x86/include/asm/imr.h
>  create mode 100644 arch/x86/include/asm/intel-quark.h
>  create mode 100644 arch/x86/kernel/imr.c
>  create mode 100644 drivers/platform/x86/intel_galileo.c


[1] http://www.spinics.net/lists/kernel/msg1886819.html


-- 
With Best Regards,
Andy Shevchenko
