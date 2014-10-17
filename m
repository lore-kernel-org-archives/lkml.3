Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaJQUA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:00:59 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:36141 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbaJQUA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:00:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwSACB0QVRXQz/c/2dsb2JhbABbgw6BK7hjAQEBAQEBBQFzmicEAoEVFwF9hF8jgRo3iEMBv0aPCYYiiUdkHYQ1BZ1ZjGSJQYFHAYIxOy+BBoFFAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH 1/1 linux-next] x86: sysfb: use PTR_ERR_OR_ZERO
Date: Fri, 17 Oct 2014 22:00:53 +0200
Message-Id: <1413576053-26761-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kernel/sysfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index 193ec2c..160386e 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -67,7 +67,7 @@ static __init int sysfb_init(void)
 
 	pd = platform_device_register_resndata(NULL, name, 0,
 					       NULL, 0, si, sizeof(*si));
-	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
 
 /* must execute after PCI subsystem for EFI quirks */
-- 
1.9.3

