Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaDAOEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:04:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:48374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaDAOE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:04:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,772,1389772800"; 
   d="scan'208";a="504351144"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCHv3 4/5] net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip
Date: Tue,  1 Apr 2014 17:02:55 +0300
Message-Id: <1396360976-28657-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds ACPI IDs for Broadcom bluetooth chip BCM43241 used
on various Baytrail based boards such as Lenovo Miix 2 and
Asus Transformer Book T100TA.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index fec3dbf..436bffb 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -171,11 +171,16 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI
 static const struct acpi_device_id rfkill_acpi_match[] = {
+	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E39", RFKILL_TYPE_BLUETOOTH },
+	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
 	{ "BCM4752", RFKILL_TYPE_GPS },
 	{ "LNV4752", RFKILL_TYPE_GPS },
 	{ },
 };
+#endif
 
 static struct platform_driver rfkill_gpio_driver = {
 	.probe = rfkill_gpio_probe,
-- 
1.9.1

