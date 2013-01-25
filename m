Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3AYJ51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:57:27 -0500
Received: from re04.intra2net.com ([82.165.46.26]:48453 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3AYJ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:57:24 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH resend] Fix possible double free on error
Date: Fri, 25 Jan 2013 10:57:08 +0100
Message-ID: <36736865.AIlztKhDqN@storm>
Organization: Intra2net AG
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can only be triggered via CROSS_COMPILE env var.
Detected by cppcheck.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
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
1.7.11.7

