Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaCHAbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 19:31:37 -0500
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:44736 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751820AbaCHAbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 19:31:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3867:3870:3871:5007:7652:7903:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key26_650cb690aa43e
X-Filterd-Recvd-Size: 1485
Message-ID: <1394238692.16156.115.camel@joe-AO722>
Subject: [PATCH] eeh_pseries: Missing break?
From: Joe Perches <joe@perches.com>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2014 16:31:32 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this is unintentional as the
result = EEH_STATE_UNAVAILABLE is being
overwritten by EEH_STATE_NOT_SUPPORT in the
fallthrough to the default case.
---
diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 8a8f047..83da53f 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -460,14 +460,15 @@ static int pseries_eeh_get_state(struct eeh_pe *pe, int *state)
 		case 5:
 			if (rets[2]) {
 				if (state) *state = rets[2];
 				result = EEH_STATE_UNAVAILABLE;
 			} else {
 				result = EEH_STATE_NOT_SUPPORT;
 			}
+			break;
 		default:
 			result = EEH_STATE_NOT_SUPPORT;
 		}
 	} else {
 		result = EEH_STATE_NOT_SUPPORT;
 	}
 


