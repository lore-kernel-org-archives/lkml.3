Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3EFW44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:56:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab3EFW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:56:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 23/63] tracing: Fix off-by-one on allocating stat->pages
Date: Mon,  6 May 2013 15:56:01 -0700
Message-Id: <20130506225320.766695504@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit 39e30cd1537937d3c00ef87e865324e981434e5b upstream.

The first page was allocated separately, so no need to start from 0.

Link: http://lkml.kernel.org/r/1364820385-32027-2-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -624,7 +624,7 @@ int ftrace_profile_pages_init(struct ftr
 
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
-	for (i = 0; i < pages; i++) {
+	for (i = 1; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;


