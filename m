Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaHRJfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaHRJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/137] cfg80211: fix mic_failure tracing
Date: Mon, 18 Aug 2014 10:32:23 +0100
Message-Id: <1408354398-10226-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 8c26d458394be44e135d1c6bd4557e1c4e1a0535 upstream.

tsc can be NULL (mac80211 currently always passes NULL),
resulting in NULL-dereference. check before copying it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index e1534baf2ebb..c4d5da718171 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1994,7 +1994,8 @@ TRACE_EVENT(cfg80211_michael_mic_failure,
 		MAC_ASSIGN(addr, addr);
 		__entry->key_type = key_type;
 		__entry->key_id = key_id;
-		memcpy(__entry->tsc, tsc, 6);
+		if (tsc)
+			memcpy(__entry->tsc, tsc, 6);
 	),
 	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT ", key type: %d, key id: %d, tsc: %pm",
 		  NETDEV_PR_ARG, MAC_PR_ARG(addr), __entry->key_type,
-- 
1.9.1

