Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbaIOUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:09:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaIOTrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Welling <mwelling@emacinc.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.10 12/71] mfd: omap-usb-host: Fix improper mask use.
Date: Mon, 15 Sep 2014 12:26:10 -0700
Message-Id: <20140915192639.124774954@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192638.702282534@linuxfoundation.org>
References: <20140915192638.702282534@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/omap-usb-host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -445,7 +445,7 @@ static unsigned omap_usbhs_rev1_hostconf
 
 		for (i = 0; i < omap->nports; i++) {
 			if (is_ehci_phy_mode(pdata->port_mode[i])) {
-				reg &= OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
+				reg &= ~OMAP_UHH_HOSTCONFIG_ULPI_BYPASS;
 				break;
 			}
 		}


