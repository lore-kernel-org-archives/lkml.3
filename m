Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbbAOVWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:58246 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbbAOVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:27 -0500
Message-Id: <20150115210458.625399149@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 00/23] x86: Cleanup apic/ioapic/x2apic setup code
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reviewing Jiangs interrupt remapping patch set, I had several
serious WTF moments when trying to understand what that code is doing.

The main issues I've seen are:

    - Blindly copy and pasted code

    - Random places which initialize bits and pieces

    - Code which got mindlessly expanded with duct tape and glue
      without considering readability and maintainability.

    - Missing inline stubs which result in a ifdef nightmare

    - Superflous inline stubs to artificially avoid sensible ifdefs

The deeper I looked the more I started to get grumpy about that maze
and finally sat down and cleaned it up seriously. One bug I fixed on
the way (surprise, surprise) got folded into Jiangs series which is
now in tip/x86/apic. The other one is not that crucial and cant be
fixed in the previous code without adding more mess.

The following patch series applies on top of tip/x86/apic. It cleans
up and consolidates the apic/ioapic/x2apic setup functions.

Please give it a proper review and testing.

Thanks,

	tglx
---
 arch/x86/include/asm/smpboot_hooks.h |   68 ------
 tip/arch/x86/include/asm/apic.h      |   57 +----
 tip/arch/x86/include/asm/io_apic.h   |    5 
 tip/arch/x86/kernel/apic/apic.c      |  395 ++++++++++++++++++-----------------
 tip/arch/x86/kernel/apic/io_apic.c   |   13 -
 tip/arch/x86/kernel/cpu/common.c     |    2 
 tip/arch/x86/kernel/smpboot.c        |  113 +++++-----
 tip/init/main.c                      |   14 -
 8 files changed, 308 insertions(+), 359 deletions(-)

