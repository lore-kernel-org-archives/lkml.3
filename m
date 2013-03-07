Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3CGA3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:29:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56239 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3CGA3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:12 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 3/3] get_maintainer: prevent keywords from matching filenames
Date: Wed,  6 Mar 2013 17:29:01 -0700
Message-Id: <1362616141-13947-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
References: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This reverts most of eb90d08 "get_maintainer: allow keywords to match
filenames"; all except the parts that are required to implement the new
N: entry type.

The rationale is that it's better to have K: match just patch or file
content as it previously did, and N: match just filenames, rather than
have K: math all three cases. This gives more explicit control, and
removes the temptation to use K: for filenames, and then have those
keywords accidentally match unexpected patch or file content.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: New patch.
---
 MAINTAINERS               |    9 ++++-----
 scripts/get_maintainer.pl |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d02ab5..e68a07a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -100,13 +100,12 @@ Descriptions of section entries:
 	   X:	net/ipv6/
 	   matches all files in and below net excluding net/ipv6/
 	K: Keyword perl extended regex pattern to match content in a
-	   patch or file, or an affected filename.  For instance:
+	   patch or file.  For instance:
 	   K: of_get_profile
-	      matches patch or file content, or filenames, that contain
-	      "of_get_profile"
+	      matches patches or files that contain "of_get_profile"
 	   K: \b(printk|pr_(info|err))\b
-	      matches patch or file content, or filenames, that contain one or
-	      more of the words printk, pr_info or pr_err
+	      matches patches or files that contain one or more of the words
+	      printk, pr_info or pr_err
 	   One regex pattern per line.  Multiple K: lines acceptable.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 27dc5cb..5e4fb14 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -611,7 +611,7 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
-			} elsif ($type eq 'K' || $type eq 'N') {
+			} elsif ($type eq 'N') {
 			    if ($file =~ m/$value/x) {
 				$hash{$tvi} = 0;
 			    }
-- 
1.7.10.4

