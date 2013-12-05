Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3LEUp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:45:56 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:60522 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3LEUpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:45:55 -0500
Message-ID: <201312052045.rB5KjrBv019932@farm-0012.internal.tilera.com>
From: Tony Lu <zlu@tilera.com>
Date: Thu, 5 Dec 2013 15:36:54 -0500
Subject: [PATCH] ftrace: default to tilegx if ARCH=tile is specified
To: Chris Metcalf <cmetcalf@tilera.com>, <fengguang.wu@intel.com>,
        Jamie Iles <jamie.iles@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This matches the existing behavior in arch/tile/Makefile for defconfig.

Reported-by: fengguang.wu@intel.com
Signed-off-by: Tony Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
Chris Metcalf will push this change via the tile tree.

 scripts/recordmcount.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d0da66396f62..91280b82da08 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -364,7 +364,8 @@ if ($arch eq "x86_64") {
 } elsif ($arch eq "blackfin") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
     $mcount_adjust = -4;
-} elsif ($arch eq "tilegx") {
+} elsif ($arch eq "tilegx" || $arch eq "tile") {
+    # Default to the newer TILE-Gx architecture if only "tile" is given.
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
     $type = ".quad";
     $alignment = 8;
-- 
1.8.3.1

