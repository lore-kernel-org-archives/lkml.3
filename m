Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3JNVHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab3JNVHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:07:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>
Cc: linux-kernel@vger.kernel.org
Subject: blk-mq: mtip32xx: set numa node in blk_mq_reg structure
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 14 Oct 2013 17:07:03 -0400
Message-ID: <x49hacja7ew.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The mtip32xx driver figures out its numa node, but never updates its
blk_mq_reg structure.

Patch against the new-queue branch of linux-block.git.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 3c4c668..ca63a00 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3990,6 +3990,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 		my_node, pcibus_to_node(pdev->bus), dev_to_node(&pdev->dev),
 		cpu_to_node(smp_processor_id()), smp_processor_id());
 
+	mtip_mq_reg.numa_node = my_node;
 	dd = kzalloc_node(sizeof(struct driver_data), GFP_KERNEL, my_node);
 	if (dd == NULL) {
 		dev_err(&pdev->dev,
