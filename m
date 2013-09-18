Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab3IRKTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:19:37 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:52950 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752184Ab3IRKT0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:19:26 -0400
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 06:19:15 EDT
X-ASG-Debug-ID: 1379498808-053ea9589085f50001-xx1T2L
X-Barracuda-Envelope-From: AkhilAshok.Bhansali@hgst.com
From: Akhil Bhansali <AkhilAshok.Bhansali@hgst.com>
To: Jens Axboe <axboe@kernel.dk>
CC: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Amit Phansalkar" <Amit.Phansalkar@hgst.com>
Subject: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Topic: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
X-ASG-Orig-Subj: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Index: AQHOryuGetr1quWh0UWdC/r7zgDmkZnDouGK//+jooCACAdm4A==
Date: Wed, 18 Sep 2013 10:05:49 +0000
Message-ID: <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
 <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>,<52332E6B.9060405@kernel.dk>
In-Reply-To: <52332E6B.9060405@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.20.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1379498808
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140722
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please accept this patch that takes care of warnings related to i386 compilation.
1. Implicit function declaration of readq and writeq.
2. Format related warnings for VPRINTK.
----
>From f9964257c83f224c120ecb1e5a7b25e1807efea8 Mon Sep 17 00:00:00 2001
From: Akhil Bhansali <bhansaliakhil@gmail.com>
Date: Wed, 18 Sep 2013 15:28:39 +0530
Subject: [PATCH] block: skd: Changes to fix warnings during i386 compilation.

1. This commit addresses warnings related to
readq, writeq implicit function declaration.
2. Warnings related to mismatched format.
Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
---
 drivers/block/skd_main.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 773e793..0f25830 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -49,6 +49,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <asm-generic/unaligned.h>
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
 
 #include "skd_s1120.h"
 
@@ -4557,7 +4558,7 @@ static int skd_cons_skmsg(struct skd_device *skdev)
 	u32 i;
 
 	VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
-		sizeof(struct skd_fitmsg_context),
+		(unsigned long) sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
 		(unsigned long) sizeof(struct skd_fitmsg_context) *
 					skdev->num_fitmsg_context);
@@ -4612,9 +4613,10 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	u32 i;
 
 	VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
-		sizeof(struct skd_request_context),
+		(unsigned long) sizeof(struct skd_request_context),
 		skdev->num_req_context,
-		sizeof(struct skd_request_context) * skdev->num_req_context);
+		(unsigned long) sizeof(struct skd_request_context) *
+				skdev->num_req_context);
 
 	skdev->skreq_table = kzalloc(sizeof(struct skd_request_context)
 				     * skdev->num_req_context, GFP_KERNEL);
@@ -4624,8 +4626,10 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	}
 
 	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
-		skdev->sgs_per_request, sizeof(struct scatterlist),
-		skdev->sgs_per_request * sizeof(struct scatterlist));
+		skdev->sgs_per_request,
+		(unsigned long) sizeof(struct scatterlist),
+		(unsigned long)(skdev->sgs_per_request *
+			sizeof(struct scatterlist)));
 
 	for (i = 0; i < skdev->num_req_context; i++) {
 		struct skd_request_context *skreq;
@@ -4669,9 +4673,10 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 	u32 i, nbytes;
 
 	VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
-		sizeof(struct skd_special_context),
+		(unsigned long) sizeof(struct skd_special_context),
 		skdev->n_special,
-		sizeof(struct skd_special_context) * skdev->n_special);
+		(unsigned long) sizeof(struct skd_special_context) *
+			skdev->n_special);
 
 	skdev->skspcl_table = kzalloc(sizeof(struct skd_special_context)
 				      * skdev->n_special, GFP_KERNEL);
-- 
1.7.9.5

___________________ _____________________
From: Jens Axboe [axboe@kernel.dk]
Sent: Friday, September 13, 2013 8:55 PM
To: Akhil Bhansali
Cc: kbuild test robot; OS Engineering; Ramprasad Chinthekindi; jmoyer@redhat.com; linux-kernel@vger.kernel.org
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq'

On 09/13/2013 06:59 AM, Akhil Bhansali wrote:
> This patch takes care of warnings related to
> 1. Implicit function declaration for readq / writeq.
> 2. Warnings related to -Wformat.

Please do it on top of what was already fixed up. The readq, for
instance, is not even used in the driver.

--
Jens Axboe

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
