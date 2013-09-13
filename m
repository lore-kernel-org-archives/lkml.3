Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3IMNrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:47:00 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:44523 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S933627Ab3IMNTh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:19:37 -0400
X-Greylist: delayed 1118 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2013 09:19:27 EDT
X-ASG-Debug-ID: 1379077245-053ea93f6395bb0001-xx1T2L
X-Barracuda-Envelope-From: abhansali@stec-inc.com
From: Akhil Bhansali <abhansali@stec-inc.com>
To: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>
CC: Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Jens Axboe <axboe@kernel.dk>, "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Topic: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
X-ASG-Orig-Subj: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Index: AQHOryuGetr1quWh0UWdC/r7zgDmkZnDouGK
Date: Fri, 13 Sep 2013 12:59:46 +0000
Message-ID: <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
In-Reply-To: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[172.30.8.22]
X-Barracuda-Start-Time: 1379077245
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140573
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch takes care of warnings related to
1. Implicit function declaration for readq / writeq.
2. Warnings related to -Wformat.

Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
--
diff -uprN -X linux-3.10.9/Documentation/dontdiff linux-3.10.9/drivers/block/skd_main.c linux-3.10.9.changes/drivers/block/skd_main.c
--- linux-3.10.9/drivers/block/skd_main.c	2013-09-13 18:14:19.505597630 +0530
+++ linux-3.10.9.changes/drivers/block/skd_main.c	2013-09-13 18:01:52.761561490 +0530
@@ -41,6 +49,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <asm-generic/unaligned.h>
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
 
 #include "skd_s1120.h"
 
@@ -4570,11 +4579,6 @@ static int skd_cons_skmsg(struct skd_dev
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
-		sizeof(struct skd_fitmsg_context),
-		skdev->num_fitmsg_context,
-		sizeof(struct skd_fitmsg_context) * skdev->num_fitmsg_context);
-
 	skdev->skmsg_table = kzalloc(sizeof(struct skd_fitmsg_context)
 				     *skdev->num_fitmsg_context, GFP_KERNEL);
 	if (skdev->skmsg_table == NULL) {
@@ -4601,6 +4605,7 @@ static int skd_cons_skmsg(struct skd_dev
 
 		skmsg->offset = (u32)((u64)skmsg->msg_buf &
 				      (~FIT_QCMD_BASE_ADDRESS_MASK));
+
 		skmsg->msg_buf += ~FIT_QCMD_BASE_ADDRESS_MASK;
 		skmsg->msg_buf = (u8 *)((u64)skmsg->msg_buf &
 				       FIT_QCMD_BASE_ADDRESS_MASK);
@@ -4624,11 +4629,6 @@ static int skd_cons_skreq(struct skd_dev
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
-		sizeof(struct skd_request_context),
-		skdev->num_req_context,
-		sizeof(struct skd_request_context) * skdev->num_req_context);
-
 	skdev->skreq_table = kzalloc(sizeof(struct skd_request_context)
 				     * skdev->num_req_context, GFP_KERNEL);
 	if (skdev->skreq_table == NULL) {
@@ -4636,10 +4636,6 @@ static int skd_cons_skreq(struct skd_dev
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
-		skdev->sgs_per_request, sizeof(struct scatterlist),
-		skdev->sgs_per_request * sizeof(struct scatterlist));
-
 	for (i = 0; i < skdev->num_req_context; i++) {
 		struct skd_request_context *skreq;
 
@@ -4681,11 +4677,6 @@ static int skd_cons_skspcl(struct skd_de
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
-		sizeof(struct skd_special_context),
-		skdev->n_special,
-		sizeof(struct skd_special_context) * skdev->n_special);
-
 	skdev->skspcl_table = kzalloc(sizeof(struct skd_special_context)
 				      * skdev->n_special, GFP_KERNEL);
 	if (skdev->skspcl_table == NULL) {
Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
________________________________________
From: kbuild test robot [fengguang.wu@intel.com]
Sent: Thursday, September 12, 2013 1:45 AM
To: Akhil Bhansali
Cc: Ramprasad Chinthekindi; Jens Axboe; kbuild-all@01.org
Subject: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq'

tree:   git://git.kernel.dk/linux-block.git for-next
head:   b497e021a24be0eeb3c1a4ad9b2a04275ab5edc0
commit: 09d54e6cf164a524a7d03703acff80974cb4f632 [5/6] Patch for pcie device driver from sTec Inc.
config: make ARCH=i386 allyesconfig

All error/warnings:

   drivers/block/skd_main.c: In function 'skd_reg_read64':
>> drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq' [-Werror=implicit-function-declaration]
      return readq(skdev->mem_map[1] + offset);
      ^
   drivers/block/skd_main.c: In function 'skd_reg_write64':
>> drivers/block/skd_main.c:455:3: error: implicit declaration of function 'writeq' [-Werror=implicit-function-declaration]
      writeq(val, skdev->mem_map[1] + offset);
      ^
   In file included from include/linux/kernel.h:13:0,
                    from drivers/block/skd_main.c:19:
   drivers/block/skd_main.c: In function 'skd_cons_skmsg':
>> drivers/block/skd_main.c:4584:17: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat=]
      sizeof(struct skd_fitmsg_context) * skdev->num_fitmsg_context);
                    ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4581:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
     ^
>> drivers/block/skd_main.c:4584:17: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
      sizeof(struct skd_fitmsg_context) * skdev->num_fitmsg_context);
                    ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4581:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
     ^
>> drivers/block/skd_main.c:4610:25: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      skmsg->offset = (u32)((u64)skmsg->msg_buf &
                            ^
>> drivers/block/skd_main.c:4613:27: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      skmsg->msg_buf = (u8 *)((u64)skmsg->msg_buf &
                              ^
>> drivers/block/skd_main.c:4613:20: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
      skmsg->msg_buf = (u8 *)((u64)skmsg->msg_buf &
                       ^
   In file included from include/linux/kernel.h:13:0,
                    from drivers/block/skd_main.c:19:
   drivers/block/skd_main.c: In function 'skd_cons_skreq':
>> drivers/block/skd_main.c:4638:17: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat=]
      sizeof(struct skd_request_context) * skdev->num_req_context);
                    ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4635:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
     ^
>> drivers/block/skd_main.c:4638:17: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
      sizeof(struct skd_request_context) * skdev->num_req_context);
                    ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4635:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "skreq_table kzalloc, struct %lu, count %u total %lu\n",
     ^
>> drivers/block/skd_main.c:4649:42: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Wformat=]
      skdev->sgs_per_request * sizeof(struct scatterlist));
                                             ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4647:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
     ^
