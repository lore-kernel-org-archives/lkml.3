Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3DMONH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:13:07 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:52649 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3DMONF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:13:05 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: whitelist SUPPORTED_*/ADVERTISED_* defines from ethtool.h
Date: Sat, 13 Apr 2013 16:10:57 +0200
Message-Id: <1365862257-31151-1-git-send-email-jogo@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't complain about camelcase when using SUPPORTED_*/ADVERTISED_*
defines, they are part of the user api so can't be (easily) fixed.

Removes false positives in e.g. ethernet drivers like:

WARNING: Avoid CamelCase: <SUPPORTED_Autoneg>
+                                     SUPPORTED_Autoneg |

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..349559a4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2931,6 +2931,7 @@ sub process {
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
 			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+			    $var !~ /^(?:SUPPORTED|ADVERTISED)_\w*/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",
-- 
1.7.10.4

