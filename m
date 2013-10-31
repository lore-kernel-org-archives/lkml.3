Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3JaJbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3JaJbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:31:36 -0400
Date: Thu, 31 Oct 2013 17:31:31 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] enable boot delay for earlyprintk
Message-ID: <20131031093131.GA22206@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously boot_delay does not work for earlyprintk
because the kernel cmdline parsing is late.

Change to use early_param so early kernel messages
can also be delayed.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/kernel/printk/printk.c
+++ linux-2.6/kernel/printk/printk.c
@@ -822,7 +822,7 @@ static int __init boot_delay_setup(char
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
 }
-__setup("boot_delay=", boot_delay_setup);
+early_param("boot_delay", boot_delay_setup);
 
 static void boot_delay_msec(int level)
 {
