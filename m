Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJQUq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:46:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48471 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaJQUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:46:57 -0400
Date: Fri, 17 Oct 2014 13:46:45 -0700
From: tip-bot for Fabian Frederick <tipbot@zytor.com>
Message-ID: <tip-76ef0db72f8b74bb92e24775d9d7f5ab26352bec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, hpa@linux.intel.com,
        mingo@kernel.org, tglx@linutronix.de, fabf@skynet.be
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, fabf@skynet.be,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1413576066-26925-1-git-send-email-fabf@skynet.be>
References: <1413576066-26925-1-git-send-email-fabf@skynet.be>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86/simplefb: Use PTR_ERR_OR_ZERO
Git-Commit-ID: 76ef0db72f8b74bb92e24775d9d7f5ab26352bec
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

Commit-ID:  76ef0db72f8b74bb92e24775d9d7f5ab26352bec
Gitweb:     http://git.kernel.org/tip/76ef0db72f8b74bb92e24775d9d7f5ab26352bec
Author:     Fabian Frederick <fabf@skynet.be>
AuthorDate: Fri, 17 Oct 2014 22:01:05 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Oct 2014 13:40:52 -0700

x86/simplefb: Use PTR_ERR_OR_ZERO

Replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Link: http://lkml.kernel.org/r/1413576066-26925-1-git-send-email-fabf@skynet.be
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
