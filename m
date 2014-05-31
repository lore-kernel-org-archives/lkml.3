Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940AbaEaAZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:25:01 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:39293 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaEaAZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:25:00 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: power: cpupower: bench: parse.c:  Cleaning up use of a non-allocated file resource
Date: Sat, 31 May 2014 02:25:53 +0200
Message-Id: <1401495953-22764-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the risk of using a non-allocated file resource

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/power/cpupower/bench/parse.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/bench/parse.c b/tools/power/cpupower/bench/parse.c
index 543bba1..abc026a 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -103,13 +103,16 @@ FILE *prepare_output(const char *dirname)
 	output = fopen(filename, "w+");
 	if (output == NULL) {
 		perror("fopen");
-		fprintf(stderr, "error: unable to open logfile\n");
+		fprintf(stderr, "error: unable to open logfile: %s\n",
+				filename);
+		goto out;
 	}
 
 	fprintf(stdout, "Logfile: %s\n", filename);
 
-	free(filename);
 	fprintf(output, "#round load sleep performance powersave percentage\n");
+out:
+	free(filename);
 	return output;
 }
 
-- 
1.7.10.4

