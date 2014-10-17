Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaJQUBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:01:23 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:11121 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbaJQUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:01:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwSACB0QVRXQz/c/2dsb2JhbABbgw6BK7hjAQEBAQEBBQFzmicEAoEVFwF9hF8jgRo3iEMBv0aPCYYiiUdkHYQ1BZ1ZjGSJQYFHAYIxOy+BBoFFAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH 1/1 linux-next] x86, cpuid: use PTR_ERR_OR_ZERO
Date: Fri, 17 Oct 2014 22:01:17 +0200
Message-Id: <1413576077-26969-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kernel/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 3225ae6c..83741a7 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -143,7 +143,7 @@ static int cpuid_device_create(int cpu)
 
 	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
 			    "cpu%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void cpuid_device_destroy(int cpu)
-- 
1.9.3

