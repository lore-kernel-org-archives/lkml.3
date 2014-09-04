Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaIDSYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:24:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38498 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaIDSYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:24:13 -0400
From: Vadim Bendebury <vbendeb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Vadim Bendebury <vbendeb@chromium.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH v2] checkpatch: allow optional shorter config descriptions
Date: Thu,  4 Sep 2014 11:23:49 -0700
Message-Id: <1409855029-22598-1-git-send-email-vbendeb@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
References: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script is used by many other projects, and in some of them the
requirement of at least 4 line long description for all Kconfig items
is excessive. This patch adds a command line option to control the
required minimum length.

Tested running this script over a patch including a two line config
description. The script generated a warning when invoked as is, and
did not generate it when invoked with --min-conf-desc-length=2.

Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
---

Changes in v2:
  - modified the condition check as requested

 scripts/checkpatch.pl | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b385bcb..b0adae9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -43,6 +43,7 @@ my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
+my $min_conf_desc_length = 4;
 
 sub help {
 	my ($exitcode) = @_;
@@ -63,6 +64,7 @@ Options:
   --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --max-line-length=n        set the maximum line length, if exceeded, warn
+  --min-conf-desc-length=n   set the min description length, if shorter, warn
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -131,6 +133,7 @@ GetOptions(
 	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
 	'max-line-length=i' => \$max_line_length,
+	'min-conf-desc-length=i' => \$min_conf_desc_length,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -2280,8 +2283,10 @@ sub process {
 				}
 				$length++;
 			}
-			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
+			if ($is_start && $is_end && $length < $min_conf_desc_length) {
+			    WARN("CONFIG_DESCRIPTION",
+				 "please write a paragraph that describes the config symbol fully\n" . $herecurr)
+			}
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
-- 
2.1.0.rc2.206.gedb03e5

