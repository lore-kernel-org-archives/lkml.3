Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3HKQwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:52:12 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38019
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab3HKQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717949"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/16] arch/arm/mach-pxa/vpac270.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:46 +0200
Message-Id: <1376239917-15594-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 arch/arm/mach-pxa/vpac270.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/vpac270.c b/arch/arm/mach-pxa/vpac270.c
index aa89488..bb5ceef 100644
--- a/arch/arm/mach-pxa/vpac270.c
+++ b/arch/arm/mach-pxa/vpac270.c
@@ -465,7 +465,8 @@ static struct i2c_board_info __initdata vpac270_i2c_devs[] = {
 
 static void __init vpac270_rtc_init(void)
 {
-	i2c_register_board_info(0, ARRAY_AND_SIZE(vpac270_i2c_devs));
+	i2c_register_board_info(0, vpac270_i2c_devs,
+				ARRAY_SIZE(vpac270_i2c_devs));
 }
 #else
 static inline void vpac270_rtc_init(void) {}
@@ -678,7 +679,8 @@ static struct i2c_board_info __initdata vpac270_pi2c_board_info[] = {
 
 static void __init vpac270_pmic_init(void)
 {
-	i2c_register_board_info(1, ARRAY_AND_SIZE(vpac270_pi2c_board_info));
+	i2c_register_board_info(1, vpac270_pi2c_board_info,
+				ARRAY_SIZE(vpac270_pi2c_board_info));
 }
 #else
 static inline void vpac270_pmic_init(void) {}
@@ -690,7 +692,7 @@ static inline void vpac270_pmic_init(void) {}
  ******************************************************************************/
 static void __init vpac270_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(vpac270_pin_config));
+	pxa2xx_mfp_config(vpac270_pin_config, ARRAY_SIZE(vpac270_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);

