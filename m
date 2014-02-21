Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaBUM2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:28:14 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56541 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaBUM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:26:16 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-a2-530745e6ba5d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v5 06/11] drivers: of: initialize and assign reserved memory to
 newly created devices
Date: Fri, 21 Feb 2014 13:25:22 +0100
Message-id: <1392985527-6260-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
References: <1392985527-6260-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAy2RW0iTYRzGfb99J4eTz6XxaSYxqosgdSH5UpbeWK9XRbvKiJxuqeGmbSrq
	jTqcuOXmIVORZS4PwXBOlqBbCrqGSpll85SHxCRLnaYpRLZJLrv7/Z//77l6aA6/Bg+jM+W5
	UoVcnCUgufjbg5Gp86uJlChaUxoOvbXDFNxWqTnwR0clgM+c4wSschsJOOjpA9Ctq8ChrWsL
	wHcqNwV7NY0U3JtcxqB1ZZqAxvI2HLrsBhKanYsU7F4bwmD7zAQGW0bKCOhpiIBvZnZJ2Ols
	pWB1gxmH6gEnBb29VhyuD5Xj0NK4gUOT3QPg2s4onhCOOps7AfqzXwvQxuNqgFx6HYZsTYsU
	qnSXEchq0pBoYbqfRC/bitH8wQoHTY6qCNTlWcdQlTcaPbXrAdL3mADatUbcDErmxkmkWZn5
	UkXU1RRuRkfdOJHzPbBgZ7YELwHdAVrgT7NMDNvz8QtxxMfZD58tpBZwaT7TDtgXc+3/j0cY
	O6+zUT6LZISsdlNL+jiYMQJ2txn3SRxmiWQrJiox3+MYk87urx38K+DMGdaw9OQwp2kec51V
	a5APWeYUa6iN8xn+DGLHBr9Rvph/aHRVPKgGvBbgZwIh0ry0HGVqukwYqRTLlHny9Mi0bJkV
	HM241wdahy85AEMDQQAvhyVFfEKcryyUOQBLcwTBvKEoSsTnScSFRVJF9j1FXpZU6QAY7R9W
	AvxUr62nYxYmzfKQAfu1y0xU6BUyzvK1zNvaNDWSoA4qEn3SuZLrzMyN0k1jmolzoviOSzN1
	N/6hpHQ7aS7RidWnFL666Lgd378qef9LeFaWO8i16R2/Lam2+qRAr2nr53Ls86YQQdVJ+2zN
	rbHY6FB1wazogoHbvtBSfF/mEODKDLHwHEehFP8FvCsfn6QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use recently introduced of_reserved_mem_device_init() function to
automatically assign respective reserved memory region to the newly created
platform and amba device.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/platform.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1daebefa..3df0b1826e8b 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -21,6 +21,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 
 const struct of_device_id of_default_bus_match_table[] = {
@@ -220,6 +221,8 @@ static struct platform_device *of_platform_device_create_pdata(
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
@@ -227,6 +230,7 @@ static struct platform_device *of_platform_device_create_pdata(
 
 	if (of_device_add(dev) != 0) {
 		platform_device_put(dev);
+		of_reserved_mem_device_release(&dev->dev);
 		return NULL;
 	}
 
@@ -282,6 +286,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	else
 		of_device_make_bus_id(&dev->dev);
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* Allow the HW Peripheral ID to be overridden */
 	prop = of_get_property(node, "arm,primecell-periphid", NULL);
 	if (prop)
@@ -308,6 +314,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	return dev;
 
 err_free:
+	of_reserved_mem_device_release(&dev->dev);
 	amba_device_put(dev);
 	return NULL;
 }
-- 
1.7.9.5

