Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaCGN1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:27:03 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:38711 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaCGN02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:26:28 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] checkpatch: check compatible strings in .c and .h too
Date: Fri,  7 Mar 2014 14:26:10 +0100
Message-Id: <1394198771-25913-4-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

From: Joe Perches <joe@perches.com>

Look for ".compatible = "foo" strings not only in .dts files, but
in .c and .h too.

Signed-off-by: Joe Perches <joe@perches.com>
[florian.vaussard@epfl.ch: split patch, commit log]
Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 scripts/checkpatch.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 96f10ba..9205153 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2041,8 +2041,10 @@ sub process {
 		}
 
 # check for DT compatible documentation
-		if (defined $root && $realfile =~ /\.dts/ &&
-		    $rawline =~ /^\+\s*compatible\s*=/) {
+		if (defined $root &&
+			(($realfile =~ /\.dtsi?$/ && $line =~ /^\+\s*compatible\s*=\s*\"/) ||
+			 ($realfile =~ /\.[ch]$/ && $line =~ /^\+.*\.compatible\s*=\s*\"/))) {
+
 			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
 
 			foreach my $compat (@compats) {
-- 
1.8.5.3

