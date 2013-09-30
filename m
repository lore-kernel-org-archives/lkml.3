Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3I3NDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:03:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12050 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3I3NDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:03:05 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-9e-52497688a12b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] ARM: ks8695: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:02:48 +0200
Message-id: <1551134.v305P4LSfh@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAd2OMs8gg96D/BaHLs9msjjb9Ibd
	YtPja6wWl3fNYXNg8di8pN6jb8sqRo9thzg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqY0XqRreAJ
	V8Wba8tZGxi7ObsYOTgkBEwkZjw07WLkBDLFJC7cW8/WxcjFISSwiFFi94JZ7BBOC5PEhe8z
	WUGq2ASsJCa2r2IEaRYRUJaYsrYOJMwsUCzRM/cKO4gtLOAuce7qJLByFgFViZZnLSwgNq+A
	psSHpW1gcVEBT4lPk5YyQ8QFJX5MvscCMUdeYt/+qawQtpbE+p3HmSYw8s1CUjYLSdksJGUL
	GJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH4TPpHYyrGiwOMQpwMCrx8Fos9QgSYk0s
	K67MPcQowcGsJMI7IcszSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILU
	IpgsEwenVAMjH5PfYrOnNw2yu4Wj3r8T01dd2z9bQvu8Am/ejVPNCmte8PS+mqb/6+2cWpYT
	Lit/y7577RLB8L5exsXrRWCXdFWGfsTCErFQ1ZZkLu+c6S4s86fvTd/SYMH2NfGqTolhgYki
	xxSWE0d6eLSis5gueTOcO2vc9ErI0PK66B9HVo7r12rLTZRYijMSDbWYi4oTAdmthj8/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-ks8695/board-og.c | 2 +-
 arch/arm/mach-ks8695/cpu.c      | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ks8695/board-og.c b/arch/arm/mach-ks8695/board-og.c
index 002bc61..9204f5a 100644
--- a/arch/arm/mach-ks8695/board-og.c
+++ b/arch/arm/mach-ks8695/board-og.c
@@ -79,7 +79,7 @@ static void __init og_pci_bus_reset(void)
 #define	S8250_VIRT	0xf4000000
 #define	S8250_SIZE	0x00100000
 
-static struct __initdata map_desc og_io_desc[] = {
+static struct map_desc og_io_desc[] __initdata = {
 	{
 		.virtual	= S8250_VIRT,
 		.pfn		= __phys_to_pfn(S8250_PHYS),
diff --git a/arch/arm/mach-ks8695/cpu.c b/arch/arm/mach-ks8695/cpu.c
index ddb2422..9618654 100644
--- a/arch/arm/mach-ks8695/cpu.c
+++ b/arch/arm/mach-ks8695/cpu.c
@@ -33,8 +33,7 @@
 #include <mach/regs-sys.h>
 #include <mach/regs-misc.h>
 
-
-static struct __initdata map_desc ks8695_io_desc[] = {
+static struct map_desc ks8695_io_desc[] __initdata = {
 	{
 		.virtual	= (unsigned long)KS8695_IO_VA,
 		.pfn		= __phys_to_pfn(KS8695_IO_PA),
-- 
1.8.2.3


