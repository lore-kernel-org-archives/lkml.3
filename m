Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3EaKIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:08:39 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:34991 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab3EaKIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:08:32 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [RFC] clocksource: Add clocksource drivers menu.
Date: Fri, 31 May 2013 10:59:38 +0100
Message-Id: <1369994378-28163-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds "Clocksource drivers" menu to clocksource drivers.
The reason to add this is because, some of the clocksource Kconfig
options like *SHED_CLK ones are selectable and they appear at random
places in the device drivers menu.
These options can be more than one option for multiplatform case, so I
think it will be neat to get a menu to clocksource drivers itself.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
Hi All, 
I noticed that if my clock source has a selectable option, it appears as an
option under device drivers menu without any sub-menu, which seems to be bit
confusing and un-usual.

Having a dedicated menu for clock source makes much sense as these options might
grow as we have more than one clocksource driver as part of multi-platform
builds.

Thanks,
srini

 drivers/clocksource/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index f151c6c..2e0f37b 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -1,3 +1,5 @@
+menu "Clocksource drivers"
+
 config CLKSRC_OF
 	bool
 
@@ -85,3 +87,5 @@ config CLKSRC_SAMSUNG_PWM
 	  Samsung S3C, S5P and Exynos SoCs, replacing an earlier driver
 	  for all devicetree enabled platforms. This driver will be
 	  needed only on systems that do not have the Exynos MCT available.
+
+endmenu
-- 
1.7.6.5

