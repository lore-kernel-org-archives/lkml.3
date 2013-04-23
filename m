Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab3DWV7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:59:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab3DWV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, davej@redhat.com
Subject: [ 16/23] perf: Treat attr.config as u64 in perf_swevent_init()
Date: Tue, 23 Apr 2013 14:56:23 -0700
Message-Id: <20130423215457.955452849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommi Rantala <tt.rantala@gmail.com>

commit 8176cced706b5e5d15887584150764894e94e02f upstream.

Trinity discovered that we fail to check all 64 bits of
attr.config passed by user space, resulting to out-of-bounds
access of the perf_swevent_enabled array in
sw_perf_event_destroy().

Introduced in commit b0a873ebb ("perf: Register PMU
implementations").

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1365882554-30259-1-git-send-email-tt.rantala@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5440,7 +5440,7 @@ static void sw_perf_event_destroy(struct
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;


