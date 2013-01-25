Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3AYKWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:22:40 -0500
Received: from re04.intra2net.com ([82.165.46.26]:55563 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3AYKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:22:35 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH 3/3] Fix double fclose() on do_write(fd, xxx) failure
Date: Fri, 25 Jan 2013 11:22:17 +0100
Message-ID: <2684910.12iLzy42t4@storm>
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported:
[util/header.c:983]: (error) Used file that is not opened.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/header.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7b24cf3..30745c2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -955,6 +955,7 @@ static int write_topo_node(int fd, int node)
 	}
 
 	fclose(fp);
+	fp = NULL;
 
 	ret = do_write(fd, &mem_total, sizeof(u64));
 	if (ret)
-- 
1.7.11.7

