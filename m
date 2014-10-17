Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbaJQUqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:46:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJQUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:46:43 -0400
Date: Fri, 17 Oct 2014 13:46:31 -0700
From: tip-bot for Fabian Frederick <tipbot@zytor.com>
Message-ID: <tip-e8d95ce9705c6683f57dc146b8c726c4d2242a52@git.kernel.org>
Cc: tglx@linutronix.de, fabf@skynet.be, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com
Reply-To: hpa@linux.intel.com, fabf@skynet.be, tglx@linutronix.de,
        hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1413576053-26761-1-git-send-email-fabf@skynet.be>
References: <1413576053-26761-1-git-send-email-fabf@skynet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/sysfb: Use PTR_ERR_OR_ZERO
Git-Commit-ID: e8d95ce9705c6683f57dc146b8c726c4d2242a52
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8d95ce9705c6683f57dc146b8c726c4d2242a52
Gitweb:     http://git.kernel.org/tip/e8d95ce9705c6683f57dc146b8c726c4d2242a52
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Fri, 17 Oct 2014 22:00:53 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Oct 2014 13:40:52 -0700

x86/sysfb: Use PTR_ERR_OR_ZERO

Replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Link: http://lkml.kernel.org/r/1413576053-26761-1-git-send-email-fabf@skynet.be
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