>> drivers/block/skd_main.c:4649:42: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
      skdev->sgs_per_request * sizeof(struct scatterlist));
                                             ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4647:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %lu total %lu\n",
     ^
   drivers/block/skd_main.c: In function 'skd_cons_skspcl':
>> drivers/block/skd_main.c:4695:17: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat=]
      sizeof(struct skd_special_context) * skdev->n_special);
                    ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4692:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
     ^
>> drivers/block/skd_main.c:4695:17: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'unsigned int' [-Wformat=]
      sizeof(struct skd_special_context) * skdev->n_special);
                    ^
   include/linux/printk.h:216:33: note: in definition of macro 'pr_err'
     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
   drivers/block/skd_main.c:4692:2: note: in expansion of macro 'VPRINTK'
     VPRINTK(skdev, "skspcl_table kzalloc, struct %lu, count %u total %lu\n",
     ^
   cc1: some warnings being treated as errors

vim +/readq +441 drivers/block/skd_main.c

   435
   436  static inline u64 skd_reg_read64(struct skd_device *skdev, u32 offset)
   437  {
   438          u64 val;
   439
   440          if (likely(skdev->dbg_level < 2))
 > 441                  return readq(skdev->mem_map[1] + offset);
   442          else {
   443                  barrier();
   444                  val = readq(skdev->mem_map[1] + offset);
   445                  barrier();
   446                  VPRINTK(skdev, "offset %x = %016llx\n", offset, val);
   447                  return val;
   448          }
   449  }
   450
   451  static inline void skd_reg_write64(struct skd_device *skdev, u64 val,
   452                                     u32 offset)
   453  {
   454          if (likely(skdev->dbg_level < 2)) {
   455                  writeq(val, skdev->mem_map[1] + offset);
   456                  barrier();
   457                  readq(skdev->mem_map[1] + offset);
   458                  barrier();

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
