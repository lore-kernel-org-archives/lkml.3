Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3KDQGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:06:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3KDQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:06:19 -0500
Message-ID: <5277C5F8.3080609@infradead.org>
Date: Mon, 04 Nov 2013 08:06:16 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH -next] random: needs linux/device.h for struct device
References: <20131104175916.763e3c0cf001b9f948f2baa7@canb.auug.org.au>
In-Reply-To: <20131104175916.763e3c0cf001b9f948f2baa7@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on x86_64:

drivers/char/random.c: In function 'add_device_attach_randomness':
drivers/char/random.c:837:41: error: dereferencing pointer to incomplete type


need to #include <linux/device.h> for struct device, I think.
Yes, that works.

---
From: Randy Dunlap <rdunlap@infradead.org>

Fix struct device build failure on x86_64 by including <linux/device.h>:

drivers/char/random.c: In function 'add_device_attach_randomness':
drivers/char/random.c:837:41: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20131104.orig/drivers/char/random.c
+++ linux-next-20131104/drivers/char/random.c
@@ -240,6 +240,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/string.h>
+#include <linux/device.h>
 #include <linux/fcntl.h>
 #include <linux/slab.h>
 #include <linux/random.h>




---
