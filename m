Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaCXURN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:17:13 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:45350 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754235AbaCXUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:16:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:3871:4321:5007:6261:8603:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun87_174a7bc9bab1a
X-Filterd-Recvd-Size: 1785
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>, Dept-HSGLinuxNICDev@qlogic.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] qlcnic: Remove casts of pointer to same type
Date: Mon, 24 Mar 2014 13:15:37 -0700
Message-Id: <ac82455e9d2f0487a3f96c44a41b5557fd09af95.1395692043.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting a pointer to a pointer of the same type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast_2.cocci
@@
type T;
T *foo;
@@

-	(T *)foo
+	foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index ec399b7..2d91975 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -1388,7 +1388,7 @@ static int qlcnic_83xx_copy_fw_file(struct qlcnic_adapter *adapter)
 	addr = (u64)dest;
 
 	ret = qlcnic_83xx_ms_mem_write128(adapter, addr,
-					  (u32 *)p_cache, size / 16);
+					  p_cache, size / 16);
 	if (ret) {
 		dev_err(&adapter->pdev->dev, "MS memory write failed\n");
 		release_firmware(fw);
-- 
1.8.1.2.459.gbcd45b4.dirty

