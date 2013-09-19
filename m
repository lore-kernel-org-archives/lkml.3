Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3ISMKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:10:50 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:40068 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753923Ab3ISMKs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:10:48 -0400
X-ASG-Debug-ID: 1379592643-053ea95890c7a30001-xx1T2L
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
Thread-Index: AQHOryuGetr1quWh0UWdC/r7zgDmkZnDouGK//+jooCACAdm4P//xoAAgAHuFHQ=
Date: Thu, 19 Sep 2013 12:09:43 +0000
Message-ID: <87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
 <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
 <52332E6B.9060405@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>,<20130918143616.GD28478@kernel.dk>
In-Reply-To: <20130918143616.GD28478@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.20.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1379592643
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140751
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
@@ -439,14 +435,10 @@ static inline void skd_reg_write64(struct skd_device *skdev, u64 val,
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
