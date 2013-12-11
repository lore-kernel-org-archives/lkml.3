Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab3LKFMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:12:54 -0500
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:35092 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740Ab3LKFMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:12:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:968:973:988:989:1260:1345:1437:1534:1542:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:3872:3874:4419:4605:5007:6261:8660:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12679:13148:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: prose21_7022cd44f4846
X-Filterd-Recvd-Size: 2946
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH -next 0/3] seq_printf/puts/putc: Start to convert to return void
Date: Tue, 10 Dec 2013 21:12:41 -0800
Message-Id: <cover.1386738050.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many uses of the return value of seq_printf/seq_puts/seq_putc are
incorrect.  Many assume that the return value is the number of
chars emitted into a buffer like printf/puts/putc.

It would be better to make the return value of these functions void
to avoid these misuses.

Start to do so.
Convert seq_overflow to a public function from a static function.

Remove the return uses of seq_printf/seq_puts/seq_putc from net.
Add a seq_overflow function call instead.

Joe Perches (3):
  seq: Add a seq_overflow test.
  batman-adv: Use seq_overflow
  netfilter: Use seq_overflow

 fs/seq_file.c                                      | 15 ++++----
 include/linux/seq_file.h                           |  2 +
 include/net/netfilter/nf_conntrack_acct.h          |  3 +-
 net/batman-adv/gateway_client.c                    | 25 ++++++------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |  6 ++-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   | 42 +++++++++++++--------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |  6 ++-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     | 10 +++--
 net/netfilter/nf_conntrack_acct.c                  | 11 +++---
 net/netfilter/nf_conntrack_expect.c                |  4 +-
 net/netfilter/nf_conntrack_proto_dccp.c            | 12 ++++--
 net/netfilter/nf_conntrack_proto_gre.c             | 15 +++++---
 net/netfilter/nf_conntrack_proto_sctp.c            | 12 ++++--
 net/netfilter/nf_conntrack_proto_tcp.c             | 11 ++++--
 net/netfilter/nf_conntrack_proto_udp.c             |  7 ++--
 net/netfilter/nf_conntrack_proto_udplite.c         |  7 ++--
 net/netfilter/nf_conntrack_standalone.c            | 44 +++++++++++++---------
 net/netfilter/nf_log.c                             | 26 ++++++-------
 net/netfilter/nfnetlink_log.c                      | 12 +++---
 net/netfilter/nfnetlink_queue_core.c               | 14 ++++---
 net/netfilter/x_tables.c                           |  8 ++--
 net/netfilter/xt_hashlimit.c                       | 34 +++++++++--------
 22 files changed, 191 insertions(+), 135 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

