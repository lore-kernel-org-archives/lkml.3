Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaCDUFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:05:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaCDUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pekon Gupta <pekon@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.10 12/97] ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ONENAND is built as module
Date: Tue,  4 Mar 2014 12:03:25 -0800
Message-Id: <20140304200346.501810944@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

commit 980386d2d6d49e0b42f48550853ef1ad6aa5d79a upstream.

Fixes: commit 75d3625e0e86b2d8d77b4e9c6f685fd7ea0d5a96
       ARM: OMAP2+: gpmc: add DT bindings for OneNAND

OMAP SoC(s) depend on GPMC controller driver to parse GPMC DT child nodes and
register them platform_device for ONENAND driver to probe later. However this does
not happen if generic MTD_ONENAND framework is built as module (CONFIG_MTD_ONENAND=m).

Therefore, when MTD/ONENAND and MTD/ONENAND/OMAP2 modules are loaded, they are unable
to find any matching platform_device and remain un-binded. This causes on board
ONENAND flash to remain un-detected.

This patch causes GPMC controller to parse DT nodes when
CONFIG_MTD_ONENAND=y || CONFIG_MTD_ONENAND=m

Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/gpmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1391,7 +1391,7 @@ static int gpmc_probe_nand_child(struct
 }
 #endif
 
-#ifdef CONFIG_MTD_ONENAND
+#if IS_ENABLED(CONFIG_MTD_ONENAND)
 static int gpmc_probe_onenand_child(struct platform_device *pdev,
 				 struct device_node *child)
 {


