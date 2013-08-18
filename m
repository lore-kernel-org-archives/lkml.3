Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3HRQCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 12:02:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3HRQCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 12:02:00 -0400
Message-ID: <1376841688.11104.8.camel@t520.redhat.com>
Subject: [PATCH] arm64: wire in generic parport.h
From: Mark Salter <msalter@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 18 Aug 2013 12:01:28 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arm64 port doesn't provide a parport.h which causes a build failure
with some configurations:

  drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory
   #include <asm/parport.h>

This patch wires in the generic parport.h for arm64.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 79a642d..487b0a2 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += local64.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
+generic-y += parport.h                                                                                         
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-- 
1.8.1.4



