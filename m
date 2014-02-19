Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaBSWOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:14:46 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48109 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaBSWOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:14:44 -0500
Date: Wed, 19 Feb 2014 14:14:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vegard Nossum <vegardno@ifi.uio.no>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
cc: Xishi Qiu <qiuxishi@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] x86, kmemcheck: Use kstrtoint() instead of sscanf()
In-Reply-To: <alpine.DEB.2.02.1402182344001.3551@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402191412300.31921@chino.kir.corp.google.com>
References: <5304558F.9050605@huawei.com> <alpine.DEB.2.02.1402182344001.3551@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemcheck should use the preferred interface for parsing command line 
arguments, kstrto*(), rather than sscanf() itself.  Use it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/kmemcheck/kmemcheck.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -78,10 +78,16 @@ early_initcall(kmemcheck_init);
  */
 static int __init param_kmemcheck(char *str)
 {
+	int val;
+	int ret;
+
 	if (!str)
 		return -EINVAL;
 
-	sscanf(str, "%d", &kmemcheck_enabled);
+	ret = kstrtoint(str, 0, &val);
+	if (ret)
+		return ret;
+	kmemcheck_enabled = val;
 	return 0;
 }
 
