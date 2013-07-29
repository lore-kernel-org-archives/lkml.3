Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3G2QGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:06:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:63767 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3G2QGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:06:13 -0400
From: Julien Grall <julien.grall@linaro.org>
To: stefano.stabellini@eu.citrix.com
Cc: ian.campbell@citrix.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] xen/arm: missing put_cpu in xen_percpu_init
Date: Mon, 29 Jul 2013 17:06:05 +0100
Message-Id: <1375113966-2859-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PREEMPT is enabled, Linux will not be able to boot and warn:
[    4.127825] ------------[ cut here ]------------
[    4.133376] WARNING: at init/main.c:699 do_one_initcall+0x150/0x158()
[    4.140738] initcall xen_init_events+0x0/0x10c returned with preemption imbalance

This is because xen_percpu_init uses get_cpu but doesn't have the corresponding
put_cpu.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 arch/arm/xen/enlighten.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index f71c37e..dc9f284 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -170,6 +170,7 @@ static void __init xen_percpu_init(void *unused)
 	per_cpu(xen_vcpu, cpu) = vcpup;
 
 	enable_percpu_irq(xen_events_irq, 0);
+	put_cpu();
 }
 
 static void xen_restart(char str, const char *cmd)
-- 
1.7.10.4

