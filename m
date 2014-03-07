Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaCGN0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:26:46 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:38719 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaCGN03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:26:29 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] checkpatch: improve the compatible vendor match
Date: Fri,  7 Mar 2014 14:26:11 +0100
Message-Id: <1394198771-25913-5-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

From: Joe Perches <joe@perches.com>

Improve the vendor name match in vendor-prefix.txt
by only matching the exact vendor name at the beginning of lines.

Signed-off-by: Joe Perches <joe@perches.com>
[florian.vaussard@epfl.ch: split patch, commit log]
Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 scripts/checkpatch.pl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9205153..5bda9f7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2047,9 +2047,11 @@ sub process {
 
 			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
 
+			my $dt_path = $root . "/Documentation/devicetree/bindings/";
+			my $vp_file = $dt_path . "vendor-prefixes.txt";
+
 			foreach my $compat (@compats) {
 				my $compat2 = $compat;
-				my $dt_path =  $root . "/Documentation/devicetree/bindings/";
 				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
 				`grep -Erq "$compat|$compat2" $dt_path`;
 				if ( $? >> 8 ) {
@@ -2057,14 +2059,12 @@ sub process {
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
 				}
 
-				my $vendor_path = $dt_path . "vendor-prefixes.txt";
-				next if (! -f $vendor_path);
 				next if $compat !~ /^([a-zA-Z0-9\-]+)\,/;
 				my $vendor = $1;
-				`grep -Eq "$vendor" $vendor_path`;
+				`grep -Eq "^$vendor\\b" $vp_file`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
-					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
+					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vp_file\n" . $herecurr);
 				}
 			}
 		}
-- 
1.8.5.3

