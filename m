Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3FMA1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:27:14 -0400
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:41346 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3FMA1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:27:13 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 12 Jun 2013 17:26:37 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Len Brown <len.brown@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] turbostat: Increase output buffer size to accommodate C8-C10
Message-ID: <20130613002635.GA14920@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms with C8-C10 support, the additional C-states cause
turbostat to overrun its output buffer of 128 bytes per CPU.  Increase
this to 256 bytes per CPU.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
As a bugfix, this should go into 3.10; however, since the C8-C10 support
didn't go in until after 3.9, this need not go into any stable kernel.

 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 9e9d348..fe70207 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2191,7 +2191,7 @@ int initialize_counters(int cpu_id)
 
 void allocate_output_buffer()
 {
-	output_buffer = calloc(1, (1 + topo.num_cpus) * 128);
+	output_buffer = calloc(1, (1 + topo.num_cpus) * 256);
 	outp = output_buffer;
 	if (outp == NULL) {
 		perror("calloc");
-- 
1.8.3.1

