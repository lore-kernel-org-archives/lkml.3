Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaEPGvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:51:48 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:55283 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754689AbaEPGvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:51:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 20,1.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3353:3865:3867:3868:3871:3872:4250:4321:5007:6119:7652:7903:9121:10009:10400:10848:11026:11232:11233:11473:11657:11658:11914:12043:12262:12296:12438:12517:12519:12555:12679:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: plot94_f3e8ef232230
X-Filterd-Recvd-Size: 2659
Message-ID: <1400223103.30884.5.camel@joe-AO725>
Subject: [PATCH] bnx2x: Convert return 0 to return rc
From: Joe Perches <joe@perches.com>
To: Ariel Elior <ariele@broadcom.com>, Dmitry Kravkov <dmitry@broadcom.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 May 2014 23:51:43 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These "return 0;" uses seem wrong as there are
rc variables where error return values are set
but unused.

Signed-off-by: Joe Perches <joe@perches.com>
---

Hey Ariel/Dmitry

I've no idea what's right here, but the current
code seems wrong. (or at least under-commented)

It seems Dmitry changed these, perhaps to make
it more readable, but the commit log isn't very
instructive.

commit 1d6f3cd8988822c7bdc3c685fac0a99315e83400
Author: Dmitry Kravkov <dmitry@broadcom.com>
Date:   Wed Mar 27 01:05:17 2013 +0000

    bnx2x: Prevent VF race
    
    The mail box containing the Vf-Pf messages is susceptible
    to a race - it's possible for 2 flows to try and write commands,
    causing one to override the other's message.
    Use a mutex to synchronize the access, preventing said race.

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 81cc2d9..b8078d5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -2695,7 +2695,7 @@ out:
 		bnx2x_unlock_vf_pf_channel(bp, vf, CHANNEL_TLV_PF_SET_MAC);
 	}
 
-	return 0;
+	return rc;
 }
 
 int bnx2x_set_vf_vlan(struct net_device *dev, int vfidx, u16 vlan, u8 qos)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
index 0c067e8..784c715 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c
@@ -747,7 +747,7 @@ int bnx2x_vfpf_config_mac(struct bnx2x *bp, u8 *addr, u8 vf_qid, bool set)
 out:
 	bnx2x_vfpf_finalize(bp, &req->first_tlv);
 
-	return 0;
+	return rc;
 }
 
 /* request pf to config rss table for vf queues*/


