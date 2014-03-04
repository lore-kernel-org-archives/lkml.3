Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbaCDViu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:38:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbaCDUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pekon Gupta <pekon@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.13 020/172] ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND is built as module
Date: Tue,  4 Mar 2014 12:01:44 -0800
Message-Id: <20140304200300.368252242@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

commit 6b187b21c92b6e2c7e8ef0b450181c37a3f31681 upstream.

Fixes: commit bc6b1e7b86f5d8e4a6fc1c0189e64bba4077efe0
       ARM: OMAP: gpmc: add DT bindings for GPMC timings and NAND

OMAP SoC(s) depend on GPMC controller driver to parse GPMC DT child nodes and
register them platform_device for NAND driver to probe later. However this does
not happen if generic MTD_NAND framework is built as module (CONFIG_MTD_NAND=m).

Therefore, when MTD/NAND and MTD/NAND/OMAP2 modules are loaded, they are unable
to find any matching platform_device and remain un-binded. This causes on board
NAND flash to remain un-detected.

This patch causes GPMC controller to parse DT nodes when
CONFIG_MTD_NAND=y || CONFIG_MTD_NAND=m

Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/gpmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1339,7 +1339,7 @@ static void __maybe_unused gpmc_read_tim
 		of_property_read_bool(np, "gpmc,time-para-granularity");
 }
 
-#ifdef CONFIG_MTD_NAND
+#if IS_ENABLED(CONFIG_MTD_NAND)
 
 static const char * const nand_xfer_types[] = {
 	[NAND_OMAP_PREFETCH_POLLED]		= "prefetch-polled",


