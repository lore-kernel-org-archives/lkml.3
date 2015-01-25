Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbbAYSy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:54:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbbAYSJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.18 058/183] cfg80211: dont WARN about two consecutive Country IE hint
Date: Sun, 25 Jan 2015 10:06:20 -0800
Message-Id: <20150125180812.700845194@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 70dcec5a488a7b81779190ac8089475fe4b8b962 upstream.

This can happen and there is no point in added more
detection code lower in the stack. Catching these in one
single point (cfg80211) is enough. Stop WARNING about this
case.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=89001

Fixes: 2f1c6c572d7b ("cfg80211: process non country IE conflicting first")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1839,11 +1839,8 @@ __reg_process_hint_country_ie(struct wip
 			return REG_REQ_IGNORE;
 		return REG_REQ_ALREADY_SET;
 	}
-	/*
-	 * Two consecutive Country IE hints on the same wiphy.
-	 * This should be picked up early by the driver/stack
-	 */
-	if (WARN_ON(regdom_changes(country_ie_request->alpha2)))
+
+	if (regdom_changes(country_ie_request->alpha2))
 		return REG_REQ_OK;
 	return REG_REQ_ALREADY_SET;
 }


