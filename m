Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3A3TPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:15:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:25069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab3A3TPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:15:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,569,1355126400"; 
   d="scan'208";a="250409487"
Subject: [PATCH] checkpatch: fix USLEEP_RANGE test
To: linux-kernel@vger.kernel.org
From: Bruce Allan <bruce.w.allan@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Date: Wed, 30 Jan 2013 11:15:30 -0800
Message-ID: <20130130191530.27127.49640.stgit@bwallan-smackover2.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not test udelay() for a value less than 10usec when passed a variable
instead of a hard-coded number; there is no way for checkpatch to know the
value of the variable.  As it is today, it will complain about variables
with alphanumeric characters plus '_', e.g. foo_bar, but not variables with
other characters, eg. foo->bar.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d2c7df..adfb2f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3237,9 +3237,9 @@ sub process {
 		}
 
 # prefer usleep_range over udelay
-		if ($line =~ /\budelay\s*\(\s*(\w+)\s*\)/) {
+		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however
-			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
+			if (! ($1 < 10) ) {
 				CHK("USLEEP_RANGE",
 				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
 			}

