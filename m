Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3IRJfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:35:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3IRJfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:35:15 -0400
Date: Wed, 18 Sep 2013 02:34:21 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-a8e0108cac181a7b141dacaa99ea52efaf9b5f07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, acme@ghostprotocols.net,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org,
        acme@ghostprotocols.net, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1309171450380.11444@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1309171450380.11444@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix UAPI export of PERF_EVENT_IOC_ID
Git-Commit-ID: a8e0108cac181a7b141dacaa99ea52efaf9b5f07
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 18 Sep 2013 02:34:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8e0108cac181a7b141dacaa99ea52efaf9b5f07
Gitweb:     http://git.kernel.org/tip/a8e0108cac181a7b141dacaa99ea52efaf9b5f07
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Tue, 17 Sep 2013 14:53:41 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Sep 2013 11:29:07 +0200

perf: Fix UAPI export of PERF_EVENT_IOC_ID

Without the following patch I have problems compiling code using
the new PERF_EVENT_IOC_ID ioctl().  It looks like u64 was used
instead of __u64

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1309171450380.11444@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index ca1d90b..40a1fb8 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -324,7 +324,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
-#define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
+#define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
