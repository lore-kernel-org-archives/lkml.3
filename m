Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLPURV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:17:21 -0500
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:44254 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751765AbaLPURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:17:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3865:3867:3868:3870:3872:4049:4118:4250:4321:4605:5007:6119:6261:7903:10004:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crook99_50b020be2626
X-Filterd-Recvd-Size: 7114
Message-ID: <1418761033.14140.5.camel@perches.com>
Subject: [PATCH netfilter-next] xt_osf: Use continue to reduce indentation
From: Joe Perches <joe@perches.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 16 Dec 2014 12:17:13 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invert logic in test to use continue.

This routine already uses continue, use it a bit more to
minimize > 80 column long lines and unnecessary indentation.

No change in compiled object file.

Other miscellanea:

o Remove trailing whitespace
o Realign arguments to multiline statement

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/xt_osf.c | 169 +++++++++++++++++++++++++------------------------
 1 file changed, 85 insertions(+), 84 deletions(-)

diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index c529161..0778855 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -225,6 +225,8 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(kf, &xt_osf_fingers[df], finger_entry) {
+		int foptsize, optnum;
+
 		f = &kf->finger;
 
 		if (!(info->flags & XT_OSF_LOG) && strcmp(info->genre, f->genre))
@@ -233,110 +235,109 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 		optp = _optp;
 		fmatch = FMATCH_WRONG;
 
-		if (totlen == f->ss && xt_osf_ttl(skb, info, f->ttl)) {
-			int foptsize, optnum;
+		if (totlen != f->ss || !xt_osf_ttl(skb, info, f->ttl))
+			continue;
 
-			/*
-			 * Should not happen if userspace parser was written correctly.
-			 */
-			if (f->wss.wc >= OSF_WSS_MAX)
-				continue;
+		/*
+		 * Should not happen if userspace parser was written correctly.
+		 */
+		if (f->wss.wc >= OSF_WSS_MAX)
+			continue;
 
-			/* Check options */
+		/* Check options */
 
-			foptsize = 0;
-			for (optnum = 0; optnum < f->opt_num; ++optnum)
-				foptsize += f->opt[optnum].length;
+		foptsize = 0;
+		for (optnum = 0; optnum < f->opt_num; ++optnum)
+			foptsize += f->opt[optnum].length;
 
-			if (foptsize > MAX_IPOPTLEN ||
-				optsize > MAX_IPOPTLEN ||
-				optsize != foptsize)
-				continue;
+		if (foptsize > MAX_IPOPTLEN ||
+		    optsize > MAX_IPOPTLEN ||
+		    optsize != foptsize)
+			continue;
 
-			check_WSS = f->wss.wc;
+		check_WSS = f->wss.wc;
 
-			for (optnum = 0; optnum < f->opt_num; ++optnum) {
-				if (f->opt[optnum].kind == (*optp)) {
-					__u32 len = f->opt[optnum].length;
-					const __u8 *optend = optp + len;
-					int loop_cont = 0;
+		for (optnum = 0; optnum < f->opt_num; ++optnum) {
+			if (f->opt[optnum].kind == (*optp)) {
+				__u32 len = f->opt[optnum].length;
+				const __u8 *optend = optp + len;
+				int loop_cont = 0;
 
-					fmatch = FMATCH_OK;
+				fmatch = FMATCH_OK;
 
-					switch (*optp) {
-					case OSFOPT_MSS:
-						mss = optp[3];
-						mss <<= 8;
-						mss |= optp[2];
+				switch (*optp) {
+				case OSFOPT_MSS:
+					mss = optp[3];
+					mss <<= 8;
+					mss |= optp[2];
 
-						mss = ntohs((__force __be16)mss);
-						break;
-					case OSFOPT_TS:
-						loop_cont = 1;
-						break;
-					}
+					mss = ntohs((__force __be16)mss);
+					break;
+				case OSFOPT_TS:
+					loop_cont = 1;
+					break;
+				}
 
-					optp = optend;
-				} else
-					fmatch = FMATCH_OPT_WRONG;
+				optp = optend;
+			} else
+				fmatch = FMATCH_OPT_WRONG;
 
-				if (fmatch != FMATCH_OK)
-					break;
-			}
+			if (fmatch != FMATCH_OK)
+				break;
+		}
 
-			if (fmatch != FMATCH_OPT_WRONG) {
-				fmatch = FMATCH_WRONG;
+		if (fmatch != FMATCH_OPT_WRONG) {
+			fmatch = FMATCH_WRONG;
 
-				switch (check_WSS) {
-				case OSF_WSS_PLAIN:
-					if (f->wss.val == 0 || window == f->wss.val)
-						fmatch = FMATCH_OK;
-					break;
-				case OSF_WSS_MSS:
-					/*
-					 * Some smart modems decrease mangle MSS to 
-					 * SMART_MSS_2, so we check standard, decreased
-					 * and the one provided in the fingerprint MSS
-					 * values.
-					 */
+			switch (check_WSS) {
+			case OSF_WSS_PLAIN:
+				if (f->wss.val == 0 || window == f->wss.val)
+					fmatch = FMATCH_OK;
+				break;
+			case OSF_WSS_MSS:
+				/*
+				 * Some smart modems decrease mangle MSS to
+				 * SMART_MSS_2, so we check standard, decreased
+				 * and the one provided in the fingerprint MSS
+				 * values.
+				 */
 #define SMART_MSS_1	1460
 #define SMART_MSS_2	1448
-					if (window == f->wss.val * mss ||
-					    window == f->wss.val * SMART_MSS_1 ||
-					    window == f->wss.val * SMART_MSS_2)
-						fmatch = FMATCH_OK;
-					break;
-				case OSF_WSS_MTU:
-					if (window == f->wss.val * (mss + 40) ||
-					    window == f->wss.val * (SMART_MSS_1 + 40) ||
-					    window == f->wss.val * (SMART_MSS_2 + 40))
-						fmatch = FMATCH_OK;
-					break;
-				case OSF_WSS_MODULO:
-					if ((window % f->wss.val) == 0)
-						fmatch = FMATCH_OK;
-					break;
-				}
+				if (window == f->wss.val * mss ||
+				    window == f->wss.val * SMART_MSS_1 ||
+				    window == f->wss.val * SMART_MSS_2)
+					fmatch = FMATCH_OK;
+				break;
+			case OSF_WSS_MTU:
+				if (window == f->wss.val * (mss + 40) ||
+				    window == f->wss.val * (SMART_MSS_1 + 40) ||
+				    window == f->wss.val * (SMART_MSS_2 + 40))
+					fmatch = FMATCH_OK;
+				break;
+			case OSF_WSS_MODULO:
+				if ((window % f->wss.val) == 0)
+					fmatch = FMATCH_OK;
+				break;
 			}
+		}
 
-			if (fmatch != FMATCH_OK)
-				continue;
+		if (fmatch != FMATCH_OK)
+			continue;
 
-			fcount++;
+		fcount++;
 
-			if (info->flags & XT_OSF_LOG)
-				nf_log_packet(net, p->family, p->hooknum, skb,
-					p->in, p->out, NULL,
-					"%s [%s:%s] : %pI4:%d -> %pI4:%d hops=%d\n",
-					f->genre, f->version, f->subtype,
-					&ip->saddr, ntohs(tcp->source),
-					&ip->daddr, ntohs(tcp->dest),
-					f->ttl - ip->ttl);
+		if (info->flags & XT_OSF_LOG)
+			nf_log_packet(net, p->family, p->hooknum, skb,
+				      p->in, p->out, NULL,
+				      "%s [%s:%s] : %pI4:%d -> %pI4:%d hops=%d\n",
+				      f->genre, f->version, f->subtype,
+				      &ip->saddr, ntohs(tcp->source),
+				      &ip->daddr, ntohs(tcp->dest),
+				      f->ttl - ip->ttl);
 
-			if ((info->flags & XT_OSF_LOG) &&
-			    info->loglevel == XT_OSF_LOGLEVEL_FIRST)
-				break;
-		}
+		if ((info->flags & XT_OSF_LOG) &&
+		    info->loglevel == XT_OSF_LOGLEVEL_FIRST)
+			break;
 	}
 	rcu_read_unlock();
 


