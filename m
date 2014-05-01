Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaEATaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:30:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43512 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaEATaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:30:21 -0400
Date: Thu, 1 May 2014 14:29:17 -0500
From: Brian W Hart <hartb@linux.vnet.ibm.com>
To: tj@kernel.org, rusty@trustcorp.com.au, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] cpumask.h: silence warning with -Wsign-compare
Message-ID: <20140501192916.GA6495@oc3347516403.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050119-8236-0000-0000-000001FAF97F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence the warning when building with -Wsign-compare when cpumask.h
is included:

include/linux/cpumask.h: In function ‘cpumask_parse’:
include/linux/cpumask.h:603:26: warning: signed and unsigned type in conditional expression [-Wsign-compare]
  int len = nl ? nl - buf : strlen(buf);
                          ^

Signed-off-by: Brian W Hart <hartb@linux.vnet.ibm.com>
---
Compile tested only.

 include/linux/cpumask.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d08e4d2..0928ce7 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -600,7 +600,7 @@ static inline int cpulist_scnprintf(char *buf, int len,
 static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
 {
 	char *nl = strchr(buf, '\n');
-	int len = nl ? nl - buf : strlen(buf);
+	int len = nl ? nl - buf : (int)strlen(buf);
 
 	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
 }

