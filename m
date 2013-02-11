Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826Ab3BKXk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:40:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55885 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760749Ab3BKXkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:40:25 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: arm@kernel.org
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 1/2] get_maintainer: allow keywords to match filenames
Date: Mon, 11 Feb 2013 16:40:15 -0700
Message-Id: <1360626016-23332-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Allow K: entries in MAINTAINERS to match directly against filenames;
either those extracted from patch +++ or --- lines, or those specified
on the command-line using the -f option.

This potentially allows fewer lines in a MAINTAINERS entry, if all the
relevant files are scattered throughout the whole kernel tree, yet
contain some common keyword. An example would be using an ARM SoC name
as the keyword to catch all related drivers.

I don't think setting exact_pattern_match_hash would be appropriate here;
at least for intended Tegra use case, this feature is to ensure that all
Tegra-related driver changes get Cc'd to the Tegra mailing list. Setting
exact_pattern_match_hash would prevent git history parsing for e.g. S-o-b
tags, which still seems like it would be useful. Hence, this flag isn't
set.

The value in $hash{$tvi} doesn't seem relevant, so I just assign 0.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
V3: New patch.

Joe, I'm not sure if you care where this gets merged; could it go through
arm-soc together with patch 2/2? A quick look at git history of the
script in linux-next indicates there won't be conflicts doing that.

 scripts/get_maintainer.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 18d4ab5..96cf92a 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -611,6 +611,10 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
+			} elsif ($type eq "K") {
+			    if ($file =~ m/$value/x) {
+				$hash{$tvi} = 0;
+			    }
 			}
 		    }
 		}
-- 
1.7.10.4

