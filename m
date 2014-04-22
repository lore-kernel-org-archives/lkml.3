Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaDVJVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:21:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53450 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbaDVJVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:38 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 02/19] usb: phy: msm: Remove __init macro from driver probe method
Date: Tue, 22 Apr 2014 12:20:21 +0300
Message-Id: <1398158438-21579-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This fixes following:

WARNING: drivers/usb/phy/built-in.o(.data+0x68): Section mismatch in reference from the variable msm_otg_driver to the function .init.text:msm_otg_probe()
The variable msm_otg_driver references
the function __init msm_otg_probe()

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 5b37b81..6ae4d2f 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1406,7 +1406,7 @@ static void msm_otg_debugfs_cleanup(void)
 	debugfs_remove(msm_otg_dbg_root);
 }

-static int __init msm_otg_probe(struct platform_device *pdev)
+static int msm_otg_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 	struct resource *res;
--
1.8.3.2

