Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3HFEvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 00:51:43 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:60220 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3HFEvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 00:51:42 -0400
From: kpark3469@gmail.com
To: rostedt@goodmis.org
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] PM / QoS: use __print_symbolic with more convenient way
Date: Tue,  6 Aug 2013 13:51:20 +0900
Message-Id: <1375764681-4618-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

This patch is to prevent the same __print_symbolic functions from
being used repeatedly.

Signed-off-by: Sahara <keun-o.park@windriver.com>
---
 include/trace/events/power.h |   43 +++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 8e42410..34efacc 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -182,6 +182,23 @@ DEFINE_EVENT(power_domain, power_domain_target,
 /*
  * The pm qos events are used for pm qos update
  */
+#define show_pm_qos_class(val)						\
+	__print_symbolic(val,						\
+		{ PM_QOS_CPU_DMA_LATENCY,	"CPU_DMA_LATENCY" },	\
+		{ PM_QOS_NETWORK_LATENCY,	"NETWORK_LATENCY" },	\
+		{ PM_QOS_NETWORK_THROUGHPUT,	"NETWORK_THROUGHPUT" })
+
+#define show_pm_qos_req_action(val)					\
+	__print_symbolic(val,						\
+		{ PM_QOS_ADD_REQ,	"ADD_REQ" },			\
+		{ PM_QOS_UPDATE_REQ,	"UPDATE_REQ" },			\
+		{ PM_QOS_REMOVE_REQ,	"REMOVE_REQ" })
+
+#define show_dev_pm_qos_req_type(val)					\
+	__print_symbolic(val,						\
+		{ DEV_PM_QOS_LATENCY,	"DEV_PM_QOS_LATENCY" },		\
+		{ DEV_PM_QOS_FLAGS,	"DEV_PM_QOS_FLAGS" })
+
 DECLARE_EVENT_CLASS(pm_qos_request,
 
 	TP_PROTO(int pm_qos_class, s32 value),
@@ -199,11 +216,7 @@ DECLARE_EVENT_CLASS(pm_qos_request,
 	),
 
 	TP_printk("pm_qos_class=%s value=%d",
-		  __print_symbolic(__entry->pm_qos_class,
-			{ PM_QOS_CPU_DMA_LATENCY,	"CPU_DMA_LATENCY" },
-			{ PM_QOS_NETWORK_LATENCY,	"NETWORK_LATENCY" },
-			{ PM_QOS_NETWORK_THROUGHPUT,	"NETWORK_THROUGHPUT" }),
-		  __entry->value)
+		  show_pm_qos_class(__entry->pm_qos_class), __entry->value)
 );
 
 DEFINE_EVENT(pm_qos_request, pm_qos_add_request,
@@ -246,10 +259,7 @@ TRACE_EVENT(pm_qos_update_request_timeout,
 	),
 
 	TP_printk("pm_qos_class=%s value=%d, timeout_us=%ld",
-		  __print_symbolic(__entry->pm_qos_class,
-			{ PM_QOS_CPU_DMA_LATENCY,	"CPU_DMA_LATENCY" },
-			{ PM_QOS_NETWORK_LATENCY,	"NETWORK_LATENCY" },
-			{ PM_QOS_NETWORK_THROUGHPUT,	"NETWORK_THROUGHPUT" }),
+		  show_pm_qos_class(__entry->pm_qos_class),
 		  __entry->value, __entry->timeout_us)
 );
 
@@ -272,10 +282,7 @@ DECLARE_EVENT_CLASS(pm_qos_update,
 	),
 
 	TP_printk("action=%s prev_value=%d curr_value=%d",
-		  __print_symbolic(__entry->action,
-			{ PM_QOS_ADD_REQ,	"ADD_REQ" },
-			{ PM_QOS_UPDATE_REQ,	"UPDATE_REQ" },
-			{ PM_QOS_REMOVE_REQ,	"REMOVE_REQ" }),
+		  show_pm_qos_req_action(__entry->action),
 		  __entry->prev_value, __entry->curr_value)
 );
 
@@ -293,10 +300,7 @@ DEFINE_EVENT_PRINT(pm_qos_update, pm_qos_update_flags,
 	TP_ARGS(action, prev_value, curr_value),
 
 	TP_printk("action=%s prev_value=0x%x curr_value=0x%x",
-		  __print_symbolic(__entry->action,
-			{ PM_QOS_ADD_REQ,	"ADD_REQ" },
-			{ PM_QOS_UPDATE_REQ,	"UPDATE_REQ" },
-			{ PM_QOS_REMOVE_REQ,	"REMOVE_REQ" }),
+		  show_pm_qos_req_action(__entry->action),
 		  __entry->prev_value, __entry->curr_value)
 );
 
@@ -321,10 +325,7 @@ DECLARE_EVENT_CLASS(dev_pm_qos_request,
 
 	TP_printk("device=%s type=%s new_value=%d",
 		  __get_str(name),
-		  __print_symbolic(__entry->type,
-			{ DEV_PM_QOS_LATENCY,	"DEV_PM_QOS_LATENCY" },
-			{ DEV_PM_QOS_FLAGS,	"DEV_PM_QOS_FLAGS" }),
-		  __entry->new_value)
+		  show_dev_pm_qos_req_type(__entry->type), __entry->new_value)
 );
 
 DEFINE_EVENT(dev_pm_qos_request, dev_pm_qos_add_request,
-- 
1.7.1

