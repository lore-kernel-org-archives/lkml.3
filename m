Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3IWMBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:01:07 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:34844 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753674Ab3IWMAs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:00:48 -0400
X-ASG-Debug-ID: 1379937643-053ea95890193f10001-xx1T2L
X-Barracuda-Envelope-From: Akhil.Bhansali@hgst.com
From: Akhil Bhansali <Akhil.Bhansali@hgst.com>
To: Jens Axboe <axboe@kernel.dk>
CC: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Amit Phansalkar" <Amit.Phansalkar@hgst.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Topic: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
X-ASG-Orig-Subj: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Index: AQHOryuGetr1quWh0UWdC/r7zgDmkZnDouGK//+jooCACAdm4P//xoAAgAHuFHSABkKTFA==
Date: Mon, 23 Sep 2013 11:59:39 +0000
Message-ID: <87B0A48E21A1974AB4780BA3191524C20F6553@MYMBX3.stec-inc.ad>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
 <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
 <52332E6B.9060405@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>,<20130918143616.GD28478@kernel.dk>,<87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad>
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[172.30.8.22]
X-Barracuda-Start-Time: 1379937643
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140846
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

I am sending a patch created on top of "Andrew's latest changes" to disable the 32 bit compilation of kronos driver.

The patch takes care of following.
1. checkpatch.pl was showing 3 errors for assignment in if condition, I have got rid of that.
2. removal of readq / readl functions which are not used in the code.
3. warnings related to VPRINTKs for 64 bit compilation after latest fix from Andrew.

--------------------------
I have tested the patch with checkpatch.pl. Here is the current output of the script.
total: 0 errors, 61 warnings, 5826 lines checked
--------------------------

I have compiled the changes for x86_64 architecture and there are no outstanding warnings.

Please let us know if you see any review comments. Thank you.

------
>From 16f5b92dbc98c914831a64b58927dfc4c5c1fd39 Mon Sep 17 00:00:00 2001
From: Akhil Bhansali <bhansaliakhil@gmail.com>
Date: Mon, 23 Sep 2013 15:59:51 +0530
Subject: [PATCH] Fix checkpatch ERRORS and removed unused functions.

This patch fixes checkpatch.pl errors for assignment in if condition.
It also removes unused readq / readl function calls.

As Andrew had disabled the compilation of drivers for 32 bit,
I have modified format specifiers in few VPRINTKs to avoid warnings
during 64 bit compilation.
Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
Reviewed-by: Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>
---
 drivers/block/skd_main.c |   53 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3110f68..308bf47 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -420,14 +420,10 @@ static inline void skd_reg_write32(struct skd_device *skdev, u32 val,
 	if (likely(skdev->dbg_level < 2)) {
 		writel(val, skdev->mem_map[1] + offset);
 		barrier();
-		readl(skdev->mem_map[1] + offset);
-		barrier();
 	} else {
 		barrier();
 		writel(val, skdev->mem_map[1] + offset);
 		barrier();
-		readl(skdev->mem_map[1] + offset);
-		barrier();
 		VPRINTK(skdev, "offset %x = %x\n", offset, val);
 	}
 }
@@ -438,14 +434,10 @@ static inline void skd_reg_write64(struct skd_device *skdev, u64 val,
 	if (likely(skdev->dbg_level < 2)) {
 		writeq(val, skdev->mem_map[1] + offset);
 		barrier();
-		readq(skdev->mem_map[1] + offset);
-		barrier();
 	} else {
 		barrier();
 		writeq(val, skdev->mem_map[1] + offset);
 		barrier();
-		readq(skdev->mem_map[1] + offset);
-		barrier();
 		VPRINTK(skdev, "offset %x = %016llx\n", offset, val);
 	}
 }
@@ -1656,18 +1648,36 @@ static int skd_ioctl_sg_io(struct skd_device *skdev, fmode_t mode,
 		goto out;
 	}
 
