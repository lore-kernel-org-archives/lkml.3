Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHOPbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:31:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37418 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHOPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:31:54 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Javi Merino <javi.merino@arm.com>
Subject: [PATCH] trace-cmd: link trace-record in ctracecmd.so
Date: Fri, 15 Aug 2014 16:31:38 +0100
Message-Id: <1408116698-23033-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 15 Aug 2014 15:31:50.0596 (UTC) FILETIME=[089E2840:01CFB89E]
X-MC-Unique: 114081516315215401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s7FFW0UU002014

Commit b1e9220819eb (trace-cmd: Report stats for all instances) moved
tracecmd_stat_cpu() from trace-recorder.c to trace-record.c.  This
makes import ctracecmd fail in tracecmd.py:

$ python tracecmd.py
Traceback (most recent call last):
  File "tracecmd.py", line 22, in <module>
    from ctracecmd import *
ImportError: ctracecmd.so: undefined symbol: tracecmd_stat_cpu

Link trace-record in ctracecmd.so to add back the required symbol.

Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index cbe0eb9..308d7f8 100644
--- a/Makefile
+++ b/Makefile
@@ -317,8 +317,9 @@ KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 
 PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
 TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
-			trace-output.o trace-recorder.o trace-restore.o trace-usage.o \
-			trace-blk-hack.o kbuffer-parse.o event-plugin.o
+			trace-output.o trace-record.o trace-recorder.o \
+			trace-restore.o trace-usage.o trace-blk-hack.o \
+			kbuffer-parse.o event-plugin.o
 
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
-- 
1.9.1


