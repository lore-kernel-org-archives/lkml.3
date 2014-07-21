Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaGUUuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 16:50:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16755 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbaGUUuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 16:50:50 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: add trace-record.o to the python shared lib
Date: Mon, 21 Jul 2014 16:50:44 -0400
Message-ID: <1405975844-2361-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-20_03:2014-07-18,2014-07-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.59050567055874e-11 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407210234
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to use the python library it was giving me an error about not being
able to resolve tracecmd_stat_cpu.  This is because we weren't linking
trace-record.o to ctracecmd.so.  Fix this in the makefile and now I can import
trace-cmd in python properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index df5ec72..f6c2875 100644
--- a/Makefile
+++ b/Makefile
@@ -321,7 +321,7 @@ KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
 TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
 			trace-output.o trace-recorder.o trace-restore.o trace-usage.o \
-			trace-blk-hack.o kbuffer-parse.o event-plugin.o
+			trace-blk-hack.o kbuffer-parse.o event-plugin.o trace-record.o
 
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
-- 
1.8.3.1

