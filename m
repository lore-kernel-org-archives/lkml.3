Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3KCM1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:27:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3KCM1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:27:30 -0500
Date: Sun, 3 Nov 2013 20:27:24 +0800
From: Dave Young <dyoung@redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] boot_delay return value fix
Message-ID: <20131103122724.GA5300@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel report "Malformed early option boot_delay" because it returns non-zero
value. Move to 'return 0' now because there's no reason it should return 1.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
Andrew, It's based on previous patch of changing to early_param.
Feel free to fold them if you want. If need I repost please just tell me. 

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/kernel/printk/printk.c
+++ linux-2.6/kernel/printk/printk.c
@@ -820,7 +820,7 @@ static int __init boot_delay_setup(char
 	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
-	return 1;
+	return 0;
 }
 early_param("boot_delay", boot_delay_setup);
 
