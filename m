Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbbALS65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:58:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbbALS36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 135/216] cfg80211: don't WARN about two consecutive Country IE hint
Date: Mon, 12 Jan 2015 18:28:33 +0000
Message-Id: <1421087394-2712-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/reg.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ff7ffeb7947a..20ccc79d53a2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1802,11 +1802,8 @@ __reg_process_hint_country_ie(struct wiphy *wiphy,
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
-- 
2.1.4

