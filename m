Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935615Ab3DHSte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:49:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50640 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935238Ab3DHStd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:49:33 -0400
Message-ID: <1365446973.2029.7.camel@joe-AO722>
Subject: [PATCH] checkpatch: Fix stringification macro defect
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Vincent =?ISO-8859-1?Q?Stehl=E9?= <v-stehle@ti.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Apr 2013 11:49:33 -0700
In-Reply-To: <51630753.6030609@ti.com>
References: <51630753.6030609@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch misreporting defect with stringification macros

ERROR: Macros with complex values should be enclosed in parenthesis
  #27: FILE: arch/arm/include/asm/kgdb.h:41:
  +#define ___to_string(X) #X

Reported-by: Vincent Stehlé <v-stehle@ti.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3fb6d86..2e802fc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3024,6 +3024,7 @@ sub process {
 			    $dstat !~ /^'X'$/ &&					# character constants
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
+			    $dstat !~ /^(?:\#\s*$Ident|\#\s*$Constant)\s*$/ &&		# stringification #foo
 			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()


