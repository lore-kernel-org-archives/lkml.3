Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3IKE54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3IKE4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:52 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=n_EfMG8JMO4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=T_OX1lMba2EA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=_rarHAXozFHaK-Wks5wA:9 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042930.041921862@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Paul Fox <pgf@laptop.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [227/251] drivers/platform/olpc/olpc-ec.c: initialise earlier
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0227-drivers-platform-olpc-olpc-ec.c-initialise-earlier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

[ Upstream commit 93dbc1b3b506e16c1f6d5b5dcfe756a85cb1dc58 ]

Being a low-level component, various drivers (e.g.  olpc-battery) assume
that it is ok to communicate with the OLPC Embedded Controller during
probe.  Therefore the OLPC EC driver must be initialised before other
drivers try to use it.  This was the case until it was recently moved
out of arch/x86 and restructured around commits ac2504151f5a ("Platform:
OLPC: turn EC driver into a platform_driver") and 85f90cf6ca56 ("x86:
OLPC: switch over to using new EC driver on x86").

Use arch_initcall so that olpc-ec is readied earlier, matching the
previous behaviour.

Fixes a regression introduced in Linux-3.6 where various drivers such as
olpc-battery and olpc-xo1-sci failed to load due to an inability to
communicate with the EC.  The user-visible effect was a lack of battery
monitoring, missing ebook/lid switch input devices, etc.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Paul Fox <pgf@laptop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/platform/olpc/olpc-ec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 0f9f859..f911952 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(void)
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");
-- 
1.7.10.4


