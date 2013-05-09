Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab3EIXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:16:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3EIW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [ 05/73] pwm: spear: Fix checking return value of clk_enable() and clk_prepare()
Date: Thu,  9 May 2013 15:24:55 -0700
Message-Id: <20130509222527.054946730@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 563861cd633ae52932843477bb6ca3f1c9e2f78b upstream.

The logic to check return value of clk_enable() and clk_prepare() is reversed,
fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/pwm-spear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -143,7 +143,7 @@ static int spear_pwm_enable(struct pwm_c
 	u32 val;
 
 	rc = clk_enable(pc->clk);
-	if (!rc)
+	if (rc)
 		return rc;
 
 	val = spear_pwm_readl(pc, pwm->hwpwm, PWMCR);
@@ -209,12 +209,12 @@ static int spear_pwm_probe(struct platfo
 	pc->chip.npwm = NUM_PWM;
 
 	ret = clk_prepare(pc->clk);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	if (of_device_is_compatible(np, "st,spear1340-pwm")) {
 		ret = clk_enable(pc->clk);
-		if (!ret) {
+		if (ret) {
 			clk_unprepare(pc->clk);
 			return ret;
 		}


