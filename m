Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3FEVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:55:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab3FEVfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 064/127] ARM: SAMSUNG: Export MIPI CSIS/DSIM PHY control functions
Date: Wed,  5 Jun 2013 14:33:51 -0700
Message-Id: <20130605213225.216632428@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit 30da66eafc015cd7e952829eaf8f86d8680f86d9 upstream.

The s5p_csis_phy_enable/s5p_dsim_phy_enable functions are now used
directly by corresponding drivers and thus need to be exported so
the drivers can be built as modules.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-samsung/setup-mipiphy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/plat-samsung/setup-mipiphy.c
+++ b/arch/arm/plat-samsung/setup-mipiphy.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
@@ -50,8 +51,10 @@ int s5p_csis_phy_enable(int id, bool on)
 {
 	return __s5p_mipi_phy_control(id, on, S5P_MIPI_DPHY_SRESETN);
 }
+EXPORT_SYMBOL(s5p_csis_phy_enable);
 
 int s5p_dsim_phy_enable(struct platform_device *pdev, bool on)
 {
 	return __s5p_mipi_phy_control(pdev->id, on, S5P_MIPI_DPHY_MRESETN);
 }
+EXPORT_SYMBOL(s5p_dsim_phy_enable);


