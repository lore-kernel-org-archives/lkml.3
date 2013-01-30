Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3A3OvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:51:16 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54417
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357Ab3A3OrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/21] perf tools: Fix possible double free on error
Date: Wed, 30 Jan 2013 11:46:58 -0300
Message-Id: <1359557222-17547-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

Can only be triggered via CROSS_COMPILE env var.

Detected by cppcheck.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/36736865.AIlztKhDqN@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 3e975cb..aacef07 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -155,6 +155,7 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 		if (lookup_path(buf))
 			goto out;
 		free(buf);
+		buf = NULL;
 	}
 
 	if (!strcmp(arch, "arm"))
-- 
1.8.1.1.361.gec3ae6e

