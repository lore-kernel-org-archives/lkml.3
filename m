Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab3GCSzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:55:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209Ab3GCSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:55 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=MbuNTGXcLYoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Q5uW4agzLYkA:10 a=TWv9rMRwAAAA:8 a=VwQbUJbxAAAA:8 a=0e1NNH2jAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=ahTuzK7fxSMA:10 a=-Pj1cSz79GQA:10 a=hAwTiGD2l9QA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184048.391933095@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Martin Michlmayr <tbm@cyrius.com>, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [023/141] Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0023-Kirkwood-Enable-PCIe-port-1-on-QNAP-TS-11x-TS-21x.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Martin Michlmayr <tbm@cyrius.com>

[ Upstream commit 99e11334dcb846f9b76fb808196c7f47aa83abb3 ]

Enable KW_PCIE1 on QNAP TS-11x/TS-21x devices as newer revisions
(rev 1.3) have a USB 3.0 chip from Etron on PCIe port 1.  Thanks
to Marek Vasut for identifying this issue!

Cc: <stable@vger.kernel.org> # v2.6.36.x
Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Tested-by: Marek Vasut <marex@denx.de>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-kirkwood/ts219-setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-kirkwood/ts219-setup.c b/arch/arm/mach-kirkwood/ts219-setup.c
index 73e2b6c..3a73fc7 100644
--- a/arch/arm/mach-kirkwood/ts219-setup.c
+++ b/arch/arm/mach-kirkwood/ts219-setup.c
@@ -124,7 +124,7 @@ static void __init qnap_ts219_init(void)
 static int __init ts219_pci_init(void)
 {
 	if (machine_is_ts219())
-		kirkwood_pcie_init(KW_PCIE0);
+		kirkwood_pcie_init(KW_PCIE1 | KW_PCIE0);
 
 	return 0;
 }
-- 
1.7.10.4


