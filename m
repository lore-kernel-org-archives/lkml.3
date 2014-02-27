Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaB0T52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:57:28 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:38073 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaB0T51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:57:27 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH] checkpatch: fix spurious vendor compatible warnings
Date: Thu, 27 Feb 2014 20:56:59 +0100
Message-Id: <1393531019-25134-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a compatible string like

compatible = "foo";

checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
which is wrong since the vendor prefix is empty in this specific case.

Skip the vendor test if the compatible is not like

compatible = "vendor,something";

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..35ec185 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2058,6 +2058,7 @@ sub process {
 				my $vendor = $compat;
 				my $vendor_path = $dt_path . "vendor-prefixes.txt";
 				next if (! -f $vendor_path);
+				next if not $vendor =~ /^[a-zA-Z0-9]+\,.*/;
 				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
 				`grep -Eq "$vendor" $vendor_path`;
 				if ( $? >> 8 ) {
-- 
1.8.5.3

