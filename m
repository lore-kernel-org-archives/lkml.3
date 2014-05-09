Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbaEISDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:03:49 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:8589 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbaEISDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:03:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMXADsXbVNXQw5R/2dsb2JhbABZgwaCQaoKBAEBAQEBAQUBmhQCAoEZF3SCZhwjGIECJBOIRQHRMIVWiBhkhEcBA48kiiIBiwOHf4M4O4Ew
Date: Fri, 9 May 2014 20:03:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/1] kernel/hung_task.c: convert simple_strtoul to
 kstrtouint
Message-Id: <20140509200343.11682de148f3efbcab46fba4@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysctl_hung_task_panic has been changed to unsigned int.
use kstrtouint instead of obsolete simple_strtoul

Inspired-By: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/hung_task.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 06bb141..06db124 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -52,8 +52,10 @@ unsigned int __read_mostly sysctl_hung_task_panic =
 
 static int __init hung_task_panic_setup(char *str)
 {
-	sysctl_hung_task_panic = simple_strtoul(str, NULL, 0);
+	int rc = kstrtouint(str, 0, &sysctl_hung_task_panic);
 
+	if (rc)
+		return rc;
 	return 1;
 }
 __setup("hung_task_panic=", hung_task_panic_setup);
-- 
1.8.4.5

