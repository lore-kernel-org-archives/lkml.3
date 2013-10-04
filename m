Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3JDMfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:35:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15412 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3JDMfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:35:44 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a8-524eb60b1153
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS is
 defined
Date: Fri, 04 Oct 2013 14:35:19 +0200
Message-id: <3702969.8rn3SOscJE@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jAV3ubX5BBj96zSzW7P/JZHG26Q27
	xeVdc9gsPvceYbR48rCPzYHVY/Gel0wefVtWMXocv7GdyePzJrkAligum5TUnMyy1CJ9uwSu
	jOPfHjMXPGev2PLvLmMD43G2LkZODgkBE4ndjY8YIWwxiQv31gPFuTiEBBYxSnQ1roRyWpgk
	fq5oZwapYhOwkpjYvgqog4NDRMBfom2NBkiYWSBdYuKa2+wgtrBAhMSFSUeZQGwWAVWJmzsu
	gNm8ApoSx1d9BVssKuAp8WnSUmaIuKDEj8n3WCDmyEvs2z+VFcLWkli/8zjTBEa+WUjKZiEp
	m4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4LB8Jr2DcVWDxSFGAQ5GJR7eDcW+
	QUKsiWXFlbmHGCU4mJVEeI9P8gsS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1
	OzW1ILUIJsvEwSnVwOjb0cUaKnWzOCbhhf35Pt1MVjkOYyHNmMXJN/LaE5XMnTnmCGxsWxZT
	UcK55liWu8Xrh86Sp27+cUuYJNRwc0a2Za/smT9lUwTePki9oXJGtLVOf4Nipx5rWecqAZ6L
	TRNelDFc7zwRfm0Ty609rpcurNrzS+e2QELUtR1TZXZqGDTla8exK7EUZyQaajEXFScCAMFS
	DtJHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Menu for Texas Instruments thermal support is visible on all
platforms and TI_SOC_THERMAL + TI_THERMAL config options can
be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
config option is selected by SoCs config options to fulfill
EXYNOS_THERMAL config option dependency). Thus the code which
is never used can be build. Fix it by making TI menu dependent
on ARCH_OMAP2PLUS config option.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 57e06a9..a709c63 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
 	  notification methods.
 
 menu "Texas Instruments thermal drivers"
+depends on ARCH_OMAP2PLUS
 source "drivers/thermal/ti-soc-thermal/Kconfig"
 endmenu
 
-- 
1.8.2.3


