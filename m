Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaJQUBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:01:36 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:48075 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753826AbaJQUBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:01:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwSAEh1QVRXQz/c/2dsb2JhbABbgw6BK7hjAQEBAQEBBQFzmicEAoEVFwF9hF8jgRo3iEMBvzGPCYYiiisdhDUFnVmMZIlBgUcBgjE7L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH 1/1 linux-next] x86/simplefb: use PTR_ERR_OR_ZERO
Date: Fri, 17 Oct 2014 22:01:05 +0200
Message-Id: <1413576066-26925-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kernel/sysfb_simplefb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 86179d4..764a29f 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -88,8 +88,5 @@ __init int create_simplefb(const struct screen_info *si,
 
 	pd = platform_device_register_resndata(NULL, "simple-framebuffer", 0,
 					       &res, 1, mode, sizeof(*mode));
-	if (IS_ERR(pd))
-		return PTR_ERR(pd);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
-- 
1.9.3

