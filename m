Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3JXJcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:32:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab3JXJco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:32:44 -0400
From: Weiping Pan <panweiping3@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net] tcp: delete unused req in tcp_synack_rtt_meas()
Date: Thu, 24 Oct 2013 17:31:36 +0800
Message-Id: <4fcb645d8f8f5d6dda0ebd1ce2bd0cc3bfb14311.1382607044.git.panweiping3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter req is not used since
375fe02c9179(tcp: consolidate SYNACK RTT sampling).

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 net/ipv4/tcp_input.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a16b01b..ac8781a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2871,7 +2871,7 @@ static inline bool tcp_ack_update_rtt(struct sock *sk, const int flag,
 }
 
 /* Compute time elapsed between (last) SYNACK and the ACK completing 3WHS. */
-static void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req)
+static void tcp_synack_rtt_meas(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	s32 seq_rtt = -1;
@@ -5694,7 +5694,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 		tp->snd_una = TCP_SKB_CB(skb)->ack_seq;
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
-		tcp_synack_rtt_meas(sk, req);
+		tcp_synack_rtt_meas(sk);
 
 		if (tp->rx_opt.tstamp_ok)
 			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
-- 
1.7.4

