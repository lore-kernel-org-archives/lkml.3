Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3I3NVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:21:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13732 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3I3NV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:21:28 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-5f-52497ad7399e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] x86/geode: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:21:15 +0200
Message-id: <18427893.G5JGWn465D@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQd3rVZ5BBpP7TSymbRS3ONv0ht3i
	8q45bBaXDixgsti8aSqzxY8Nj1kd2Dw2repk83h37hy7x/t9V9k8+rasYvT4vEnO40TLF9YA
	tigum5TUnMyy1CJ9uwSujE2bGpgLPvFVnG3xb2C8w9PFyMkhIWAisWnGDCYIW0ziwr31bF2M
	XBxCAtMZJT49ewzltDBJfJ6xkRWkik3ASmJi+ypGEFtEQENi46VbzCBFzAILGSWObdzNDpIQ
	FnCVmL74LlA3BweLgKpE5/UiEJNXQEvidKMYSIWogKfEp0lLmUFsXgFBiR+T77GA2MwC8hL7
	9k9lhbC1JNbvPM40gZFvFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OGCfSe1gXNlgcYhRgINRiYd3wnKPICHWxLLiytxDjBIczEoivOJlnkFCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGGs0vjx4Y8V4bSPHdZkPz968zvku
	5htyzLdr1iW1Jc/FZh7c/iZ5YWHj57tT0rYVT/7AvoXniQmz6NQ+Md9Wqy8bSyNtrCu2t13b
	ufI3y3yDjXlz+HxrWs48OB330FM7N9hXd94dD+XqMx2BAT8X63Ezrzh+T8SxvHdR8Rvu5oDw
	/VbXrwZbv1ViKc5INNRiLipOBACIPrNnVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/x86/platform/geode/alix.c    | 2 +-
 arch/x86/platform/geode/geos.c    | 2 +-
 arch/x86/platform/geode/net5501.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
index 90e23e7..76b6632 100644
--- a/arch/x86/platform/geode/alix.c
+++ b/arch/x86/platform/geode/alix.c
@@ -98,7 +98,7 @@ static struct platform_device alix_leds_dev = {
 	.dev.platform_data = &alix_leds_data,
 };
 
-static struct __initdata platform_device *alix_devs[] = {
+static struct platform_device *alix_devs[] __initdata = {
 	&alix_buttons_dev,
 	&alix_leds_dev,
 };
diff --git a/arch/x86/platform/geode/geos.c b/arch/x86/platform/geode/geos.c
index c2e6d53..aa733fb 100644
--- a/arch/x86/platform/geode/geos.c
+++ b/arch/x86/platform/geode/geos.c
@@ -87,7 +87,7 @@ static struct platform_device geos_leds_dev = {
 	.dev.platform_data = &geos_leds_data,
 };
 
-static struct __initdata platform_device *geos_devs[] = {
+static struct platform_device *geos_devs[] __initdata = {
 	&geos_buttons_dev,
 	&geos_leds_dev,
 };
diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
index 646e3b5..927e38c 100644
--- a/arch/x86/platform/geode/net5501.c
+++ b/arch/x86/platform/geode/net5501.c
@@ -78,7 +78,7 @@ static struct platform_device net5501_leds_dev = {
 	.dev.platform_data = &net5501_leds_data,
 };
 
-static struct __initdata platform_device *net5501_devs[] = {
+static struct platform_device *net5501_devs[] __initdata = {
 	&net5501_buttons_dev,
 	&net5501_leds_dev,
 };
-- 
1.8.2.3


