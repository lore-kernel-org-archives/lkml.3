Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab3FLQVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:21:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58063 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756684Ab3FLQVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:21:13 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: CamelCase - ignore SI unit variants like "_uV"
Date: Wed, 12 Jun 2013 09:21:10 -0700
Message-Id: <abee980458bb6598c4cf0f225d146e7209fa05a9.1371053785.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <1371052935.2069.14.camel@joe-AO722>
References: <1371052935.2069.14.camel@joe-AO722>
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
index 5989415..5ada911 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3195,7 +3195,10 @@ sub process {
 #CamelCase
 			if ($var !~ /^$Constant$/ &&
 			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
+#Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+#Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
+			    $var !~ /"_[a-z][A-Z](?:_\w+)?$/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				CHK("CAMELCASE",
-- 
1.8.1.2.459.gbcd45b4.dirty

