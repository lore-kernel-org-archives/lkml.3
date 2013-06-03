Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3FCJZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:25:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FCJZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:25:35 -0400
Date: Mon, 3 Jun 2013 12:25:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] cpqarray: info leak in ida_locked_ioctl()
Message-ID: <20130603092516.GC16171@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pciinfo struct has a two byte hole after ->dev_fn so stack
information could be leaked to the user.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 639d26b..2b94403 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1193,6 +1193,7 @@ out_passthru:
 		ida_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		memset(&pciinfo, 0, sizeof(pciinfo));
 		pciinfo.bus = host->pci_dev->bus->number;
 		pciinfo.dev_fn = host->pci_dev->devfn;
 		pciinfo.board_id = host->board_id;
