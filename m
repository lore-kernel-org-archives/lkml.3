Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3FRVtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:49:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58974 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933755Ab3FRVtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:49:04 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Ignore SI unit CamelCase variants like "_uV"
Date: Tue, 18 Jun 2013 14:49:00 -0700
Message-Id: <436886fed3a3e35ee900ff3bd37b2e4abb029fbc.1371591804.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <51ba353b.TlzEy+Prp1kCGnx4%akpm@linux-foundation.org>
References: <51ba353b.TlzEy+Prp1kCGnx4%akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many existing variable names use SI like variants that
should be otherwise obvious and acceptable.

Whitelist them from the CamelCase message.

Suggested-by: Phil Carmody <phil.carmody@partner.samsung.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5989415..7e8aa1b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3195,7 +3195,10 @@ sub process {
 #CamelCase
 			if ($var !~ /^$Constant$/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
+#Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+#Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
+			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				CHK("CAMELCASE",
-- 
1.8.1.2.459.gbcd45b4.dirty

