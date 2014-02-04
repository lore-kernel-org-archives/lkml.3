Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaBDMLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:11:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54957 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaBDMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:10:23 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-8f-52f0d8ada6cf
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v2 4/5] ARM: init: add support for reserved memory defined by
 device tree
Date: Tue, 04 Feb 2014 13:09:32 +0100
Message-id: <1391515773-6112-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t9jAd11Nz4EGdzYymXxd9IxdosPTa3M
	FvOPnGO16H+zkNXiwJ8djBZvejtYLHaue8docbbpDbvF9s4Z7BZfrjxkstj0+BqrxcK2JSwW
	l3fNYbNYe+Quu8WGlweZLJZev8hkseB4C6vFn+lyFqeuf2azmDB9LYvFpvtrGS3+bt/EYvHq
	YBuLxfoZr1ksVu36w+gg6bFm3hpGj9+/JjF6vJ48gdHjcl8vk8fOWXfZPXretLB63Lm2h81j
	85J6j9v/HjN7XDnRxOqx7s8rJo/+vwYefVtWMXp83iTnsXFuaAB/FJdNSmpOZllqkb5dAlfG
	9SNHGQs2slesvnOVpYFxGlsXIyeHhICJxJefO6FsMYkL99YD2VwcQgKLGCU2Xe5kgnBamSSO
	X/3BDlLFJmAo0fW2C6xDRGAho8TneSwgRcwC09gkPi98yQqSEBaIljj5fwsTiM0ioCpx+HIj
	C4jNK+Au8WjDNMYuRg6gdQoScybZgIQ5BTwkVtz+zwYSFgIqWb/QcwIj7wJGhlWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwVH2TGoH48oGi0OMAhyMSjy8CiofgoRYE8uKK3MPMUpwMCuJ
	8JpvAwrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpg9BVY
	1MOw9L5xSQ+/57XTbKey9jJPTF70TfP24nNxtxUDbnBNzXMPerTlpC+X7pN9GYeFNxx9VOXK
	kz1Vc2V0jft5k/zqpkMxGr1rn95PzL7Md4A1+snqmRJr2XbUzj095cPrml/zqssWn8lJbjfy
	jVds+x3ezHzVaO5K558b649a+nhL6lvFKbEUZyQaajEXFScCAIEZBOGuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable reserved memory initialization from device tree.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mm/init.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 804d61566a53..ebafdb479410 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -17,6 +17,7 @@
 #include <linux/nodemask.h>
 #include <linux/initrd.h>
 #include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
@@ -323,6 +324,8 @@ void __init arm_memblock_init(struct meminfo *mi,
 	if (mdesc->reserve)
 		mdesc->reserve();
 
+	early_init_dt_scan_reserved_mem();
+
 	/*
 	 * reserve memory for DMA contigouos allocations,
 	 * must come from DMA area inside low memory
-- 
1.7.9.5

