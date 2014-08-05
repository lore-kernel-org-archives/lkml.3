Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaHESug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:50:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbaHESOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.15 09/42] cfg80211: fix mic_failure tracing
Date: Tue,  5 Aug 2014 11:13:23 -0700
Message-Id: <20140805181321.305736050@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 8c26d458394be44e135d1c6bd4557e1c4e1a0535 upstream.

tsc can be NULL (mac80211 currently always passes NULL),
resulting in NULL-dereference. check before copying it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/trace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2072,7 +2072,8 @@ TRACE_EVENT(cfg80211_michael_mic_failure
 		MAC_ASSIGN(addr, addr);
 		__entry->key_type = key_type;
 		__entry->key_id = key_id;
-		memcpy(__entry->tsc, tsc, 6);
+		if (tsc)
+			memcpy(__entry->tsc, tsc, 6);
 	),
 	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT ", key type: %d, key id: %d, tsc: %pm",
 		  NETDEV_PR_ARG, MAC_PR_ARG(addr), __entry->key_type,


