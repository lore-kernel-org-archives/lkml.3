Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaJQUBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:01:44 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:40117 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbaJQUBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:01:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwSANF0QVRXQz/c/2dsb2JhbABbgw6BK7hjAQEBAQEBBQFzmicEAoEVFwF9hF8jgRo3iEMBvzyPCYYiiUdkHYQ1BZ1ZjGSJQYFHAYIxOy+BBoFFAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH 2/4 linux-next] x86, msr: use PTR_ERR_OR_ZERO
Date: Fri, 17 Oct 2014 22:01:38 +0200
Message-Id: <1413576099-27059-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kernel/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index f1f3ed0..5b14dac 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -206,7 +206,7 @@ static int msr_device_create(int cpu)
 
 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
 			    "msr%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void msr_device_destroy(int cpu)
-- 
1.9.3

