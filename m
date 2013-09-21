Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3IURX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:27 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:56688 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752531Ab3IURXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11026:11658:11914:12043:12291:12294:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: girls79_1a5ef46b6b82f
X-Filterd-Recvd-Size: 4889
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] lapb.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:44 -0700
Message-Id: <bc3782826012cc851c7d1b275e675dfb72f45ffe.1379783995.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
References: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/lapb.h | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/net/lapb.h b/include/net/lapb.h
index df892a9..9510f87 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -105,40 +105,40 @@ struct lapb_cb {
 };
 
 /* lapb_iface.c */
-extern void lapb_connect_confirmation(struct lapb_cb *lapb, int);
-extern void lapb_connect_indication(struct lapb_cb *lapb, int);
-extern void lapb_disconnect_confirmation(struct lapb_cb *lapb, int);
-extern void lapb_disconnect_indication(struct lapb_cb *lapb, int);
-extern int  lapb_data_indication(struct lapb_cb *lapb, struct sk_buff *);
-extern int  lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *);
+void lapb_connect_confirmation(struct lapb_cb *lapb, int);
+void lapb_connect_indication(struct lapb_cb *lapb, int);
+void lapb_disconnect_confirmation(struct lapb_cb *lapb, int);
+void lapb_disconnect_indication(struct lapb_cb *lapb, int);
+int lapb_data_indication(struct lapb_cb *lapb, struct sk_buff *);
+int lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *);
 
 /* lapb_in.c */
-extern void lapb_data_input(struct lapb_cb *lapb, struct sk_buff *);
+void lapb_data_input(struct lapb_cb *lapb, struct sk_buff *);
 
 /* lapb_out.c */
-extern void lapb_kick(struct lapb_cb *lapb);
-extern void lapb_transmit_buffer(struct lapb_cb *lapb, struct sk_buff *, int);
-extern void lapb_establish_data_link(struct lapb_cb *lapb);
-extern void lapb_enquiry_response(struct lapb_cb *lapb);
-extern void lapb_timeout_response(struct lapb_cb *lapb);
-extern void lapb_check_iframes_acked(struct lapb_cb *lapb, unsigned short);
-extern void lapb_check_need_response(struct lapb_cb *lapb, int, int);
+void lapb_kick(struct lapb_cb *lapb);
+void lapb_transmit_buffer(struct lapb_cb *lapb, struct sk_buff *, int);
+void lapb_establish_data_link(struct lapb_cb *lapb);
+void lapb_enquiry_response(struct lapb_cb *lapb);
+void lapb_timeout_response(struct lapb_cb *lapb);
+void lapb_check_iframes_acked(struct lapb_cb *lapb, unsigned short);
+void lapb_check_need_response(struct lapb_cb *lapb, int, int);
 
 /* lapb_subr.c */
-extern void lapb_clear_queues(struct lapb_cb *lapb);
-extern void lapb_frames_acked(struct lapb_cb *lapb, unsigned short);
-extern void lapb_requeue_frames(struct lapb_cb *lapb);
-extern int  lapb_validate_nr(struct lapb_cb *lapb, unsigned short);
-extern int lapb_decode(struct lapb_cb *lapb, struct sk_buff *, struct lapb_frame *);
-extern void lapb_send_control(struct lapb_cb *lapb, int, int, int);
-extern void lapb_transmit_frmr(struct lapb_cb *lapb);
+void lapb_clear_queues(struct lapb_cb *lapb);
+void lapb_frames_acked(struct lapb_cb *lapb, unsigned short);
+void lapb_requeue_frames(struct lapb_cb *lapb);
+int lapb_validate_nr(struct lapb_cb *lapb, unsigned short);
+int lapb_decode(struct lapb_cb *lapb, struct sk_buff *, struct lapb_frame *);
+void lapb_send_control(struct lapb_cb *lapb, int, int, int);
+void lapb_transmit_frmr(struct lapb_cb *lapb);
 
 /* lapb_timer.c */
-extern void lapb_start_t1timer(struct lapb_cb *lapb);
-extern void lapb_start_t2timer(struct lapb_cb *lapb);
-extern void lapb_stop_t1timer(struct lapb_cb *lapb);
-extern void lapb_stop_t2timer(struct lapb_cb *lapb);
-extern int  lapb_t1timer_running(struct lapb_cb *lapb);
+void lapb_start_t1timer(struct lapb_cb *lapb);
+void lapb_start_t2timer(struct lapb_cb *lapb);
+void lapb_stop_t1timer(struct lapb_cb *lapb);
+void lapb_stop_t2timer(struct lapb_cb *lapb);
+int lapb_t1timer_running(struct lapb_cb *lapb);
 
 /*
  * Debug levels.
-- 
1.8.1.2.459.gbcd45b4.dirty

