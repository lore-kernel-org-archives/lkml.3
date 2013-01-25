Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3AYKWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:22:01 -0500
Received: from re04.intra2net.com ([82.165.46.26]:55559 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab3AYKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:21:58 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH 2/3] Fix memory leak for the "Not caching a kptr_restrict'ed /proc/kallsyms\n" case
Date: Fri, 25 Jan 2013 11:21:39 +0100
Message-ID: <9377388.0eFDp53iW6@storm>
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reported:
[util/header.c:316]: (error) Memory leak: filename
[util/header.c:316]: (error) Memory leak: linkname

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/header.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e17a8fe..7b24cf3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -313,7 +313,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (is_kallsyms) {
 		if (symbol_conf.kptr_restrict) {
 			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
-			return 0;
+			err = 0;
+			goto out_free;
 		}
 		realname = (char *) name;
 	} else
-- 
1.7.11.7

