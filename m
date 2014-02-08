Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaBHH6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:58:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:47385 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaBHH57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:57:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="480009572"
From: Andi Kleen <ak@linux.intel.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Patrick McHardy <kaber@trash.net>,
        lvs-devel@vger.kernel.org
Subject: [PATCH] sections, ipvs: Remove useless __read_mostly for ipvs genl_ops
Date: Sat,  8 Feb 2014 08:57:01 +0100
Message-Id: <1391846221-30240-1-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

const __read_mostly does not make any sense, because const
data is already read-only. Remove the __read_mostly
for the ipvs genl_ops. This avoids a LTO
section conflict compile problem.

Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Patrick McHardy <kaber@trash.net>
Cc: lvs-devel@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 35be035..2a68a38 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3580,7 +3580,7 @@ out:
 }
 
 
-static const struct genl_ops ip_vs_genl_ops[] __read_mostly = {
+static const struct genl_ops ip_vs_genl_ops[] = {
 	{
 		.cmd	= IPVS_CMD_NEW_SERVICE,
 		.flags	= GENL_ADMIN_PERM,
-- 
1.8.5.2

