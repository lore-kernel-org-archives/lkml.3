Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3IMIGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:06:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48073 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3IMIGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:06:23 -0400
Date: Fri, 13 Sep 2013 11:06:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 4/4] skd: remove unneeded NULL check
Message-ID: <20130913080610.GH19211@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already dereferenced "skdev" a few lines earlier in the debug code so
my static checker complains.  I audited the callers and "skdev" is never
NULL here so I have removed the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 20ad843..827f927 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -2909,7 +2909,7 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 
 	inq.page_code = DRIVER_INQ_EVPD_PAGE_CODE;
 
-	if (skdev && skdev->pdev && skdev->pdev->bus) {
+	if (skdev->pdev && skdev->pdev->bus) {
 		skd_get_link_info(skdev->pdev,
 				  &inq.pcie_link_speed, &inq.pcie_link_lanes);
 		inq.pcie_bus_number = cpu_to_be16(skdev->pdev->bus->number);
