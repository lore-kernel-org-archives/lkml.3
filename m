Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaF3GYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:24:33 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54890 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaF3GYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:24:32 -0400
Date: Mon, 30 Jun 2014 09:24:27 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: gregkh@linuxfoundation.org
Cc: paulmck@linux.vnet.ibm.com, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, benoit.taine@lip6.fr,
        wei@trendmicro.com.cn, ching@realsil.com.cn,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH next-20140627] drivers/staging/rts5208/rtsx.c: sparse warning
 corrections
Message-ID: <20140630062427.GA31606@outside>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Sparse warning corrections for incorrect printk format characters.

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index c0a0e60..e0e8693 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -463,14 +463,14 @@ static int rtsx_control_thread(void *__dev)
                 * the maximum known LUN
                 */
                else if (chip->srb->device->id) {
-                       dev_err(&dev->pci->dev, "Bad target number (%d:%d)\n",
+                       dev_err(&dev->pci->dev, "Bad target number (%d:%llu)\n",
                                chip->srb->device->id,
                                chip->srb->device->lun);
                        chip->srb->result = DID_BAD_TARGET << 16;
                }
 
                else if (chip->srb->device->lun > chip->max_lun) {
-                       dev_err(&dev->pci->dev, "Bad LUN (%d:%d)\n",
+                       dev_err(&dev->pci->dev, "Bad LUN (%d:%llu)\n",
                                chip->srb->device->id,
                                chip->srb->device->lun);
                        chip->srb->result = DID_BAD_TARGET << 16;
