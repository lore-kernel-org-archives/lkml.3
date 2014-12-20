Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaLTUlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:41:11 -0500
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:52248 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLTUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:41:08 -0500
From: Christoph Jaeger <cj@linux.com>
To: apw@canonical.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org, dborkman@redhat.com, pebolle@tiscali.nl,
        Christoph Jaeger <cj@linux.com>
Subject: [PATCH] checkpatch: add check for keyword 'boolean' in Kconfig definitions
Date: Sat, 20 Dec 2014 15:40:36 -0500
Message-Id: <1419108036-11536-1-git-send-email-cj@linux.com>
X-Mailer: git-send-email 2.1.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discourage the use of keyword 'boolean' for type definition attributes of
config options as support for it will be dropped later on.

Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
Suggested-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..cae974e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2355,6 +2355,13 @@ sub process {
 			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
 		}
 
+# discourage the use of boolean for type definition attributes of Kconfig options
+		if ($realfile =~ /Kconfig/ &&
+		    $line =~ /^\+\s*\bboolean\b/) {
+			WARN("CONFIG_TYPE_BOOLEAN",
+			     "Use of boolean is deprecated, please use bool instead.\n" . $herecurr);
+		}
+
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
 		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
 			my $flag = $1;
-- 
2.1.0

