Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaJLUi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:38:29 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:60661 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:38:28 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: sort.c:  Changed from using strncat to strlcat
Date: Sun, 12 Oct 2014 22:40:35 +0200
Message-Id: <1413146435-22202-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat to strlcat to simplify the code

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/sort.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 14e5a03..6e242f0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -759,8 +759,7 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
 	char out[64];
-	size_t sz = sizeof(out) - 1; /* -1 for null termination */
-	size_t i, l = 0;
+	size_t i;
 	u64 m = PERF_MEM_SNOOP_NA;
 
 	out[0] = '\0';
@@ -771,12 +770,9 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
 	for (i = 0; m && i < NUM_SNOOP_ACCESS; i++, m >>= 1) {
 		if (!(m & 0x1))
 			continue;
-		if (l) {
-			strcat(out, " or ");
-			l += 4;
-		}
-		strncat(out, snoop_access[i], sz - l);
-		l += strlen(snoop_access[i]);
+		if (*out != '\0')
+			strlcat(out, " or ", sizeof(out));
+		strlcat(out, snoop_access[i], sizeof(out));
 	}
 
 	if (*out == '\0')
-- 
1.7.10.4

