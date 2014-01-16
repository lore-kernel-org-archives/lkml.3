Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaAPXkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:40:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaAPXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:40:07 -0500
Date: Thu, 16 Jan 2014 15:39:57 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-28c6a39b3367f29462cd586785dc445cd6b5ac23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1389913624-9149-4-git-send-email-david.a.cohen@linux.intel.com>
References: <1389913624-9149-4-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid:
  Return proper error code from get_gpio_by_name()
Git-Commit-ID: 28c6a39b3367f29462cd586785dc445cd6b5ac23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 15:40:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28c6a39b3367f29462cd586785dc445cd6b5ac23
Gitweb:     http://git.kernel.org/tip/28c6a39b3367f29462cd586785dc445cd6b5ac23
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Thu, 16 Jan 2014 15:07:04 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 16 Jan 2014 15:07:36 -0800

x86, intel-mid: Return proper error code from get_gpio_by_name()

This patch cleans up get_gpio_by_name() to return an error code
instead of hardcoded -1.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1389913624-9149-4-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 1d5d20b..438306e 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -224,7 +224,7 @@ int get_gpio_by_name(const char *name)
 		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
 			return pentry->pin_no;
 	}
-	return -1;
+	return -EINVAL;
 }
 
 void __init intel_scu_device_register(struct platform_device *pdev)
