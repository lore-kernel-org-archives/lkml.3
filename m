Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBYMXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:23:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:16828 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbaBYMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:23:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481425050"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: [PATCHv2 5/5] net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip
Date: Tue, 25 Feb 2014 14:22:30 +0200
Message-Id: <1393330950-7283-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com>
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
index ec38884..c4d7c6b 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -156,11 +156,16 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
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
1.9.0.rc3

