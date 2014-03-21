Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbaCURaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:30:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40017 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaCURaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:30:09 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Cc: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v2] checkpatch.pl: Add check for Change-Id
Date: Fri, 21 Mar 2014 13:29:28 -0400
Message-Id: <1395422969-29056-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <532C75B0.9040405@codeaurora.org>
References: <532C75B0.9040405@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A commit hook for the Gerrit code review server [1] inserts change
identifiers so Gerrit can track patches through multiple revisions.
These identifiers are noise in the context of the upstream kernel.
(Many Gerrit servers are private. Even given a public instance,
given only a Change-Id, one must guess which server a change was
tracked on. Patches submitted to the Linux kernel mailing lists
should be able to stand on their own. If it's truly useful to
reference code review on a Gerrit server, a URL is a much clearer
way to do so.) Thus, issue an error when a Change-Id line is
encountered before the Signed-off-by.

1. https://gerrit.googlesource.com/gerrit/+/master/gerrit-server/src/main/resources/com/google/gerrit/server/tools/root/hooks/commit-msg

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..8fad0d3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1891,6 +1891,12 @@ sub process {
 			}
 		}
 
+# Check for unwanted Gerrit info
+		if ($in_commit_log && $line =~ /^\s*change-id:/i) {
+			ERROR("GERRIT_CHANGE_ID",
+			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("CORRUPTED_PATCH",
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

