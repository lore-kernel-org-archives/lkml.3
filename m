Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaCXRqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:46:06 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:32801 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753711AbaCXRqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:46:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3871:4321:4605:5007:7652:10004:10400:10848:11026:11657:11658:11914:12043:12219:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act94_177169c053b3f
X-Filterd-Recvd-Size: 2503
Message-ID: <1395683159.13968.60.camel@joe-AO722>
Subject: [PATCH net-next] intel: Remove addressof casts to same type
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux.nics@intel.com
Cc: e1000-devel <e1000-devel@lists.sourceforge.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 24 Mar 2014 10:45:59 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using addressof then casting to the original type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast.cocci 
@@
type T;
T foo;
@@

-	(T *)&foo
+	&foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c   | 4 ++--
 drivers/net/ethernet/intel/i40evf/i40e_common.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index bb948dd..922cdcc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1775,9 +1775,9 @@ static void i40e_parse_discover_capabilities(struct i40e_hw *hw, void *buff,
 	cap = (struct i40e_aqc_list_capabilities_element_resp *) buff;
 
 	if (list_type_opc == i40e_aqc_opc_list_dev_capabilities)
-		p = (struct i40e_hw_capabilities *)&hw->dev_caps;
+		p = &hw->dev_caps;
 	else if (list_type_opc == i40e_aqc_opc_list_func_capabilities)
-		p = (struct i40e_hw_capabilities *)&hw->func_caps;
+		p = &hw->func_caps;
 	else
 		return;
 
diff --git a/drivers/net/ethernet/intel/i40evf/i40e_common.c b/drivers/net/ethernet/intel/i40evf/i40e_common.c
index c688a0f..ae08437 100644
--- a/drivers/net/ethernet/intel/i40evf/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40evf/i40e_common.c
@@ -565,8 +565,7 @@ i40e_status i40e_aq_send_msg_to_pf(struct i40e_hw *hw,
 		details.async = true;
 		cmd_details = &details;
 	}
-	status = i40evf_asq_send_command(hw, (struct i40e_aq_desc *)&desc, msg,
-				       msglen, cmd_details);
+	status = i40evf_asq_send_command(hw, &desc, msg, msglen, cmd_details);
 	return status;
 }
 


