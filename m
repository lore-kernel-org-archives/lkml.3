Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3IUR0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:26:48 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:60958 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752619Ab3IURXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1605:1606:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4117:4385:5007:6261:7903:10004:10026:10848:11026:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12683:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sock55_1c2dd4418bf4d
X-Filterd-Recvd-Size: 6387
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] netrom.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:51 -0700
Message-Id: <3c7374b4762a384241e77c39509c2a9b6b0b4648.1379783996.git.joe@perches.com>
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
 include/net/netrom.h | 89 ++++++++++++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 45 deletions(-)

diff --git a/include/net/netrom.h b/include/net/netrom.h
index 121dcf8..110350a 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -183,51 +183,50 @@ extern int  sysctl_netrom_routing_control;
 extern int  sysctl_netrom_link_fails_count;
 extern int  sysctl_netrom_reset_circuit;
 
-extern int  nr_rx_frame(struct sk_buff *, struct net_device *);
-extern void nr_destroy_socket(struct sock *);
+int nr_rx_frame(struct sk_buff *, struct net_device *);
+void nr_destroy_socket(struct sock *);
 
 /* nr_dev.c */
-extern int  nr_rx_ip(struct sk_buff *, struct net_device *);
-extern void nr_setup(struct net_device *);
+int nr_rx_ip(struct sk_buff *, struct net_device *);
+void nr_setup(struct net_device *);
 
 /* nr_in.c */
-extern int  nr_process_rx_frame(struct sock *, struct sk_buff *);
+int nr_process_rx_frame(struct sock *, struct sk_buff *);
 
 /* nr_loopback.c */
-extern void nr_loopback_init(void);
-extern void nr_loopback_clear(void);
-extern int  nr_loopback_queue(struct sk_buff *);
+void nr_loopback_init(void);
+void nr_loopback_clear(void);
+int nr_loopback_queue(struct sk_buff *);
 
 /* nr_out.c */
-extern void nr_output(struct sock *, struct sk_buff *);
-extern void nr_send_nak_frame(struct sock *);
-extern void nr_kick(struct sock *);
-extern void nr_transmit_buffer(struct sock *, struct sk_buff *);
-extern void nr_establish_data_link(struct sock *);
-extern void nr_enquiry_response(struct sock *);
-extern void nr_check_iframes_acked(struct sock *, unsigned short);
+void nr_output(struct sock *, struct sk_buff *);
+void nr_send_nak_frame(struct sock *);
+void nr_kick(struct sock *);
+void nr_transmit_buffer(struct sock *, struct sk_buff *);
+void nr_establish_data_link(struct sock *);
+void nr_enquiry_response(struct sock *);
+void nr_check_iframes_acked(struct sock *, unsigned short);
 
 /* nr_route.c */
-extern void nr_rt_device_down(struct net_device *);
-extern struct net_device *nr_dev_first(void);
-extern struct net_device *nr_dev_get(ax25_address *);
-extern int  nr_rt_ioctl(unsigned int, void __user *);
-extern void nr_link_failed(ax25_cb *, int);
-extern int  nr_route_frame(struct sk_buff *, ax25_cb *);
+void nr_rt_device_down(struct net_device *);
+struct net_device *nr_dev_first(void);
+struct net_device *nr_dev_get(ax25_address *);
+int nr_rt_ioctl(unsigned int, void __user *);
+void nr_link_failed(ax25_cb *, int);
+int nr_route_frame(struct sk_buff *, ax25_cb *);
 extern const struct file_operations nr_nodes_fops;
 extern const struct file_operations nr_neigh_fops;
-extern void nr_rt_free(void);
+void nr_rt_free(void);
 
 /* nr_subr.c */
-extern void nr_clear_queues(struct sock *);
-extern void nr_frames_acked(struct sock *, unsigned short);
-extern void nr_requeue_frames(struct sock *);
-extern int  nr_validate_nr(struct sock *, unsigned short);
-extern int  nr_in_rx_window(struct sock *, unsigned short);
-extern void nr_write_internal(struct sock *, int);
+void nr_clear_queues(struct sock *);
+void nr_frames_acked(struct sock *, unsigned short);
+void nr_requeue_frames(struct sock *);
+int nr_validate_nr(struct sock *, unsigned short);
+int nr_in_rx_window(struct sock *, unsigned short);
+void nr_write_internal(struct sock *, int);
 
-extern void __nr_transmit_reply(struct sk_buff *skb, int mine,
-	unsigned char cmdflags);
+void __nr_transmit_reply(struct sk_buff *skb, int mine, unsigned char cmdflags);
 
 /*
  * This routine is called when a Connect Acknowledge with the Choke Flag
@@ -247,24 +246,24 @@ do {									\
 	__nr_transmit_reply((skb), (mine), NR_RESET);			\
 } while (0)
 
-extern void nr_disconnect(struct sock *, int);
+void nr_disconnect(struct sock *, int);
 
 /* nr_timer.c */
-extern void nr_init_timers(struct sock *sk);
-extern void nr_start_heartbeat(struct sock *);
-extern void nr_start_t1timer(struct sock *);
-extern void nr_start_t2timer(struct sock *);
-extern void nr_start_t4timer(struct sock *);
-extern void nr_start_idletimer(struct sock *);
-extern void nr_stop_heartbeat(struct sock *);
-extern void nr_stop_t1timer(struct sock *);
-extern void nr_stop_t2timer(struct sock *);
-extern void nr_stop_t4timer(struct sock *);
-extern void nr_stop_idletimer(struct sock *);
-extern int  nr_t1timer_running(struct sock *);
+void nr_init_timers(struct sock *sk);
+void nr_start_heartbeat(struct sock *);
+void nr_start_t1timer(struct sock *);
+void nr_start_t2timer(struct sock *);
+void nr_start_t4timer(struct sock *);
+void nr_start_idletimer(struct sock *);
+void nr_stop_heartbeat(struct sock *);
+void nr_stop_t1timer(struct sock *);
+void nr_stop_t2timer(struct sock *);
+void nr_stop_t4timer(struct sock *);
+void nr_stop_idletimer(struct sock *);
+int nr_t1timer_running(struct sock *);
 
 /* sysctl_net_netrom.c */
-extern void nr_register_sysctl(void);
-extern void nr_unregister_sysctl(void);
+void nr_register_sysctl(void);
+void nr_unregister_sysctl(void);
 
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

