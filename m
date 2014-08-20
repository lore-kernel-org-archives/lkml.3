Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaHTLoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:44:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58863 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/104] cfg80211: fix mic_failure tracing
Date: Wed, 20 Aug 2014 13:42:28 +0200
Message-Id: <a774b9a4f275ebc272f8cc8e6c4f29f601aa695d.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliad Peller <eliad@wizery.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c26d458394be44e135d1c6bd4557e1c4e1a0535 upstream.

tsc can be NULL (mac80211 currently always passes NULL),
resulting in NULL-dereference. check before copying it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/wireless/trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ba5f0d6614d5..064b471b5275 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2029,7 +2029,8 @@ TRACE_EVENT(cfg80211_michael_mic_failure,
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
2.0.4

