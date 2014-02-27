Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaB0LkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:40:23 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49737 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaB0LkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:40:19 -0500
Date: Thu, 27 Feb 2014 17:10:12 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, josh@joshtriplett.org
Subject: [PATCH 12/46] kernel: Include appropriate header file in
 kernel/irq/irqdomain.c
Message-ID: <eb89aebea7ff1a46122918ac389ebecf8248be9a.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/of_irq.h in
kernel/irq/irqdomain.c because it contains prototype definition of
function define in kernel/irq/irqdomain.c.

This eliminates the following warning in kernel/irq/irqdomain.c:
kernel/irq/irqdomain.c:468:14: warning: no previous prototype for ‘irq_create_of_mapping’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/irq/irqdomain.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cf68bb3..f140337 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/topology.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-- 
1.7.9.5

