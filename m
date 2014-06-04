Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaFDVq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:46:58 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48316 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFDVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:46:56 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: svghelper.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:47:50 +0200
Message-Id: <1401918470-3947-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/svghelper.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 43262b8..cdcb332 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -255,9 +255,10 @@ static char *cpu_model(void)
 	/* CPU type */
 	file = fopen("/proc/cpuinfo", "r");
 	if (file) {
-		while (fgets(buf, 255, file)) {
+		while (fgets(buf, sizeof(buf), file)) {
 			if (strstr(buf, "model name")) {
-				strncpy(cpu_m, &buf[13], 255);
+				strncpy(cpu_m, &buf[13], sizeof(cpu_m));
+				cpu_m[sizeof(cpu_m) - 1] = '\0';
 				break;
 			}
 		}
@@ -267,7 +268,7 @@ static char *cpu_model(void)
 	/* CPU type */
 	file = fopen("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies", "r");
 	if (file) {
-		while (fgets(buf, 255, file)) {
+		while (fgets(buf, sizeof(buf), file)) {
 			unsigned int freq;
 			freq = strtoull(buf, NULL, 10);
 			if (freq > max_freq)
-- 
1.7.10.4

