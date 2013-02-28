Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab3B1Ovj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:51:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3B1Ovd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 137/139] gpio/ich: Add missing spinlock init
Date: Thu, 28 Feb 2013 14:44:47 +0000
Message-Id: <1362062689-2567-138-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit d39a948fef2446cfac3749bbfcfdd536335c3764 upstream.

As reported by CONFIG_DEBUG_SPINLOCK=y.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-ich.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index b7c0651..230814d 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -328,6 +328,7 @@ static int __devinit ichx_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	spin_lock_init(&ichx_priv.lock);
 	res_base = platform_get_resource(pdev, IORESOURCE_IO, ICH_RES_GPIO);
 	if (!res_base || !res_base->start || !res_base->end)
 		return -ENODEV;
-- 
1.8.1.2

