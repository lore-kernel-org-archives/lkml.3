Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3D2HNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:13:30 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:46104 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639Ab3D2HN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:13:29 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: call do_notify_resume() with interrupts enabled
Date: Mon, 29 Apr 2013 10:12:37 +0300
Message-Id: <1367219557-11495-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A signal delivered through do_notify_resume() would cause the
irqs_disabled() check in _local_bh_enable_ip() to be triggered.

Enable interrupts before calling do_notify_resume().

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index d8a455e..55ffc97 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -874,6 +874,7 @@ _work_pending:
  * must be set so that the syscall restart functionality works.
  */
 _work_notifysig:
+	ENABLE_INTERRUPTS(r29)
 	l.jal	do_notify_resume
 	 l.ori	r3,r1,0		  /* pt_regs */
 
-- 
1.8.1.2

