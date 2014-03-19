Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaCSSzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:55:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40210 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaCSSzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:55:08 -0400
From: Christopher Covington <cov@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] checkpatch.pl: Add check for Change-Id
Date: Wed, 19 Mar 2014 14:54:53 -0400
Message-Id: <1395255293-3419-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A commit hook for the Gerrit code review server inserts change
identifiers so Gerrit can track patches through multiple revisions.
These identifiers are noise in the context of the upstream kernel.
(Many Gerrit servers are private. Even given a public instance,
given only a Change-Id, one must guess which server a change was
tracked on. Patches submitted to the Linux kernel mailing lists
should be able to stand on their own. If it's truly useful to
reference code review on a Gerrit server, a URL is a much clearer
way to do so.) Thus, issue an error when a Change-Id: line is
encountered.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..afd6dde 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1891,6 +1891,12 @@ sub process {
 			}
 		}
 
+# Check for unwanted Gerrit info
+		if ($line =~ /^\s*change-id:/i) {
+			ERROR("BAD_SIGN_OFF",
+			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("CORRUPTED_PATCH",
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

