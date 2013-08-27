Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3H0BO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:14:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3H0BH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Paul Fox <pgf@laptop.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 56/74] drivers/platform/olpc/olpc-ec.c: initialise earlier
Date: Mon, 26 Aug 2013 18:08:54 -0700
Message-Id: <20130827010436.135711045@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit 93dbc1b3b506e16c1f6d5b5dcfe756a85cb1dc58 upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/olpc/olpc-ec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(vo
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");


