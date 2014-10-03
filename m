Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbaJCWOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:14:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbaJCWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 172/238] regulatory: add NUL to alpha2
Date: Fri,  3 Oct 2014 14:31:27 -0700
Message-Id: <20141003212919.174644564@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/regulatory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -160,7 +160,7 @@ struct ieee80211_reg_rule {
 struct ieee80211_regdomain {
 	struct rcu_head rcu_head;
 	u32 n_reg_rules;
-	char alpha2[2];
+	char alpha2[3];
 	enum nl80211_dfs_regions dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };


