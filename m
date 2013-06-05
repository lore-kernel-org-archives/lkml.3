Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3FEUuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:50:15 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:9459 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757276Ab3FEUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:50:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MNXTVK-01-BP7-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <dougthompson@xmission.com>, <bp@suse.de>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH] edac: Add code to handle new MCE signatures for new models of Fam15h
Date: Wed, 5 Jun 2013 15:50:03 -0500
Message-ID: <1370465403-2370-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some newer error signatures in Family 15h models 30h-3fh.
Code has been added in the patch to support these new signatures.

Patch has been tested on Fam15h using mce_amd_inj facility and
has been verified to work correctly.

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
 drivers/edac/mce_amd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index f3f0c93..9de24c7 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -134,7 +134,8 @@ static const char * const mc5_mce_desc[] = {
 	"Physical register file AG0 port",
 	"Physical register file AG1 port",
 	"Flag register file",
-	"DE error occurred"
+	"DE error occurred",
+	"Retire Status Queue Parity"
 };
 
 static bool f12h_mc0_mce(u16 ec, u8 xec)
@@ -624,7 +625,7 @@ static void decode_mc5_mce(struct mce *m)
 
 	if (xec == 0x0 || xec == 0xc)
 		pr_cont("%s.\n", mc5_mce_desc[xec]);
-	else if (xec < 0xd)
+	else if (xec <= 0xd)
 		pr_cont("%s parity error.\n", mc5_mce_desc[xec]);
 	else
 		goto wrong_mc5_mce;
-- 
1.7.9.5


