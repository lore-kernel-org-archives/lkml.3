Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaEPMs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:48:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Helge Deller" <deller@gmx.de>
Date: Fri, 16 May 2014 13:47:20 +0100
Message-ID: <lsq.1400244440.993454076@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 04/34] parisc: fix epoll_pwait syscall on compat kernel
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit ab3e55b119c9653b19ea4edffb86f04db867ac98 upstream.

This bug was detected with the libio-epoll-perl debian package where the
test case IO-Ppoll-compat.t failed.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/kernel/syscall_table.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -395,7 +395,7 @@
 	ENTRY_COMP(vmsplice)
 	ENTRY_COMP(move_pages)		/* 295 */
 	ENTRY_SAME(getcpu)
-	ENTRY_SAME(epoll_pwait)
+	ENTRY_COMP(epoll_pwait)
 	ENTRY_COMP(statfs64)
 	ENTRY_COMP(fstatfs64)
 	ENTRY_COMP(kexec_load)		/* 300 */

