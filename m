Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbbAZKon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:44:43 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18497 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbbAZKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:44:36 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>, <jeremie.galarneau@efficios.com>,
        <rostedt@goodmis.org>, <alexmonthy@voxpopuli.im>,
        <bigeasy@linutronix.de>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] tools lib traceevent: add priv field to struct format_field.
Date: Mon, 26 Jan 2015 18:38:23 +0800
Message-ID: <1422268705-32084-2-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
References: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54C61A8F.0003,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 33042ab3b10c04604dc3808febfb44f7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a priv field to 'struct format_field' for futher expansion.

(In https://lkml.org/lkml/2015/1/21/383 , Jiri Olsa gives a suggestion
 about changing lib traceevent to solve a bug of perf-convert-to-ctf,
 which is related to duplicated field names. I think his suggestion
 should be something like this patch. )

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

