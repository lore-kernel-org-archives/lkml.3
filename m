Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3LLDoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 22:44:25 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:44985 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751423Ab3LLDoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 22:44:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:69:355:379:541:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:1801:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:4605:5007:6119:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12679:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mice41_7cf07a2237f5f
X-Filterd-Recvd-Size: 2114
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH -next 0/2] seq_file/netfilter: Start removing returns from seq_<foo>
Date: Wed, 11 Dec 2013 19:44:10 -0800
Message-Id: <cover.1386819513.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value from seq_printf/puts/putc/etc are frequently misused.
Start removing the uses of the return values.

Joe Perches (2):
  seq_file: Rename static bool seq_overflow to public bool seq_is_buf_full
  netfilter: Convert print_tuple functions to return void

 Documentation/filesystems/seq_file.txt       | 28 ++++++++++++++++------------
 fs/seq_file.c                                | 28 ++++++++++++++--------------
 include/linux/seq_file.h                     |  8 ++++++++
 include/net/netfilter/nf_conntrack_core.h    |  2 +-
 include/net/netfilter/nf_conntrack_l3proto.h |  4 ++--
 include/net/netfilter/nf_conntrack_l4proto.h |  4 ++--
 net/netfilter/nf_conntrack_l3proto_generic.c |  5 ++---
 net/netfilter/nf_conntrack_proto_dccp.c      | 10 +++++-----
 net/netfilter/nf_conntrack_proto_generic.c   |  5 ++---
 net/netfilter/nf_conntrack_proto_gre.c       | 10 +++++-----
 net/netfilter/nf_conntrack_proto_sctp.c      | 10 +++++-----
 net/netfilter/nf_conntrack_proto_tcp.c       | 10 +++++-----
 net/netfilter/nf_conntrack_proto_udp.c       | 10 +++++-----
 net/netfilter/nf_conntrack_proto_udplite.c   | 10 +++++-----
 net/netfilter/nf_conntrack_standalone.c      | 15 +++++++--------
 15 files changed, 84 insertions(+), 75 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

