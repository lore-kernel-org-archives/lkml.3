Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaLJRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:55:57 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:53528 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932268AbaLJRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:55:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3866:3870:3872:3873:4117:4321:4423:4605:5007:6119:6261:7903:8603:10004:10241:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: feast35_163b978ee854b
X-Filterd-Recvd-Size: 6084
Message-ID: <1418234150.18092.9.camel@perches.com>
Subject: [PATCH 3] llc: Make llc_sap_action_t function pointer arrays const
From: Joe Perches <joe@perches.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Dec 2014 09:55:50 -0800
In-Reply-To: <1418233437.18092.7.camel@perches.com>
References: <1418228330.18092.3.camel@perches.com>
	 <1418233437.18092.7.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better when function pointer arrays aren't modifiable.

Net change:

$ size net/llc/built-in.o.*
   text	   data	    bss	    dec	    hex	filename
  61193	  12758	   1344	  75295	  1261f	net/llc/built-in.o.new
  47113	  27030	   1344	  75487	  126df	net/llc/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---

No more of these in llc.  Let me know if you need a
clean resubmission of all 3 of this llc series.

 include/net/llc_s_st.h |  2 +-
 net/llc/llc_s_st.c     | 20 ++++++++++----------
 net/llc/llc_sap.c      |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/llc_s_st.h b/include/net/llc_s_st.h
index 567c681..c4359e2 100644
--- a/include/net/llc_s_st.h
+++ b/include/net/llc_s_st.h
@@ -19,7 +19,7 @@
 struct llc_sap_state_trans {
 	llc_sap_ev_t	  ev;
 	u8		  next_state;
-	llc_sap_action_t *ev_actions;
+	const llc_sap_action_t *ev_actions;
 };
 
 struct llc_sap_state {
diff --git a/net/llc/llc_s_st.c b/net/llc/llc_s_st.c
index 135f7d8..308c616 100644
--- a/net/llc/llc_s_st.c
+++ b/net/llc/llc_s_st.c
@@ -29,7 +29,7 @@ static struct llc_sap_state_trans llc_sap_state_trans_end;
 /* state LLC_SAP_STATE_INACTIVE transition for
  * LLC_SAP_EV_ACTIVATION_REQ event
  */
-static llc_sap_action_t llc_sap_inactive_state_actions_1[] = {
+static const llc_sap_action_t llc_sap_inactive_state_actions_1[] = {
 	[0] = llc_sap_action_report_status,
 	[1] = NULL,
 };
@@ -47,7 +47,7 @@ static struct llc_sap_state_trans *llc_sap_inactive_state_transitions[] = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_RX_UI event */
-static llc_sap_action_t llc_sap_active_state_actions_1[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_1[] = {
 	[0] = llc_sap_action_unitdata_ind,
 	[1] = NULL,
 };
@@ -59,7 +59,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_1 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_UNITDATA_REQ event */
-static llc_sap_action_t llc_sap_active_state_actions_2[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_2[] = {
 	[0] = llc_sap_action_send_ui,
 	[1] = NULL,
 };
@@ -71,7 +71,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_2 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_XID_REQ event */
-static llc_sap_action_t llc_sap_active_state_actions_3[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_3[] = {
 	[0] = llc_sap_action_send_xid_c,
 	[1] = NULL,
 };
@@ -83,7 +83,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_3 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_RX_XID_C event */
-static llc_sap_action_t llc_sap_active_state_actions_4[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_4[] = {
 	[0] = llc_sap_action_send_xid_r,
 	[1] = NULL,
 };
@@ -95,7 +95,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_4 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_RX_XID_R event */
-static llc_sap_action_t llc_sap_active_state_actions_5[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_5[] = {
 	[0] = llc_sap_action_xid_ind,
 	[1] = NULL,
 };
@@ -107,7 +107,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_5 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_TEST_REQ event */
-static llc_sap_action_t llc_sap_active_state_actions_6[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_6[] = {
 	[0] = llc_sap_action_send_test_c,
 	[1] = NULL,
 };
@@ -119,7 +119,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_6 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_RX_TEST_C event */
-static llc_sap_action_t llc_sap_active_state_actions_7[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_7[] = {
 	[0] = llc_sap_action_send_test_r,
 	[1] = NULL,
 };
@@ -131,7 +131,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_7 = {
 };
 
 /* state LLC_SAP_STATE_ACTIVE transition for LLC_SAP_EV_RX_TEST_R event */
-static llc_sap_action_t llc_sap_active_state_actions_8[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_8[] = {
 	[0] = llc_sap_action_test_ind,
 	[1] = NULL,
 };
@@ -145,7 +145,7 @@ static struct llc_sap_state_trans llc_sap_active_state_trans_8 = {
 /* state LLC_SAP_STATE_ACTIVE transition for
  * LLC_SAP_EV_DEACTIVATION_REQ event
  */
-static llc_sap_action_t llc_sap_active_state_actions_9[] = {
+static const llc_sap_action_t llc_sap_active_state_actions_9[] = {
 	[0] = llc_sap_action_report_status,
 	[1] = NULL,
 };
diff --git a/net/llc/llc_sap.c b/net/llc/llc_sap.c
index 06033f6..d0e1e80 100644
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -146,7 +146,7 @@ static int llc_exec_sap_trans_actions(struct llc_sap *sap,
 				      struct sk_buff *skb)
 {
 	int rc = 0;
-	llc_sap_action_t *next_action = trans->ev_actions;
+	const llc_sap_action_t *next_action = trans->ev_actions;
 
 	for (; next_action && *next_action; next_action++)
 		if ((*next_action)(sap, skb))


