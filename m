Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbaEIScc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:32:32 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:37140 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700AbaEISca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:32:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMXADUebVNXQw5R/2dsb2JhbABZgwaCQaoMBAEBAQEBAQUBmhQCAoEZF3SCZhwjGIECJBOIRQHROoVWiBhkhEcBA48kiiIBiwOHf4M4O4Ew
Date: Fri, 9 May 2014 20:32:25 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH V2] kernel/time/ntp.c: convert simple_strtol to kstrtol
Message-Id: <20140509203225.cc19cf4bc46e3d2647e5ad5f@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace obsolete function

Inspired-By: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2
	-Add patch description
	
 kernel/time/ntp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 419a52c..82b7c9e 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -923,7 +923,10 @@ void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 static int __init ntp_tick_adj_setup(char *str)
 {
-	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	int rc = kstrtol(str, 0, (long *)&ntp_tick_adj);
+
+	if (rc)
+		return rc;
 	ntp_tick_adj <<= NTP_SCALE_SHIFT;
 
 	return 1;
-- 
1.8.4.5