-	if ((rc = skd_sg_io_get_and_check_args(skdev, &sksgio)) ||
-	    (rc = skd_sg_io_obtain_skspcl(skdev, &sksgio)) ||
-	    (rc = skd_sg_io_prep_buffering(skdev, &sksgio)) ||
-	    (rc = skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_TO_DEV)))
+	rc = skd_sg_io_get_and_check_args(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc = skd_sg_io_obtain_skspcl(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc = skd_sg_io_prep_buffering(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc = skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_TO_DEV);
+	if (rc)
 		goto out;
 
-	if ((rc = skd_sg_io_send_fitmsg(skdev, &sksgio)) ||
-	    (rc = skd_sg_io_await(skdev, &sksgio)))
+	rc = skd_sg_io_send_fitmsg(skdev, &sksgio);
+	if (rc)
 		goto out;
 
-	if ((rc = skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_FROM_DEV)) ||
-	    (rc = skd_sg_io_put_status(skdev, &sksgio)))
+	rc = skd_sg_io_await(skdev, &sksgio);
+	if (rc)
+		goto out;
+
+	rc = skd_sg_io_copy_buffer(skdev, &sksgio, SG_DXFER_FROM_DEV);
+	if (rc)
+		goto out;
+
+	rc = skd_sg_io_put_status(skdev, &sksgio);
+	if (rc)
 		goto out;
 
 	rc = 0;
@@ -4556,11 +4566,10 @@ static int skd_cons_skmsg(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
+	VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
 		sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
-		(unsigned long) sizeof(struct skd_fitmsg_context) *
-					skdev->num_fitmsg_context);
+		sizeof(struct skd_fitmsg_context) * skdev->num_fitmsg_context);
 
 	skdev->skmsg_table = kzalloc(sizeof(struct skd_fitmsg_context)
 				     *skdev->num_fitmsg_context, GFP_KERNEL);
@@ -4611,7 +4620,7 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
+	VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
 		sizeof(struct skd_request_context),
 		skdev->num_req_context,
 		sizeof(struct skd_request_context) * skdev->num_req_context);
@@ -4623,7 +4632,7 @@ static int skd_cons_skreq(struct skd_device *skdev)
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
+	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
 		skdev->sgs_per_request, sizeof(struct scatterlist),
 		skdev->sgs_per_request * sizeof(struct scatterlist));
 
@@ -4668,7 +4677,7 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
+	VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
 		sizeof(struct skd_special_context),
 		skdev->n_special,
 		sizeof(struct skd_special_context) * skdev->n_special);
-- 
1.7.9.5
________________________________________
From: Akhil Bhansali
Sent: Thursday, September 19, 2013 5:39 PM
To: Jens Axboe
Cc: kbuild test robot; OS Engineering; Ramprasad Chinthekindi; jmoyer@redhat.com; linux-kernel@vger.kernel.org; Amit Phansalkar
Subject: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq'

Hi Jens,

Here is patch which takes care of removal of unused readq / readl function. I shall get rid of many VPRINTKs in the code in the subsequent patches.

I have prepared this patch on top of earlier patch I had sent out.  Please let me know if you have any comments.

Thank you.
--------------
>From 0c175433db8079e93890ebfcd736fa8756aa88af Mon Sep 17 00:00:00 2001
From: Akhil Bhansali <bhansaliakhil@gmail.com>
Date: Thu, 19 Sep 2013 17:28:18 +0530
Subject: [PATCH] block: skd: Changes to remove unused readq / readl function
 calls.

These changes are to remove readq functions which is not used.
Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
---
 drivers/block/skd_main.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 0f25830..4c03b08 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -421,14 +421,10 @@ static inline void skd_reg_write32(struct skd_device *skdev, u32 val,
        if (likely(skdev->dbg_level < 2)) {
                writel(val, skdev->mem_map[1] + offset);
                barrier();
-               readl(skdev->mem_map[1] + offset);
-               barrier();
        } else {
                barrier();
                writel(val, skdev->mem_map[1] + offset);
                barrier();
-               readl(skdev->mem_map[1] + offset);
-               barrier();
                VPRINTK(skdev, "offset %x = %x\n", offset, val);
        }
 }
@@ -439,14 +435,10 @@ static inline void skd_reg_write64(struct skd_device *skdev, u64 val,
        if (likely(skdev->dbg_level < 2)) {
                writeq(val, skdev->mem_map[1] + offset);
                barrier();
-               readq(skdev->mem_map[1] + offset);
-               barrier();
        } else {
                barrier();
                writeq(val, skdev->mem_map[1] + offset);
                barrier();
-               readq(skdev->mem_map[1] + offset);
-               barrier();
                VPRINTK(skdev, "offset %x = %016llx\n", offset, val);
        }
 }
--
________________________________________
From: Jens Axboe [axboe@kernel.dk]
Sent: Wednesday, September 18, 2013 8:06 PM
To: Akhil Bhansali
Cc: kbuild test robot; OS Engineering; Ramprasad Chinthekindi; jmoyer@redhat.com; linux-kernel@vger.kernel.org; Amit Phansalkar
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq'

On Wed, Sep 18 2013, Akhil Bhansali wrote:
> Hi Jens,
>
> Please accept this patch that takes care of warnings related to i386 compilation.
> 1. Implicit function declaration of readq and writeq.
> 2. Format related warnings for VPRINTK.

You should get rid of the VPRINTK() as well, we do have debug facilities
in place you can use for printing.

And as mentioned a week or so ago, readq() isn't even used.

--
Jens Axboe


PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
