Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3DXCqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:46:30 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47005 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3DXCq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:46:29 -0400
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 10:46:24 +0800
Message-ID: <CAPgLHd84cboeucog+YNdHvGqTfTROujDKZgSkh3o0B-Q93ee2A@mail.gmail.com>
Subject: [PATCH -next] x86/olpc/xo1/sci: don't call input_free_device() after input_unregister_device()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, dsd@laptop.org,
        pgf@laptop.org, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

input_free_device() should only be used if input_register_device()
was not called yet or if it failed. Once device was unregistered
use input_unregister_device() and memory will be freed once last
reference to the device is dropped.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
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

