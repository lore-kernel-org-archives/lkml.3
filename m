Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3CKOYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:24:20 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63945 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3CKOYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:24:19 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:24:18 +0800
Message-ID: <CAPgLHd_CZXucALyD4JrDsA9ffYFrcufTyw-Nh0o2sAjg10YsvA@mail.gmail.com>
Subject: [PATCH -next] powerpc: use for_each_compatible_node() macro
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_compatible_node() macro instead of open coding it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/powerpc/include/asm/parport.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/parport.h b/arch/powerpc/include/asm/parport.h
index 6dc2577..a452968 100644
--- a/arch/powerpc/include/asm/parport.h
+++ b/arch/powerpc/include/asm/parport.h
@@ -21,9 +21,7 @@ static int parport_pc_find_nonpci_ports (int autoirq, int autodma)
 	int count = 0;
 	int virq;
 
-	for (np = NULL; (np = of_find_compatible_node(np,
-						      "parallel",
-						      "pnpPNP,400")) != NULL;) {
+	for_each_compatible_node(np, "parallel", "pnpPNP,400") {
 		prop = of_get_property(np, "reg", &propsize);
 		if (!prop || propsize > 6*sizeof(u32))
 			continue;

