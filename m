Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971Ab3B0BkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:40:09 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:36966
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759951Ab3B0BkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:40:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Kim Phillips <kim.phillips@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ARM: zImage: sparse fixes
Date: Tue, 26 Feb 2013 19:36:15 -0600
Message-ID: <1361928975-29395-3-git-send-email-kim.phillips@freescale.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1361928975-29395-1-git-send-email-kim.phillips@freescale.com>
References: <1361928975-29395-1-git-send-email-kim.phillips@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/boot/compressed/atags_to_fdt.c:107:34: warning: cast to restricted __be32
arch/arm/boot/compressed/atags_to_fdt.c:107:34: warning: cast to restricted __be32
arch/arm/boot/compressed/atags_to_fdt.c:107:34: warning: cast to restricted __be32
arch/arm/boot/compressed/atags_to_fdt.c:107:34: warning: cast to restricted __be32
arch/arm/boot/compressed/atags_to_fdt.c:107:34: warning: cast to restricted __be32
arch/arm/boot/compressed/atags_to_fdt.c:107:34: warning: cast to restricted __be32
arch/arm/boot/compressed/atags_to_fdt.c:140:54: warning: incorrect type in assignment (different base types)
arch/arm/boot/compressed/atags_to_fdt.c:140:54:    expected unsigned int [unsigned] <noident>
arch/arm/boot/compressed/atags_to_fdt.c:140:54:    got restricted __be32 [usertype] <noident>
arch/arm/boot/compressed/atags_to_fdt.c:141:54: warning: incorrect type in assignment (different base types)
arch/arm/boot/compressed/atags_to_fdt.c:141:54:    expected unsigned int [unsigned] <noident>
arch/arm/boot/compressed/atags_to_fdt.c:141:54:    got restricted __be32 [usertype] <noident>

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 arch/arm/boot/compressed/atags_to_fdt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
index aabc02a..b7c4846 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -16,7 +16,7 @@ static int node_offset(void *fdt, const char *node_path)
 }
 
 static int setprop(void *fdt, const char *node_path, const char *property,
-		   uint32_t *val_array, int size)
+		   fdt32_t *val_array, int size)
 {
 	int offset = node_offset(fdt, node_path);
 	if (offset < 0)
@@ -95,7 +95,7 @@ static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
 int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 {
 	struct tag *atag = atag_list;
-	uint32_t mem_reg_property[2 * NR_BANKS];
+	fdt32_t mem_reg_property[2 * NR_BANKS];
 	int memcount = 0;
 	int ret;
 
@@ -104,7 +104,7 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 		return 1;
 
 	/* if we get a DTB here we're done already */
-	if (*(u32 *)atag_list == fdt32_to_cpu(FDT_MAGIC))
+	if (*(fdt32_t *)atag_list == cpu_to_fdt32(FDT_MAGIC))
 	       return 0;
 
 	/* validate the ATAG */
-- 
1.8.1.4


