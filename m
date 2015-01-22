Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbbAVFmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:42:40 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:35482 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbAVFmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:42:32 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>, <rostedt@goodmis.org>
CC: <jeremie.galarneau@efficios.com>, <bigeasy@linutronix.de>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 1/2] tools lib traceevent: add priv field to truct format_field.
Date: Thu, 22 Jan 2015 13:36:32 +0800
Message-ID: <1421904992-24189-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In https://lkml.org/lkml/2015/1/21/383 , Jiri Olsa gives a suggestion
about changing lib traceevent to solve a bug of perf-convert-to-ctf,
which is related to duplicated field names. I think his suggestion
should be something like this patch.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/lib/traceevent/event-parse.c | 2 ++
 tools/lib/traceevent/event-parse.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index cf3a44b..5f76003 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5909,6 +5909,8 @@ static void free_format_fields(struct format_field *field)
 		free(field->type);
 		free(field->name);
 		free(field);
+		if (field->destroy_priv)
+			field->destroy_priv(field);
 		field = next;
 	}
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 7a3873f..928d801 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -190,6 +190,8 @@ struct format_field {
 	unsigned int		arraylen;
 	unsigned int		elementsize;
 	unsigned long		flags;
+	void			*priv;
+	void 			(*destroy_priv)(struct format_field *);
 };
 
 struct format {
-- 
1.8.4

