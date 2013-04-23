Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3DWWPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:15:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3DWVw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 19/42] ARM: clk-imx35: Bugfix iomux clock
Date: Tue, 23 Apr 2013 14:52:17 -0700
Message-Id: <20130423215207.500480672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Pargmann <mpa@pengutronix.de>

commit cab1e0a36c9dd0b0671fb84197ed294513f5adc1 upstream.

This patch enables iomuxc_gate clock. It is necessary to be able to
reconfigure iomux pads. Without this clock enabled, the
clk_disable_unused function will disable this clock and the iomux pads
are not configurable anymore. This happens at every boot. After a reboot
(watchdog system reset) the clock is not enabled again, so all iomux pad
reconfigurations in boot code are without effect.

The iomux pads should be always configurable, so this patch always
enables it.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx35.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-imx/clk-imx35.c
+++ b/arch/arm/mach-imx/clk-imx35.c
@@ -266,6 +266,7 @@ int __init mx35_clocks_init()
 	clk_prepare_enable(clk[iim_gate]);
 	clk_prepare_enable(clk[emi_gate]);
 	clk_prepare_enable(clk[max_gate]);
+	clk_prepare_enable(clk[iomuxc_gate]);
 
 	/*
 	 * SCC is needed to boot via mmc after a watchdog reset. The clock code


