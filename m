Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaJLU3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:29:31 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62862 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaJLU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:29:30 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: docproc.c:  Changed from using strncat to strlcat
Date: Sun, 12 Oct 2014 22:31:37 +0200
Message-Id: <1413145897-21943-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from using strncat to strlcat to simplify the code

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 scripts/docproc.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/scripts/docproc.c b/scripts/docproc.c
index e267e621..dd1d10a 100644
--- a/scripts/docproc.c
+++ b/scripts/docproc.c
@@ -118,10 +118,10 @@ static void exec_kernel_doc(char **svec)
 			perror("fork");
 			exit(1);
 		case  0:
-			memset(real_filename, 0, sizeof(real_filename));
-			strncat(real_filename, kernsrctree, PATH_MAX);
-			strncat(real_filename, "/" KERNELDOCPATH KERNELDOC,
-					PATH_MAX - strlen(real_filename));
+			strlcpy(real_filename, kernsrctree,
+					sizeof(real_filename));
+			strlcat(real_filename, "/" KERNELDOCPATH KERNELDOC,
+					sizeof(real_filename));
 			execvp(real_filename, svec);
 			fprintf(stderr, "exec ");
 			perror(real_filename);
@@ -199,11 +199,9 @@ static void find_export_symbols(char * filename)
 	char line[MAXLINESZ];
 	if (filename_exist(filename) == NULL) {
 		char real_filename[PATH_MAX + 1];
-		memset(real_filename, 0, sizeof(real_filename));
-		strncat(real_filename, srctree, PATH_MAX);
-		strncat(real_filename, "/", PATH_MAX - strlen(real_filename));
-		strncat(real_filename, filename,
-				PATH_MAX - strlen(real_filename));
+		strlcpy(real_filename, srctree, sizeof(real_filename));
+		strlcat(real_filename, "/", sizeof(real_filename));
+		strlcat(real_filename, filename, sizeof(real_filename));
 		sym = add_new_file(filename);
 		fp = fopen(real_filename, "r");
 		if (fp == NULL)	{
@@ -379,10 +377,10 @@ static void find_all_symbols(char *filename)
 		case  0:
 			close(pipefd[0]);
 			dup2(pipefd[1], 1);
-			memset(real_filename, 0, sizeof(real_filename));
-			strncat(real_filename, kernsrctree, PATH_MAX);
-			strncat(real_filename, "/" KERNELDOCPATH KERNELDOC,
-					PATH_MAX - strlen(real_filename));
+			strlcpy(real_filename, kernsrctree,
+					sizeof(real_filename));
+			strlcat(real_filename, "/" KERNELDOCPATH KERNELDOC,
+					sizeof(real_filename));
 			execvp(real_filename, vec);
 			fprintf(stderr, "exec ");
 			perror(real_filename);
-- 
1.7.10.4

