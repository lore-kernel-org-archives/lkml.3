Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3EBPQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006Ab3EBPQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Robert Richter <rric@kernel.org>, oprofile-list@lists.sf.net
Subject: [PATCH, RFC 14/22] oprofile: always enable IRQ_WORK
Date: Thu,  2 May 2013 17:16:18 +0200
Message-Id: <1367507786-505303-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VaKeZ7xEIWv4gBxy6AIUcdjaXoCiPq8C6L5rZ1CL2I9
 PdabqNwPJqJ2YO8E9cpnTtAyEh6sSphEECVo70CWNes0yVkzPs
 r6NfrdatK/xuq7b3xR+g+sCyydZKzJDXD4YefEtSlXHJflFXeC
 3zhACycbM3cb+DueQymFuRRD8l4+KibW7js5CSj8X03t4FaBac
 jMYtsqox8UEHOwZeIaESJUsWfwRoNhD9P7B5IpSipCOCs3KtzD
 UCyPpXO8rjIdqrdVpVRKOIM2R97MK8rnoAaQ43Olojpn2N1UQX
 +TRx1J9WKWCA+ESbAJZhd8vtbncDe0tzKeX5HZL7tB0SRR/PSA
 as+LWGrLYSGfX1ZGqTDNPUhF4n0PC3LNAgSsh9x7P
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oprofile fails to build if CONFIG_IRQ_WORK is not already enabled,
because of the dependency on the RING_BUFFER code that now uses
the irq work library.

kernel/built-in.o: In function `ring_buffer_unlock_commit':
:(.text+0x5b8f0): undefined reference to `irq_work_queue'
kernel/built-in.o: In function `ring_buffer_write':
:(.text+0x5bd10): undefined reference to `irq_work_queue'

Cc: Robert Richter <rric@kernel.org>
Cc: oprofile-list@lists.sf.net
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index a6b1056..434a8dc 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -8,6 +8,7 @@ config OPROFILE
 	depends on HAVE_OPROFILE
 	select RING_BUFFER
 	select RING_BUFFER_ALLOW_SWAP
+	select IRQ_WORK
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
-- 
1.8.1.2

