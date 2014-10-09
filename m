Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaJIVDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:03:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58907 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 001/163] regulatory: add NUL to alpha2
Date: Thu,  9 Oct 2014 14:00:26 -0700
Message-Id: <1412888588-26755-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit a5fe8e7695dc3f547e955ad2b662e3e72969e506 upstream.

alpha2 is defined as 2-chars array, but is used in multiple
places as string (e.g. with nla_put_string calls), which
might leak kernel data.

Solve it by simply adding an extra char for the NULL
terminator, making such operations safe.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/regulatory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index f17ed59..3e827aa 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -106,7 +106,7 @@ struct ieee80211_reg_rule {
 struct ieee80211_regdomain {
 	struct rcu_head rcu_head;
 	u32 n_reg_rules;
-	char alpha2[2];
+	char alpha2[3];
 	u8 dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
-- 
1.9.1

