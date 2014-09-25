Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaIYHFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:05:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51848 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaIYHFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:05:43 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ed-5423bec4896e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] power: max14577: Fix circular config SYSFS dependency
Date: Thu, 25 Sep 2014 09:05:31 +0200
Message-id: <1411628731-8458-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t/xy7pH9imHGCy/qGYx6cl7ZouJKycz
	W7x+YWhx/+tRRovLu+awWXzuPcJosXXvVXaL07tLHDg8Gm/cYPPYOesuu8fmFVoem1Z1snnc
	ubaHzaNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyNpzcyFrQy1Ox7kkjSwPjFq4uRk4OCQET
	iY/Nd1ggbDGJC/fWs3UxcnEICSxllLi/9y8ThNPHJLHjWSMTSBWbgLHE5uVLwKpEBHYzSkyY
	uhysnVmgTqJ79Xx2EFtYwE3i6cJWNhCbRUBV4vWJZawgNi9QfMeeflaIdXISJ49NZp3AyL2A
	kWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgAfd3BuPSY1SFGAQ5GJR5eD3/lECHWxLLi
	ytxDjBIczEoivNu2AoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwXtzH6bj9lm6kvNXNqV+4Hh7q
	Fp98d9+WVe+cywr1bv/wKZ9wY4KZTebeGZ1TClPltiYY+FbmRizVEvlV8tRs9Q/RJ4/ZumKn
	nLNm5Jq75u++vmMmTIYTGwwOrRCV/sYTpqTtvS6x7bvqr7cPef3Mv/xhrk3tMtNoXBP36lpJ
	81xTTp37CQ+1lViKMxINtZiLihMBk8bbQv4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the max14577 charger driver depending on SYSFS instead selecting
it. This fixes warning on x86_64 with allmodconfig:

scripts/kconfig/conf --allmodconfig Kconfig
fs/sysfs/Kconfig:1:error: recursive dependency detected!
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CHARGER_MAX14577
drivers/power/Kconfig:327:	symbol CHARGER_MAX14577 depends on POWER_SUPPLY
drivers/power/Kconfig:1:	symbol POWER_SUPPLY is selected by HID_SONY
drivers/hid/Kconfig:638:	symbol HID_SONY depends on NEW_LEDS
drivers/leds/Kconfig:8:	symbol NEW_LEDS is selected by SENSORS_APPLESMC
drivers/hwmon/Kconfig:299:	symbol SENSORS_APPLESMC depends on HWMON
drivers/hwmon/Kconfig:5:	symbol HWMON is selected by EEEPC_LAPTOP
drivers/platform/x86/Kconfig:496:	symbol EEEPC_LAPTOP depends on HOTPLUG_PCI
drivers/pci/hotplug/Kconfig:5:	symbol HOTPLUG_PCI depends on SYSFS

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/power/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 04e1d2fe2201..0108c2af005b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -327,7 +327,7 @@ config CHARGER_MANAGER
 config CHARGER_MAX14577
 	tristate "Maxim MAX14577/77836 battery charger driver"
 	depends on MFD_MAX14577
-	select SYSFS
+	depends on SYSFS
 	help
 	  Say Y to enable support for the battery charger control sysfs and
 	  platform data of MAX14577/77836 MUICs.
-- 
1.9.1

