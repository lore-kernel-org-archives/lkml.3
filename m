Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaGZWyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 18:54:39 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54498 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaGZWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 18:54:37 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Borislav Petkov <bp@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: svghelper.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 00:56:02 +0200
Message-Id: <1406415362-8519-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensures that the string is null-terminate in connection with the
use of strncpy. And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/svghelper.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 6a0a13d..82aec8f 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -257,7 +257,8 @@ static char *cpu_model(void)
 	if (file) {
 		while (fgets(buf, 255, file)) {
 			if (strstr(buf, "model name")) {
-				strncpy(cpu_m, &buf[13], 255);
+				strncpy(cpu_m, &buf[13], sizeof(cpu_m));
+				cpu_m[sizeof(cpu_m) - 1] = '\0';
 				break;
 			}
 		}
-- 
1.7.10.4

