Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3JaQAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:00:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20896 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3JaQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:00:10 -0400
From: Jamie Iles <jamie.iles@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@oracle.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] recordmcount.pl: add support for __fentry__
Date: Thu, 31 Oct 2013 15:59:58 +0000
Message-Id: <1383235198-24961-1-git-send-email-jamie.iles@oracle.com>
X-Mailer: git-send-email 1.8.4.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.6.0 the -mfentry feature places the function profiling call
at the start of the function. When this is used, the call is to
__fentry__ and not mcount.

Based on 48bb5dc6cd9d30fe0d594947563da1f8bd9abada (ftrace: Make
recordmcount.c handle __fentry__).

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
---
 scripts/recordmcount.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a674fd5..6460fc68 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -214,7 +214,7 @@ $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
 $section_type = '@progbits';
 $mcount_adjust = 0;
 $type = ".long";
-- 
1.8.4.2

