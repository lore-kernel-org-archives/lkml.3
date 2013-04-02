Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3DBTtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:49:36 -0400
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:54548 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932401Ab3DBTte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:49:34 -0400
X-Greylist: delayed 8700 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 15:49:34 EDT
From: Boris BREZILLON <linux-arm@overkiz.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Boris BREZILLON <linux-arm@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH RESEND] pwm: pwm-atmel-tcb: pinctrl support
Date: Tue,  2 Apr 2013 18:09:46 +0200
Message-Id: <1364918986-15336-1-git-send-email-linux-arm@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 269371554828039190
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup tcb pins using pinctrl subsystem.

Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
---
 drivers/pwm/pwm-atmel-tcb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 16cb530..985b7bf 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -21,6 +21,7 @@
 #include <linux/pwm.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
+#include <linux/pinctrl/consumer.h>
 
 #define NPWM	6
 
@@ -365,6 +366,7 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	struct atmel_tcb_pwm_chip *tcbpwm;
 	struct device_node *np = pdev->dev.of_node;
 	struct atmel_tc *tc;
+	struct pinctrl *pinctrl;
 	int err;
 	int tcblock;
 
@@ -389,6 +391,13 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl)) {
+		atmel_tc_free(tc);
+		dev_err(&pdev->dev, "failed to get pinctrl config\n");
+		return PTR_ERR(pinctrl);
+	}
+
 	tcbpwm->chip.dev = &pdev->dev;
 	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
 	tcbpwm->chip.of_xlate = of_pwm_xlate_with_flags;
-- 
1.7.9.5

