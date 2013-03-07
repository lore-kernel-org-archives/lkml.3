Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CGA3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:29:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:32986 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3CGA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:09 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 1/3] get_maintainer: create filename-only regex match type
Date: Wed,  6 Mar 2013 17:28:59 -0700
Message-Id: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Create a new N: entry type in MAINTAINERS which performs a regex match
against filenames; either those extracted from patch +++ or --- lines,
or those specified on the command-line using the -f option.

This provides the same benefits as using a K: regex option to match a
set of filenames (see commit eb90d08 "get_maintainer: allow keywords to
match filenames"), but without the disadvantage that "random" file
content, such as comments,  will ever match the regex.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Corrected typo in MAINTAINERS documentation
---
 MAINTAINERS               |    3 +++
 scripts/get_maintainer.pl |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..c9b1e37 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -90,6 +90,9 @@ Descriptions of section entries:
 	   F:	drivers/net/*	all files in drivers/net, but not below
 	   F:	*/net/*		all files in "any top level directory"/net
 	   One pattern per line.  Multiple F: lines acceptable.
+	N: Files and directories with regex patterns.
+	   N:	[^a-z]tegra	all files whose patch contains the word tegra
+	   One pattern per line.  Multiple N: lines acceptable.
 	X: Files and directories that are NOT maintained, same rules as F:
 	   Files exclusions are tested before file matches.
 	   Can be useful for excluding a specific subdirectory, for instance:
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index ce4cc83..27dc5cb 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -611,7 +611,7 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
-			} elsif ($type eq 'K') {
+			} elsif ($type eq 'K' || $type eq 'N') {
 			    if ($file =~ m/$value/x) {
 				$hash{$tvi} = 0;
 			    }
-- 
1.7.10.4

