Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFFABR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 20:01:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:12011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbaFFABM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 20:01:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,984,1392192000"; 
   d="scan'208";a="543182606"
From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] checkpatch: warn when patch exceeds a maximum message size
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org
Date: Thu, 05 Jun 2014 17:00:37 -0700
Message-ID: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch submissions which exceed a maximum message size imposed by email
list servers can be silently blocked.  Warn when a patch message exceeds
the maximum message size (100,000 characters) allowed by Majordomo at
vger.kernel.org since that is where most Linux email lists are served.
Also provide a command-line option to specify a different maximum size.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..79bd7fd6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -40,6 +40,7 @@ my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
+my $max_msg_size = 100000;	# Max allowed by Majordomo at vger.kernel.org
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
 
@@ -62,6 +63,7 @@ Options:
   --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --max-line-length=n        set the maximum line length, if exceeded, warn
+  --max-msg-size=n           set the maximum message size, if exceeded, warn
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -130,6 +132,7 @@ GetOptions(
 	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
 	'max-line-length=i' => \$max_line_length,
+	'max-msg-size=i' => \$max_msg_size,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -4600,6 +4603,18 @@ sub process {
 		exit(0);
 	}
 
+	# Warn if patch exceeds the maximum message size
+	if (!$file) {
+		my $cnt_chars = 0;
+		foreach my $rawline (@rawlines) {
+			$cnt_chars += length($rawline) + 1;
+		}
+		if ($cnt_chars > $max_msg_size) {
+			WARN("PATCH_TOO_LARGE",
+			     "patch exceeds maximum message size ($max_msg_size) and might be blocked by email list server(s).\n");
+		}
+	}
+
 	if (!$is_patch) {
 		ERROR("NOT_UNIFIED_DIFF",
 		      "Does not appear to be a unified-diff format patch\n");

