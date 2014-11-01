Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaKAWpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:45:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60271 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Randy Dunlap" <rdunlap@infradead.org>,
        "Josh Triplett" <josh@joshtriplett.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.804966269@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 077/102] init/Kconfig: Hide printk log config if
 CONFIG_PRINTK=n
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Triplett <josh@joshtriplett.org>

commit 361e9dfbaae84b0b246ed18d1ab7c82a1a41b53e upstream.

The buffers sized by CONFIG_LOG_BUF_SHIFT and
CONFIG_LOG_CPU_MAX_BUF_SHIFT do not exist if CONFIG_PRINTK=n, so don't
ask about their size at all.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
[bwh: Backported to 3.2: drop change to CONFIG_LOG_CPU_MAX_BUF_SHIFT]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -555,6 +555,7 @@ config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 21
 	default 17
+	depends on PRINTK
 	help
 	  Select kernel log buffer size as a power of 2.
 	  Examples:

