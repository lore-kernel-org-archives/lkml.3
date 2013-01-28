Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3A1I44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:56:56 -0500
Received: from re04.intra2net.com ([82.165.46.26]:38370 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3A1I4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:56:53 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH] Fix NULL pointer dereference on error
Date: Mon, 28 Jan 2013 09:56:49 +0100
Message-ID: <2266358.qvDXKLvJ67@storm>
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pclose(NULL) is undefined behavior and crashes.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/sort.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a83ded2..8333661 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -279,10 +279,12 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 		*nl = '\0';
 	path = self->srcline;
 out_path:
-	pclose(fp);
+	if (fp)
+		pclose(fp);
 	return repsep_snprintf(bf, size, "%s", path);
 out_ip:
-	pclose(fp);
+	if (fp)
+		pclose(fp);
 	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
 }
 
-- 
1.7.11.7

