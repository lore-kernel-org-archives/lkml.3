Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3CRVHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:07:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3CRVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 34/75] w1-gpio: remove erroneous __exit and __exit_p()
Date: Mon, 18 Mar 2013 14:06:57 -0700
Message-Id: <20130318210512.685389601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 01230551e7c2fb9a1c2519b356d703851049cbe0 upstream.

Commit 8a1861d997 ("w1-gpio: Simplify & get rid of defines") changed
(apparently unknowingly) the driver to a hotpluggable platform-device
driver but did not not update the section markers for probe and remove
(to __devinit/exit, which have since been removed). A later commit fixed
the section mismatch for probe, but left remove marked with __exit.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/w1/masters/w1-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -158,7 +158,7 @@ static int w1_gpio_probe(struct platform
 	return err;
 }
 
-static int __exit w1_gpio_remove(struct platform_device *pdev)
+static int w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
@@ -210,7 +210,7 @@ static struct platform_driver w1_gpio_dr
 		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
 	.probe = w1_gpio_probe,
-	.remove	= __exit_p(w1_gpio_remove),
+	.remove	= w1_gpio_remove,
 	.suspend = w1_gpio_suspend,
 	.resume = w1_gpio_resume,
 };


