Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaEGTxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:08 -0400
Received: from mout.gmx.net ([212.227.17.20]:61054 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaEGTxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:04 -0400
Date: Wed, 7 May 2014 21:26:43 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        linux-kernel@vger.kernel.org, tulinizer@gmail.com,
        michael.banken@mathe.stud.uni-erlangen.de,
        andriy.shevchenko@linux.intel.com, dan.carpenter@oracle.com,
        lorenz@badgers.com
Subject: [PATCH v3] staging: silicom: Remove unused pointer in
 bypass_init_module()
Message-ID: <20140507212643.693e203a@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:7d4lM2TClFLlBOObyvELNsqSTsq3s/hjs8PLdbhf8wUJRJw4Gug
 iF08raVILkNCn+ZY8AUUOd+W/wG6KO4Iq7GZWmxvA/YmcFgLUGEw6qXnwMpd5SwnTqfYnSe
 jMiN4LmoGU/iBkgacHgxs6kY5LGQeNVKSSSYCB4UyO68kFYowQNOMF0/N9oo7h+VMSgoQzw
 xXBo3ytaw8P7njzOyfsEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointer 'pbpctl_dev_c' in function bypass_init_module() is unused. Thus remove
it. With the last variable declaration gone, there is no more need for an own
block. Remove it and adapt the indenting accordingly.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v3: Resend after v2 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

v2: Added changes requested by Dan Carpenter:

    Dan pointed out that with the declaration gone, the indent block shall be
    removed. This was intentionally left out in v1 in order to keep the
    changeset more readable. However, according to the input, also with the
    additional indenting change this still qualifies for one logical change.

Compile tested and applies against v3.15-rc2 as well as branch staging-next
of tree git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/silicom/bpctl_mod.c | 41 +++++++++++++++----------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 7f3d884..2fb9a6f 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -6371,33 +6371,26 @@ static int __init bypass_init_module(void)
 
 	sema_init(&bpctl_sema, 1);
 	spin_lock_init(&bpvm_lock);
-	{
-
-		struct bpctl_dev *pbpctl_dev_c = NULL;
-		for (idx_dev = 0, dev = bpctl_dev_arr;
-		     idx_dev < device_num && dev->pdev;
-		     idx_dev++, dev++) {
-			if (dev->bp_10g9) {
-				pbpctl_dev_c = get_status_port_fn(dev);
-				if (is_bypass_fn(dev)) {
-					printk(KERN_INFO "%s found, ",
-					       dev->name);
-					dev->bp_fw_ver = bypass_fw_ver(dev);
-					printk("firmware version: 0x%x\n",
-					       dev->bp_fw_ver);
-				}
-				dev->wdt_status = WDT_STATUS_UNKNOWN;
-				dev->reset_time = 0;
-				atomic_set(&dev->wdt_busy, 0);
-				dev->bp_status_un = 1;
-
-				bypass_caps_init(dev);
-
-				init_bypass_wd_auto(dev);
-				init_bypass_tpl_auto(dev);
 
+	for (idx_dev = 0, dev = bpctl_dev_arr;
+	     idx_dev < device_num && dev->pdev;
+	     idx_dev++, dev++) {
+		if (dev->bp_10g9) {
+			if (is_bypass_fn(dev)) {
+				printk(KERN_INFO "%s found, ", dev->name);
+				dev->bp_fw_ver = bypass_fw_ver(dev);
+				printk("firmware version: 0x%x\n",
+				       dev->bp_fw_ver);
 			}
+			dev->wdt_status = WDT_STATUS_UNKNOWN;
+			dev->reset_time = 0;
+			atomic_set(&dev->wdt_busy, 0);
+			dev->bp_status_un = 1;
+
+			bypass_caps_init(dev);
 
+			init_bypass_wd_auto(dev);
+			init_bypass_tpl_auto(dev);
 		}
 	}
 
-- 
1.9.1

