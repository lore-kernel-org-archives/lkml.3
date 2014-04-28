Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaD1Tpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:45:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaD1Tpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:45:50 -0400
Date: Mon, 28 Apr 2014 12:45:30 -0700
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-3894e9e82dfdc87fa35dc7976e0472d220228826@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, robh+dt@kernel.org, r.sricharan@ti.com,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, r.sricharan@ti.com,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20140403072134.GA14286@mwanda>
References: <20140403072134.GA14286@mwanda>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irqchip: irq-crossbar:
  Not allocating enough memory
Git-Commit-ID: 3894e9e82dfdc87fa35dc7976e0472d220228826
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

Commit-ID:  3894e9e82dfdc87fa35dc7976e0472d220228826
Gitweb:     http://git.kernel.org/tip/3894e9e82dfdc87fa35dc7976e0472d220228826
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Thu, 3 Apr 2014 10:21:34 +0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Apr 2014 21:43:24 +0200

irqchip: irq-crossbar: Not allocating enough memory

We are allocating the size of a pointer and not the size of the data.
This will lead to memory corruption.

There isn't actually a "cb_device" struct, btw.  The code is only able
to compile because GCC knows that all pointers are the same size.

Fixes: 96ca848ef7ea ('DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sricharan R <r.sricharan@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Link: http://lkml.kernel.org/r/20140403072134.GA14286@mwanda
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/irqchip/irq-crossbar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index fc817d2..3d15d16 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -107,7 +107,7 @@ static int __init crossbar_of_init(struct device_node *node)
 	int i, size, max, reserved = 0, entry;
 	const __be32 *irqsr;
 
-	cb = kzalloc(sizeof(struct cb_device *), GFP_KERNEL);
+	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
 
 	if (!cb)
 		return -ENOMEM;
