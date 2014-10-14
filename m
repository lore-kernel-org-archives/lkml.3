Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaJNN2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:28:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:10326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbaJNN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:28:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="605114325"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: davem@davemloft.net
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        johannes.berg@intel.com, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net] genl_magic: Resolve logical-op warnings
Date: Tue, 14 Oct 2014 06:28:38 -0700
Message-Id: <1413293318-9070-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve "logical 'and' applied to non-boolean constant" warnings"
that appear in W=2 builds by adding !! to a bit test.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/genl_magic_func.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/genl_magic_func.h b/include/linux/genl_magic_func.h
index c0894dd..667c311 100644
--- a/include/linux/genl_magic_func.h
+++ b/include/linux/genl_magic_func.h
@@ -178,12 +178,12 @@ static int s_name ## _from_attrs_for_change(struct s_name *s,		\
 #define __assign(attr_nr, attr_flag, name, nla_type, type, assignment...)	\
 		nla = ntb[attr_nr];						\
 		if (nla) {						\
-			if (exclude_invariants && ((attr_flag) & DRBD_F_INVARIANT)) {		\
+			if (exclude_invariants && !!((attr_flag) & DRBD_F_INVARIANT)) {		\
 				pr_info("<< must not change invariant attr: %s\n", #name);	\
 				return -EEXIST;				\
 			}						\
 			assignment;					\
-		} else if (exclude_invariants && ((attr_flag) & DRBD_F_INVARIANT)) {		\
+		} else if (exclude_invariants && !!((attr_flag) & DRBD_F_INVARIANT)) {		\
 			/* attribute missing from payload, */		\
 			/* which was expected */			\
 		} else if ((attr_flag) & DRBD_F_REQUIRED) {		\
-- 
1.9.3

