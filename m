Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaJJHzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:55:08 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53283 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaJJHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:55:06 -0400
Date: Fri, 10 Oct 2014 08:55:02 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 3/3] scsi: Use try_rc16 and try_vpd_pages quirks on Hyper-V
 virtual disks
Message-ID: <20141010075502.GD32028@sucs.org>
References: <20141010074901.GA32028@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010074901.GA32028@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance causing
feature tests not to be run (even though those features are correctly announced
elsewhere). Make Hyper-V virtual disks quirk past READ CAPACITY(16) and VPD
page guards so appropriate tests are performed.

This only impacts Hyper-V's VHD/VHDX virtual disks and not passthrough devices.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a1..3eadcb1 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -210,6 +210,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
+	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES | BLIST_TRY_RC16},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
1.9.3

