Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab3DAR5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:57:25 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:64453 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756563Ab3DAR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:57:24 -0400
Message-ID: <1364839041.21627.63.camel@x61.thuisdomein>
Subject: [PATCH 2/8] headers_check: add check for kernel integer types
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 19:57:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2013 17:57:22.0260 (UTC) FILETIME=[5C239940:01CE2F02]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The u8, u16, u32, and u64, and the s8, s16, s32, and s64 types shouldn't
be exported to userspace. Add a simple check for these.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 scripts/headers_check.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 64ac238..317aa3a 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -39,6 +39,7 @@ foreach my $file (@files) {
 		&check_include();
 		&check_asm_types();
 		&check_sizetypes();
+		&check_kerneltypes();
 		&check_declarations();
 		# Dropped for now. Too much noise &check_config();
 	}
@@ -159,3 +160,12 @@ sub check_sizetypes
 		#$ret = 1;
 	}
 }
+
+sub check_kerneltypes
+{
+	if ($line =~ m/^[[:space:]]*([us](8|16|32|64))\b/) {
+		printf STDERR "$filename:$lineno: " .
+		              "found $1 type exported to userspace; " .
+		              "use __$1 instead\n";
+	}
+}
-- 
1.7.11.7

