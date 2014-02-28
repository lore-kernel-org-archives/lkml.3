Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaB1Nqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:46:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18793 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaB1NnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:43:17 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-3b-531092739b9d
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
Subject: [PATCH v6 06/11] drivers: of: initialize and assign reserved memory to
 newly created devices
Date: Fri, 28 Feb 2014 14:42:51 +0100
Message-id: <1393594976-16728-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/xq7rFkwSCDT5t4LD4O+kYu8WHplZm
	i/fLehgt5h85x2rR/2Yhq8WBPzsYLd70drBY7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaL
	hW1LWCwu75rDZrH2yF12iw0vDzJZLL1+kcliwfEWVos/0+UsTl3/zGax5shidosJ09eyWLTu
	PcJu8Xf7JhaLVwfbWCzWz3jNYrFq1x9Gi5cfT7A4yHismbeG0eP3r0mMHq8nT2D0uNzXy+Sx
	c9Zddo+eNy2sHptWdbJ53Lm2h81j85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYec3f1MXr0bVnF
	6PF5k1yAYBSXTUpqTmZZapG+XQJXxrIp51gLXvBVfLzRwNLAuIGni5GTQ0LAROLMnnXMELaY
	xIV769m6GLk4hASWMkrsm3kayulmkriwYT8bSBWbgKFE19suMFtEYCGjxOd5LCBFzAL32SQ6
	LvYwgSSEBdIlrryeBGRzcLAIqEr0nZcFMXkFPCQ6Z6eDmBICChJzJtmAFHMKeEo0TL/PCmIL
	AVXc/nGdcQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIdH4dQfj0mNWhxgFOBiV
	eHgnePIHC7EmlhVX5h5ilOBgVhLhfdIkECzEm5JYWZValB9fVJqTWnyIkYmDU6qBcWfk9LNe
	Xe7KCjN82pw+X1lyiH87R9bkns5NJTmmSvPrPDc26MdN8S+1vT85RCmhxm1ji1Lgo/1ZE4MU
	L9QkXtrVEWlbpT3ZoyyCsW1R2g7eywLX7y+8vjpZqLLexnvbxP3FLb7fovR3PI1rneXGbbm3
	4ZBW2fXDews+TRVZknlFX9f9p6m4EktxRqKhFnNRcSIA+ZizP6QCAAA=
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

