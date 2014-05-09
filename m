Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbaEISJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:09:11 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:28326 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756596AbaEISJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:09:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMXACAZbVNXQw5R/2dsb2JhbABZgwaCQaoKBAEBAQEBAQUBmhQCAoEZF3SCZhwjGIECJBOIRQHRNoVWiBgWToRHAQOPJIoiAYsDh3+DODuBMA
Date: Fri, 9 May 2014 20:09:03 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/power/hibernate.c: convert simple_strtoul to
 kstrtoul
Message-Id: <20140509200903.2917158bfbe26723226122c5@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Inspired-By: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/power/hibernate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index f4f2073..66332b6 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1109,7 +1109,10 @@ static int __init resumewait_setup(char *str)
 
 static int __init resumedelay_setup(char *str)
 {
-	resume_delay = simple_strtoul(str, NULL, 0);
+	int rc = kstrtoul(str, 0, (unsigned long *)&resume_delay);
+
+	if (rc)
+		return rc;
 	return 1;
 }
 
-- 
1.8.4.5

