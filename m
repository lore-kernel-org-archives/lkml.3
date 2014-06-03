Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbaFCUgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:36:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933533AbaFCUgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:38 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, zhangdianfang <zhangdianfang@huawei.com>,
        Jean Delvare <jdelvare@suse.de>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/9] perf tools: Fix "==" into "=" in ui_browser__warning assignment
Date: Tue,  3 Jun 2014 22:36:12 +0200
Message-Id: <1401827776-4443-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhangdianfang <zhangdianfang@huawei.com>

Convert "==" into "=" in ui_browser__warning assignment.

Bug description: https://bugzilla.kernel.org/show_bug.cgi?id=76751

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Dianfang Zhang <zhangdianfang@huawei.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jean Delvare <jdelvare@suse.de>
Link: http://lkml.kernel.org/r/20140530154709.GC1202@kernel.org
[ changed the changelog a bit ]
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/browser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index d11541d..3ccf6e1 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -194,7 +194,7 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
 		ui_helpline__vpush(format, args);
 		va_end(args);
 	} else {
-		while ((key == ui__question_window("Warning!", text,
+		while ((key = ui__question_window("Warning!", text,
 						   "Press any key...",
 						   timeout)) == K_RESIZE)
 			ui_browser__handle_resize(browser);
-- 
1.8.3.1

