Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936891Ab3DJXON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:14:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937179Ab3DJWrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 26/64] libata: fix DMA to stack in reading devslp_timing parameters
Date: Wed, 10 Apr 2013 15:46:23 -0700
Message-Id: <20130410224339.214970921@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 8e725c7f8a60feaa88edacd4dee2c754d5ae7706 upstream.

Commit 803739d25c2343da6d2f95eebdcbc08bf67097d4 ("[libata] replace
sata_settings with devslp_timing"), which was also Cc: stable, used a
stack buffer to receive data from ata_read_log_page(), which triggers
the following warning:
 ahci 0000:00:1f.2: DMA-API: device driver maps memory fromstack [addr=ffff880140469948]

Fix this by using ap->sector_buf instead of a stack buffer.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2329,7 +2329,7 @@ int ata_dev_configure(struct ata_device
 		 * from SATA Settings page of Identify Device Data Log.
 		 */
 		if (ata_id_has_devslp(dev->id)) {
-			u8 sata_setting[ATA_SECT_SIZE];
+			u8 *sata_setting = ap->sector_buf;
 			int i, j;
 
 			dev->flags |= ATA_DFLAG_DEVSLP;


