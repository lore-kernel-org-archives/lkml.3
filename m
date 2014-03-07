Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaCGN1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:27:38 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:38688 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaCGN00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:26:26 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] checkpatch: check vendor compatible with dashes
Date: Fri,  7 Mar 2014 14:26:08 +0100
Message-Id: <1394198771-25913-2-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current vendor compatible check will not match vendors with
dashes, like:

compatible="asahi-kasei"

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..e304e77 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2058,7 +2058,7 @@ sub process {
 				my $vendor = $compat;
 				my $vendor_path = $dt_path . "vendor-prefixes.txt";
 				next if (! -f $vendor_path);
-				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
+				$vendor =~ s/^([a-zA-Z0-9\-]+)\,.*/$1/;
 				`grep -Eq "$vendor" $vendor_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
-- 
1.8.5.3

