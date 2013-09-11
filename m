Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3IKRYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:24:25 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:16648 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab3IKRYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:24:22 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Chirag Kantharia <chirag.kantharia@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: RE: [patch -resend] cpqarray: info leak in ida_locked_ioctl()
Thread-Topic: [patch -resend] cpqarray: info leak in ida_locked_ioctl()
Thread-Index: AQHOrsHq6JQA/gQLp0m903ei/gziHJnAyW9A
Date: Wed, 11 Sep 2013 17:23:06 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D0FD6A5@G6W2491.americas.hpqcorp.net>
References: <20130603092516.GC16171@debian> <20130911073800.GA25349@mwanda>
In-Reply-To: <20130911073800.GA25349@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, September 11, 2013 2:38 AM
To: Chirag Kantharia; Andrew Morton
Cc: ISS StorageDev; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Moritz Muehlenhoff
Subject: [patch -resend] cpqarray: info leak in ida_locked_ioctl()

The pciinfo struct has a two byte hole after ->dev_fn so stack information could be leaked to the user.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c index 639d26b..2b94403 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1193,6 +1193,7 @@ out_passthru:
 		ida_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		memset(&pciinfo, 0, sizeof(pciinfo));
 		pciinfo.bus = host->pci_dev->bus->number;
 		pciinfo.dev_fn = host->pci_dev->devfn;
 		pciinfo.board_id = host->board_id;
