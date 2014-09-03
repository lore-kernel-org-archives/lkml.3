Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbaICQcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:32:46 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43822 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaICQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:32:45 -0400
From: Vadim Bendebury <vbendeb@chromium.org>
To: subssriprions@vsbe.com
Cc: vb@vsbe.com, Vadim Bendebury <vbendeb@chromium.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: allow optional shorter config descriptions
Date: Wed,  3 Sep 2014 09:32:25 -0700
Message-Id: <1409761945-545-1-git-send-email-vbendeb@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
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

 scripts/checkpatch.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b385bcb..8808bde 100755
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
@@ -2281,7 +2284,8 @@ sub process {
 				$length++;
 			}
 			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
+			     "please write a paragraph that describes the config symbol fully\n" . $herecurr)
+			    if ($is_start && $is_end && $length < $min_conf_desc_length);
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
-- 
2.1.0.rc2.206.gedb03e5

