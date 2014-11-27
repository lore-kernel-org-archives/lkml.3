Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaK0JXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:23:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:41106 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbaK0IqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:10 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 08/91] regulatory: add NUL to alpha2
Date: Thu, 27 Nov 2014 16:41:51 +0800
Message-Id: <1417077794-9299-8-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliad Peller <eliad@wizery.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit a5fe8e7695dc3f547e955ad2b662e3e72969e506 upstream.

alpha2 is defined as 2-chars array, but is used in multiple
places as string (e.g. with nla_put_string calls), which
might leak kernel data.

Solve it by simply adding an extra char for the NULL
terminator, making such operations safe.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/net/regulatory.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index a5f7993..8d64abf 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -97,7 +97,7 @@ struct ieee80211_reg_rule {
 
 struct ieee80211_regdomain {
 	u32 n_reg_rules;
-	char alpha2[2];
+	char alpha2[3];
 	u8 dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
-- 
1.9.1

