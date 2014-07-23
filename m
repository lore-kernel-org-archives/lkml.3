Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaGWML2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:11:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30634 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaGWML1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:11:27 -0400
Date: Wed, 23 Jul 2014 15:11:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] checkpatch: warn on missing spaces in broken up quoted
Message-ID: <20140723121106.GA18400@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402943256.3182.2.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch already complains when people break up quoted strings but
it's still pretty common.  One mistake that people often make is they
leave out the space character between the two strings.

This check adds around 450 new warnings and has a low rate of false
positives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Move to correct spot in checkpatch
    Fix indenting
    Use "\w" instead of "[a-zA-Z]"

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a0880ed..132e6e2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2361,6 +2361,12 @@ sub process {
 			     "quoted string split across lines\n" . $hereprev);
 		}
 
+# check for missing a space in a string concatination
+		if ($prevrawline =~ /[^\\]\w"$/ && $rawline =~ /^\+[\t ]+"\w/) {
+			WARN('MISSING_SPACE',
+			     "break quoted strings at a space character\n" . $hereprev);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
