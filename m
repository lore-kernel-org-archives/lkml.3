Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3IKHij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:38:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3IKHih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:38:37 -0400
Date: Wed, 11 Sep 2013 10:38:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chirag Kantharia <chirag.kantharia@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Moritz Muehlenhoff <jmm@debian.org>
Subject: [patch -resend] cpqarray: info leak in ida_locked_ioctl()
Message-ID: <20130911073800.GA25349@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603092516.GC16171@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pciinfo struct has a two byte hole after ->dev_fn so stack
information could be leaked to the user.

This was assigned CVE-2013-2147.

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
