Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaIOWLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaIOWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Welling <mwelling@emacinc.com>, Lee Jones <lee.jones@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 106/187] mfd: omap-usb-host: Fix improper mask use.
Date: Mon, 15 Sep 2014 15:08:36 -0700
Message-Id: <1410818997-9432-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Welling <mwelling@emacinc.com>

commit 46de8ff8e80a6546aa3d2fdf58c6776666301a0c upstream.

single-ulpi-bypass is a flag used for older OMAP3 silicon.

The flag when set, can excite code that improperly uses the
OMAP_UHH_HOSTCONFIG_UPLI_BYPASS define to clear the corresponding bit.
Instead it clears all of the other bits disabling all of the ports in
the process.

Signed-off-by: Michael Welling <mwelling@emacinc.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/omap-usb-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 142650f..fcf426d 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -445,7 +445,7 @@ static unsigned omap_usbhs_rev1_hostconfig(struct usbhs_hcd_omap *omap,
 
 		for (i = 0; i < omap->nports; i++) {
 			if (is_ehci_phy_mode(pdata->port_mode[i])) {
-				reg &= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
+				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
 				break;
 			}
 		}
-- 
1.9.1

