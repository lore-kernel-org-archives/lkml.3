Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFEOcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:32:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaFEOce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:32:34 -0400
Date: Thu, 5 Jun 2014 07:31:38 -0700
From: tip-bot for zhangdianfang <tipbot@zytor.com>
Message-ID: <tip-7f3e508ee1e6cc1b5865edcbf04a14a76ff1534c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, zhangdianfang@huawei.com,
        jdelvare@suse.de, dcb314@hotmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, zhangdianfang@huawei.com,
        jolsa@kernel.org, jdelvare@suse.de, dcb314@hotmail.com,
        tglx@linutronix.de
In-Reply-To: <20140530154709.GC1202@kernel.org>
References: <20140530154709.GC1202@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix "==" into "="
  in ui_browser__warning assignment
Git-Commit-ID: 7f3e508ee1e6cc1b5865edcbf04a14a76ff1534c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f3e508ee1e6cc1b5865edcbf04a14a76ff1534c
Gitweb:     http://git.kernel.org/tip/7f3e508ee1e6cc1b5865edcbf04a14a76ff1534c
Author:     zhangdianfang <zhangdianfang@huawei.com>
AuthorDate: Fri, 30 May 2014 08:53:58 +0800
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:34:48 +0200

perf tools: Fix "==" into "=" in ui_browser__warning assignment

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
