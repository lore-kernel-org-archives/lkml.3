Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3J0V6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:58:36 -0400
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:58564 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752672Ab3J0V6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:58:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3868:4321:5007:6119:7652:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brick43_106539589c74f
X-Filterd-Recvd-Size: 1999
Message-ID: <1382911111.30941.2.camel@joe-AO722>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Date: Sun, 27 Oct 2013 14:58:31 -0700
In-Reply-To: <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> Physical addresses may be wider than virtual addresses (e.g. on i386
> with PAE) and must not be formatted with %p.

%pa works.  %pa also prefixes with 0x.

> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
[]
> @@ -602,10 +602,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>  	     rdev->lldi.vr->qp.size,
>  	     rdev->lldi.vr->cq.start,
>  	     rdev->lldi.vr->cq.size);
> -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
>  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
>  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> -	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
> +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
>  	     rdev->lldi.db_reg,
>  	     rdev->lldi.gts_reg,
>  	     rdev->qpshift, rdev->qpmask,
> 
> 



