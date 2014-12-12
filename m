Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaLLWii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:38:38 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39934 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaLLWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:38:37 -0500
From: Vinson Lee <vlee@twopensource.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Josh Triplett <josh@joshtriplett.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fabian Frederick <fabf@skynet.be>,
        Bertrand Jacquin <beber@meleeweb.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Clark Williams <clark.williams@gmail.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, Nate Stahl <stahl@twitter.com>,
        Vinson Lee <vlee@twitter.com>
Subject: [PATCH] Increase maximum size of dmesg buffer to 16MB.
Date: Fri, 12 Dec 2014 14:38:26 -0800
Message-Id: <1418423906-5461-1-git-send-email-vlee@twopensource.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nate Stahl <stahl@twitter.com>

A full task stack dump of all tasks on a machine can generate more than
4MB of output to dmesg. Dumping this data to the serial console causes
the machine to hang for a number of minutes (an unacceptable impact),
but dumping the same data to memory is feasible if the dmesg buffer is
sized large enough to hold the output. Set to 16MB which will hopefully
be large enough to handle a dump from any of our servers at this time.

Signed-off-by: Nate Stahl <stahl@twitter.com>
Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 903505e..266a3e8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -812,7 +812,7 @@ config IKCONFIG_PROC
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
-	range 12 21
+	range 12 24
 	default 17
 	depends on PRINTK
 	help
-- 
1.9.1

