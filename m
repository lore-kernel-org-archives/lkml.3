Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab3DOCUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:20:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab3DOCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:17:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 04/11] tracing: Fix double free when function profile init failed
Date: Sun, 14 Apr 2013 19:17:36 -0700
Message-Id: <20130415020614.416982183@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415020614.067692418@linuxfoundation.org>
References: <20130415020614.067692418@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit 83e03b3fe4daffdebbb42151d5410d730ae50bd1 upstream.

On the failure path, stat->start and stat->pages will refer same page.
So it'll attempt to free the same page again and get kernel panic.

Link: http://lkml.kernel.org/r/1364820385-32027-1-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -566,7 +566,6 @@ int ftrace_profile_pages_init(struct ftr
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 


