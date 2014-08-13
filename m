Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHMTlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:41:00 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62426 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:40:59 -0400
Date: Wed, 13 Aug 2014 12:40:47 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Gregory Fong <gregory.0xf0@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Matt Porter <mporter@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: drop ISAR0 workaround for B15
Message-ID: <20140813194047.GA18411@ld-irv-0074>
References: <1407797053-12544-1-git-send-email-gregory.0xf0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407797053-12544-1-git-send-email-gregory.0xf0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Brahma-B15's ISAR0 correcty advertises UDIV/SDIV support in both ARM
and Thumb2 modes (CPUID_EXT_ISAR0=02101110), so we don't need to
manually apply this hwcap.

The code in question actually predates the following commit, which made
our hwcaps unnecessary:

    commit 8164f7af88d9ad3a757bd14f634b23997ee77f6b
    Author: Stephen Boyd <sboyd@codeaurora.org>
    Date:   Mon Mar 18 19:44:15 2013 +0100

        ARM: 7680/1: Detect support for SDIV/UDIV from ISAR0 register

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
---
Supersedes Gregory's previous patch.

This addresses some very old review comments from Mark and Will:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/225895.html
  http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/227916.html

 arch/arm/mm/proc-v7.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index b5d67db20897..b3a947863ac7 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -570,7 +570,7 @@ __v7_ca15mp_proc_info:
 __v7_b15mp_proc_info:
 	.long	0x420f00f0
 	.long	0xff0ffff0
-	__v7_proc __v7_b15mp_setup, hwcaps = HWCAP_IDIV
+	__v7_proc __v7_b15mp_setup
 	.size	__v7_b15mp_proc_info, . - __v7_b15mp_proc_info
 
 	/*
-- 
1.9.1
