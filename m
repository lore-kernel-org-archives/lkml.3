Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3DXJa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:30:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3DXJaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:30:23 -0400
Date: Wed, 24 Apr 2013 02:30:07 -0700
From: tip-bot for Wei Yongjun <tipbot@zytor.com>
Message-ID: <tip-3482e664dc7f44e0ffb1fcf1de7af74977748f31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yongjun_wei@trendmicro.com.cn, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yongjun_wei@trendmicro.com.cn, tglx@linutronix.de
In-Reply-To: <CAPgLHd84cboeucog+YNdHvGqTfTROujDKZgSkh3o0B-Q93ee2A@mail.gmail.com>
References: <CAPgLHd84cboeucog+YNdHvGqTfTROujDKZgSkh3o0B-Q93ee2A@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/olpc/xo1/sci: Don't call input_free_device
 () after input_unregister_device()
Git-Commit-ID: 3482e664dc7f44e0ffb1fcf1de7af74977748f31
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

Commit-ID:  3482e664dc7f44e0ffb1fcf1de7af74977748f31
Gitweb:     http://git.kernel.org/tip/3482e664dc7f44e0ffb1fcf1de7af74977748f31
Author:     Wei Yongjun <yongjun_wei@trendmicro.com.cn>
AuthorDate: Wed, 24 Apr 2013 10:46:24 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:44:47 +0200

x86/olpc/xo1/sci: Don't call input_free_device() after input_unregister_device()

input_free_device() should only be used if
input_register_device() was not called yet or if it failed. Once
device was unregistered use input_unregister_device() and memory
will be freed once last reference to the device is dropped.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: dsd@laptop.org
Cc: pgf@laptop.org
Cc: gregkh@linuxfoundation.org
Link: http://lkml.kernel.org/r/CAPgLHd84cboeucog%2BYNdHvGqTfTROujDKZgSkh3o0B-Q93ee2A@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 74704be..9a2e590 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -460,7 +460,6 @@ static int setup_power_button(struct platform_device *pdev)
 static void free_power_button(void)
 {
 	input_unregister_device(power_button_idev);
-	input_free_device(power_button_idev);
 }
 
 static int setup_ebook_switch(struct platform_device *pdev)
@@ -491,7 +490,6 @@ static int setup_ebook_switch(struct platform_device *pdev)
 static void free_ebook_switch(void)
 {
 	input_unregister_device(ebook_switch_idev);
-	input_free_device(ebook_switch_idev);
 }
 
 static int setup_lid_switch(struct platform_device *pdev)
@@ -526,6 +524,7 @@ static int setup_lid_switch(struct platform_device *pdev)
 
 err_create_attr:
 	input_unregister_device(lid_switch_idev);
+	lid_switch_idev = NULL;
 err_register:
 	input_free_device(lid_switch_idev);
 	return r;
@@ -535,7 +534,6 @@ static void free_lid_switch(void)
 {
 	device_remove_file(&lid_switch_idev->dev, &dev_attr_lid_wake_mode);
 	input_unregister_device(lid_switch_idev);
-	input_free_device(lid_switch_idev);
 }
 
 static int xo1_sci_probe(struct platform_device *pdev)
