Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaIZKWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:22:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbaIZJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:15 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Welling <mwelling@emacinc.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/142] mfd: omap-usb-host: Fix improper mask use.
Date: Fri, 26 Sep 2014 11:44:17 +0200
Message-Id: <8a9f2a150ef49da8cfc8cde47aa1962a3bb72ed3.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Welling <mwelling@emacinc.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 46de8ff8e80a6546aa3d2fdf58c6776666301a0c upstream.

single-ulpi-bypass is a flag used for older OMAP3 silicon.

The flag when set, can excite code that improperly uses the
OMAP_UHH_HOSTCONFIG_UPLI_BYPASS define to clear the corresponding bit.
Instead it clears all of the other bits disabling all of the ports in
the process.

Signed-off-by: Michael Welling <mwelling@emacinc.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/omap-usb-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 29ee54d68512..5dd653f9b094 100644
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
2.1.0

