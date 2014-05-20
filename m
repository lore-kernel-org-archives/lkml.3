Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaETGEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:04:43 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:45716 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaETGEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:04:41 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:df5:b000:13:741e:391c:1ca8:e221]
Date: Tue, 20 May 2014 18:04:40 +1200
X-Google-Sender-Auth: htIafXs1lWevXl7roLkcoUgXfQg
Message-ID: <CALMkhJxVHSHsBKuiOEnstcLaRnTcGqJWwijfabdxCqYmY+jYjw@mail.gmail.com>
Subject: [PATCH 1/1] ARM: Reduce Netwinder startup message from warning to notice
From: Theuns Verwoerd <theuns.verwoerd@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        theuns.verwoerd@alliedtelesis.co.nz, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theuns Verwoerd <theuns.verwoerd@alliedtelesis.co.nz>

Reduce the level of the Netwinder floating point startup message from KERN_WARN
to KERN_NOTICE, since it is normal (correct) behaviour.

Signed-off-by: Theuns Verwoerd <theuns.verwoerd@alliedtelesis.co.nz>

---

This is useful to support a test framework that monitors the kernel
for unexpected
warnings, in preference to white-listing the spurious warning.  Tested on kernel
version 3.6.11.

diff --git a/arch/arm/nwfpe/fpmodule.c b/arch/arm/nwfpe/fpmodule.c
index 4e729f0..ad68be4 100644
--- a/arch/arm/nwfpe/fpmodule.c
+++ b/arch/arm/nwfpe/fpmodule.c
@@ -98,7 +98,7 @@ static int __init fpe_init(void)
                return 0;

        /* Display title, version and copyright information. */
-       printk(KERN_WARNING "NetWinder Floating Point Emulator V0.97 ("
+       printk(KERN_NOTICE "NetWinder Floating Point Emulator V0.97 ("
               NWFPE_BITS " precision)\n");

        thread_register_notifier(&nwfpe_notifier_block);
