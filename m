Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab3B0Bjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:39:37 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20796
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab3B0Bjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:39:35 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Kim Phillips <kim.phillips@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] libfdt: add fdt type definitions in libfdt_env.h
Date: Tue, 26 Feb 2013 19:36:13 -0600
Message-ID: <1361928975-29395-1-git-send-email-kim.phillips@freescale.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in preparation for the forthcoming dtc update which adds fdt specific
types: fdt{16,32,64}_t.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 arch/arm/boot/compressed/libfdt_env.h | 4 ++++
 include/linux/libfdt_env.h            | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/compressed/libfdt_env.h b/arch/arm/boot/compressed/libfdt_env.h
index 1f4e718..17ae0f3 100644
--- a/arch/arm/boot/compressed/libfdt_env.h
+++ b/arch/arm/boot/compressed/libfdt_env.h
@@ -5,6 +5,10 @@
 #include <linux/string.h>
 #include <asm/byteorder.h>
 
+typedef __be16 fdt16_t;
+typedef __be32 fdt32_t;
+typedef __be64 fdt64_t;
+
 #define fdt16_to_cpu(x)		be16_to_cpu(x)
 #define cpu_to_fdt16(x)		cpu_to_be16(x)
 #define fdt32_to_cpu(x)		be32_to_cpu(x)
diff --git a/include/linux/libfdt_env.h b/include/linux/libfdt_env.h
index 01508c7..da98097 100644
--- a/include/linux/libfdt_env.h
+++ b/include/linux/libfdt_env.h
@@ -5,6 +5,12 @@
 
 #include <asm/byteorder.h>
 
+typedef __be16 fdt16_t;
+typedef __be32 fdt32_t;
+typedef __be64 fdt64_t;
+
+#define fdt16_to_cpu(x) be16_to_cpu(x)
+#define cpu_to_fdt16(x) cpu_to_be16(x)
 #define fdt32_to_cpu(x) be32_to_cpu(x)
 #define cpu_to_fdt32(x) cpu_to_be32(x)
 #define fdt64_to_cpu(x) be64_to_cpu(x)
-- 
1.8.1.4


