Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3IHDTD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55973 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397Ab3IHDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Teck Choon Giam" <giamteckchoon@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.943543236@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [001/121] ifb: Include <linux/sched.h>
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit b51c3427e95b ('ifb: fix rcu_sched self-detected stalls', commit
440d57bc5ff5 upstream) added a call to cond_resched(), which is
declared in '#include <linux/sched.h>'.  In Linux 3.2.y that header is
included indirectly in some but not all configurations, so add a
direct #include.

Reported-by: Teck Choon Giam <giamteckchoon@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
+#include <linux/sched.h>
 #include <net/pkt_sched.h>
 #include <net/net_namespace.h>
 

