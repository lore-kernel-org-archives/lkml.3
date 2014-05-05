Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaEEPVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:21:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56210 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaEEPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:21:23 -0400
Date: Mon, 5 May 2014 10:21:14 -0500
From: Brian W Hart <hartb@linux.vnet.ibm.com>
To: tj@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH v2] cpumask.h: silence warning with -Wsign-compare
Message-ID: <20140505152113.GB9463@oc3347516403.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050515-3532-0000-0000-0000018638EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence the warning when building with -Wsign-compare when cpumask.h
is included:

include/linux/cpumask.h: In function ‘cpumask_parse’:
include/linux/cpumask.h:603:26: warning: signed and unsigned type in conditional
+expression [-Wsign-compare]
  int len = nl ? nl - buf : strlen(buf);
                          ^

V2: Rusty pointed out that unsigned should be used instead.

Signed-off-by: Brian W Hart <hartb@linux.vnet.ibm.com>
---
 include/linux/cpumask.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d08e4d2..3557ea7 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -600,7 +600,7 @@ static inline int cpulist_scnprintf(char *buf, int len,
 static inline int cpumask_parse(const char *buf, struct cpumask *dstp)
 {
 	char *nl = strchr(buf, '\n');
-	int len = nl ? nl - buf : strlen(buf);
+	unsigned int len = nl ? (unsigned int)(nl - buf) : strlen(buf);
 
 	return bitmap_parse(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
 }

