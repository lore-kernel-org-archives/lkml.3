Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3FAJ7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:59:14 -0400
Received: from www17.your-server.de ([213.133.104.17]:32906 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3FAJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:59:04 -0400
Message-ID: <1370080739.29224.36.camel@localhost.localdomain>
Subject: [PATCH] x86, msr/cpuid: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:58:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -143,7 +143,7 @@ static __cpuinit int cpuid_device_create
 
 	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
 			    "cpu%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_RET(dev);
 }
 
 static void cpuid_device_destroy(int cpu)
diff -u -p a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -206,7 +206,7 @@ static int __cpuinit msr_device_create(i
 
 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
 			    "msr%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_RET(dev);
 }
 
 static void msr_device_destroy(int cpu)


