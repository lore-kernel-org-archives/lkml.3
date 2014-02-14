Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaBNBHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:07:05 -0500
Received: from smtp.outflux.net ([198.145.64.163]:39789 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaBNBHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:07:02 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: keescook@chromium.org, Russell King <linux@arm.linux.org.uk>,
        Laura Abbott <lauraa@codeaurora.org>,
        Larry Bassel <lbassel@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Simon Baatz <gmbnomis@gmail.com>, Nicolas Pitre <nico@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>, Will Deacon <will.deacon@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jiang Liu <liuj97@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: mm: allow for stricter kernel memory perms
Date: Thu, 13 Feb 2014 17:04:08 -0800
Message-Id: <1392339850-18686-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches allows the ARM kernel page tables to gain better
permission separation. With a fixed[1] CONFIG_ARM_PTDUMP enabled, you
can see the before and after in /sys/kernel/debug/kernel_page_tables.

Before:
---[ Kernel Mapping ]---
0xc0000000-0xc0800000           8M     RW x  SHD
0xc0800000-0xc1e00000          22M     RW NX SHD
0xc2000000-0xc3000000          16M     RW x  SHD
0xc3800000-0xd1000000         216M     RW x  SHD
0xd1800000-0xef800000         480M     RW x  SHD

After:
---[ Kernel Mapping ]---
0xc0000000-0xc0100000           1M     RW NX SHD
0xc0100000-0xc0700000           6M     ro x  SHD
0xc0700000-0xc0a00000           3M     ro NX SHD
0xc0a00000-0xc1e00000          20M     RW NX SHD
0xc2000000-0xc3000000          16M     RW NX SHD
0xc3800000-0xd1000000         216M     RW NX SHD
0xd1800000-0xef800000         480M     RW NX SHD

This is available via CONFIG_ARM_KERNMEM_PERMS and CONFIG_DEBUG_RODATA.
The latter exists to match the x86 option of the same name, and is
left as a configurable since each additional region adds more potential
memory padding.

The series is based on earlier work from Brad Spengler, Larry Bassel,
and Laura Abbott.

Thanks,

-Kees

[1] these patches are needed to get the correct output:
    https://lkml.org/lkml/2014/2/12/662
    https://lkml.org/lkml/2014/2/12/663

