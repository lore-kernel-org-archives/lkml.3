Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaCCPHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:07:22 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54078 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaCCPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:07:14 -0500
MIME-Version: 1.0
Date: Mon, 3 Mar 2014 08:07:13 -0700
Message-ID: <CA+r1Zhifc2wyVoQ-PmdZngaU9JY5NgFQWuMF2HKFAqtYhN3x8g@mail.gmail.com>
Subject: randconfig build error with next-20140303, in drivers/mtd/ubi/block.c
From: Jim Davis <jim.epost@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dedekind1@gmail.com,
        dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org
Content-Type: multipart/mixed; boundary=089e0163434e829e3604f3b52470
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0163434e829e3604f3b52470
Content-Type: text/plain; charset=ISO-8859-1

Building with the attached random configuration file,

In file included from include/linux/kernel.h:13:0,
                 from /home/jim/linux/arch/x86/include/asm/percpu.h:44,
                 from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/mtd/ubi/block.c:38:
drivers/mtd/ubi/block.c: In function 'ubiblock_read_to_buf':
drivers/mtd/ubi/block.c:192:11: error: dereferencing pointer to incomplete type
    dev->gd->disk_name, ret);
           ^
include/linux/printk.h:220:33: note: in definition of macro 'pr_err'
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                 ^
drivers/mtd/ubi/block.c:191:3: note: in expansion of macro 'ubi_err'
   ubi_err("%s ubi_read error %d",
   ^
drivers/mtd/ubi/block.c: At top level:
drivers/mtd/ubi/block.c:231:61: warning: 'struct request' declared
inside parameter list [enabled by default]
 static int do_ubiblock_request(struct ubiblock *dev, struct request *req)
                                                             ^
drivers/mtd/ubi/block.c:231:61: warning: its scope is only this
definition or declaration, which is probably not what you want
[enabled by default]
drivers/mtd/ubi/block.c: In function 'do_ubiblock_request':
drivers/mtd/ubi/block.c:236:9: error: dereferencing pointer to incomplete type
  if (req->cmd_type != REQ_TYPE_FS)
         ^
drivers/mtd/ubi/block.c:236:23: error: 'REQ_TYPE_FS' undeclared (first
use in this function)
  if (req->cmd_type != REQ_TYPE_FS)
                       ^
drivers/mtd/ubi/block.c:236:23: note: each undeclared identifier is
reported only once for each function it appears in
drivers/mtd/ubi/block.c:239:2: error: implicit declaration of function
'blk_rq_pos' [-Werror=implicit-function-declaration]
  if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
  ^
drivers/mtd/ubi/block.c:239:2: error: implicit declaration of function
'blk_rq_cur_sectors' [-Werror=implicit-function-declaration]
drivers/mtd/ubi/block.c:240:6: error: implicit declaration of function
'get_capacity' [-Werror=implicit-function-declaration]
      get_capacity(req->rq_disk))
      ^
drivers/mtd/ubi/block.c:240:22: error: dereferencing pointer to incomplete type
      get_capacity(req->rq_disk))
                      ^
drivers/mtd/ubi/block.c:243:2: error: implicit declaration of function
'rq_data_dir' [-Werror=implicit-function-declaration]
  if (rq_data_dir(req) != READ)
  ^
drivers/mtd/ubi/block.c:247:2: error: implicit declaration of function
'blk_rq_cur_bytes' [-Werror=implicit-function-declaration]
  len = blk_rq_cur_bytes(req);
  ^
drivers/mtd/ubi/block.c:256:30: error: dereferencing pointer to incomplete type
  ret = ubiblock_read(dev, req->buffer, sec, len);
                              ^
drivers/mtd/ubi/block.c: In function 'ubiblock_do_work':
drivers/mtd/ubi/block.c:270:18: error: dereferencing pointer to incomplete type
  spin_lock_irq(rq->queue_lock);
                  ^
drivers/mtd/ubi/block.c:272:2: error: implicit declaration of function
'blk_fetch_request' [-Werror=implicit-function-declaration]
  req = blk_fetch_request(rq);
  ^
drivers/mtd/ubi/block.c:272:6: warning: assignment makes pointer from
integer without a cast [enabled by default]
  req = blk_fetch_request(rq);
      ^
drivers/mtd/ubi/block.c:275:21: error: dereferencing pointer to incomplete type
   spin_unlock_irq(rq->queue_lock);
                     ^
drivers/mtd/ubi/block.c:276:3: warning: passing argument 2 of
'do_ubiblock_request' from incompatible pointer type [enabled by
default]
   res = do_ubiblock_request(dev, req);
   ^
drivers/mtd/ubi/block.c:231:12: note: expected 'struct request *' but
argument is of type 'struct request *'
 static int do_ubiblock_request(struct ubiblock *dev, struct request *req)
            ^
drivers/mtd/ubi/block.c:277:19: error: dereferencing pointer to incomplete type
   spin_lock_irq(rq->queue_lock);
                   ^
drivers/mtd/ubi/block.c:283:3: error: implicit declaration of function
'__blk_end_request_cur' [-Werror=implicit-function-declaration]
   if (!__blk_end_request_cur(req, res))
   ^
drivers/mtd/ubi/block.c:284:8: warning: assignment makes pointer from
integer without a cast [enabled by default]
    req = blk_fetch_request(rq);
        ^
drivers/mtd/ubi/block.c:287:20: error: dereferencing pointer to incomplete type
  spin_unlock_irq(rq->queue_lock);
                    ^
drivers/mtd/ubi/block.c: In function 'ubiblock_request':
drivers/mtd/ubi/block.c:295:10: error: dereferencing pointer to incomplete type
  dev = rq->queuedata;
          ^
drivers/mtd/ubi/block.c:298:15: warning: assignment makes pointer from
integer without a cast [enabled by default]
   while ((req = blk_fetch_request(rq)) != NULL)
               ^
drivers/mtd/ubi/block.c:299:4: error: implicit declaration of function
'__blk_end_request_all' [-Werror=implicit-function-declaration]
    __blk_end_request_all(req, -ENODEV);
    ^
drivers/mtd/ubi/block.c: In function 'ubiblock_open':
drivers/mtd/ubi/block.c:306:38: error: dereferencing pointer to incomplete type
  struct ubiblock *dev = bdev->bd_disk->private_data;
                                      ^
In file included from include/linux/kernel.h:13:0,
                 from /home/jim/linux/arch/x86/include/asm/percpu.h:44,
                 from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/mtd/ubi/block.c:38:
drivers/mtd/ubi/block.c:331:11: error: dereferencing pointer to incomplete type
    dev->gd->disk_name, dev->ubi_num, dev->vol_id);
           ^
include/linux/printk.h:220:33: note: in definition of macro 'pr_err'
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
                                 ^
drivers/mtd/ubi/block.c:330:3: note: in expansion of macro 'ubi_err'
   ubi_err("%s failed to open ubi volume %d_%d",
   ^
drivers/mtd/ubi/block.c: In function 'ubiblock_release':
drivers/mtd/ubi/block.c:349:27: error: dereferencing pointer to incomplete type
  struct ubiblock *dev = gd->private_data;
                           ^
drivers/mtd/ubi/block.c: At top level:
drivers/mtd/ubi/block.c:370:21: error: variable 'ubiblock_ops' has
initializer but incomplete type
 static const struct block_device_operations ubiblock_ops = {
                     ^
drivers/mtd/ubi/block.c:371:2: error: unknown field 'owner' specified
in initializer
  .owner = THIS_MODULE,
  ^
In file included from include/linux/linkage.h:6:0,
                 from /home/jim/linux/arch/x86/include/asm/cache.h:4,
                 from include/linux/cache.h:5,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/mtd/ubi/block.c:38:
include/linux/export.h:36:30: warning: excess elements in struct
initializer [enabled by default]
 #define THIS_MODULE ((struct module *)0)
                              ^
drivers/mtd/ubi/block.c:371:11: note: in expansion of macro 'THIS_MODULE'
  .owner = THIS_MODULE,
           ^
include/linux/export.h:36:30: warning: (near initialization for
'ubiblock_ops') [enabled by default]
 #define THIS_MODULE ((struct module *)0)
                              ^
drivers/mtd/ubi/block.c:371:11: note: in expansion of macro 'THIS_MODULE'
  .owner = THIS_MODULE,
           ^
drivers/mtd/ubi/block.c:372:2: error: unknown field 'open' specified
in initializer
  .open = ubiblock_open,
  ^
drivers/mtd/ubi/block.c:372:2: warning: excess elements in struct
initializer [enabled by default]
drivers/mtd/ubi/block.c:372:2: warning: (near initialization for
'ubiblock_ops') [enabled by default]
drivers/mtd/ubi/block.c:373:2: error: unknown field 'release'
specified in initializer
  .release = ubiblock_release,
  ^
drivers/mtd/ubi/block.c:373:2: warning: excess elements in struct
initializer [enabled by default]
drivers/mtd/ubi/block.c:373:2: warning: (near initialization for
'ubiblock_ops') [enabled by default]
drivers/mtd/ubi/block.c:374:2: error: unknown field 'getgeo' specified
in initializer
  .getgeo = ubiblock_getgeo,
  ^
drivers/mtd/ubi/block.c:374:2: warning: excess elements in struct
initializer [enabled by default]
drivers/mtd/ubi/block.c:374:2: warning: (near initialization for
'ubiblock_ops') [enabled by default]
drivers/mtd/ubi/block.c: In function 'ubiblock_add':
drivers/mtd/ubi/block.c:403:2: error: implicit declaration of function
'alloc_disk' [-Werror=implicit-function-declaration]
  gd = alloc_disk(1);
  ^
drivers/mtd/ubi/block.c:403:5: warning: assignment makes pointer from
integer without a cast [enabled by default]
  gd = alloc_disk(1);
     ^
drivers/mtd/ubi/block.c:410:4: error: dereferencing pointer to incomplete type
  gd->fops = &ubiblock_ops;
    ^
drivers/mtd/ubi/block.c:411:4: error: dereferencing pointer to incomplete type
  gd->major = ubiblock_major;
    ^
drivers/mtd/ubi/block.c:412:4: error: dereferencing pointer to incomplete type
  gd->first_minor = dev->ubi_num * UBI_MAX_VOLUMES + dev->vol_id;
    ^
drivers/mtd/ubi/block.c:413:4: error: dereferencing pointer to incomplete type
  gd->private_data = dev;
    ^
drivers/mtd/ubi/block.c:414:12: error: dereferencing pointer to incomplete type
  sprintf(gd->disk_name, "ubiblock%d_%d", dev->ubi_num, dev->vol_id);
            ^
drivers/mtd/ubi/block.c:416:2: error: implicit declaration of function
'set_capacity' [-Werror=implicit-function-declaration]
  set_capacity(gd, disk_capacity);
  ^
drivers/mtd/ubi/block.c:420:2: error: implicit declaration of function
'blk_init_queue' [-Werror=implicit-function-declaration]
  dev->rq = blk_init_queue(ubiblock_request, &dev->queue_lock);
  ^
drivers/mtd/ubi/block.c:420:10: warning: assignment makes pointer from
integer without a cast [enabled by default]
  dev->rq = blk_init_queue(ubiblock_request, &dev->queue_lock);
          ^
drivers/mtd/ubi/block.c:427:9: error: dereferencing pointer to incomplete type
  dev->rq->queuedata = dev;
         ^
drivers/mtd/ubi/block.c:428:9: error: dereferencing pointer to incomplete type
  dev->gd->queue = dev->rq;
         ^
In file included from include/linux/srcu.h:34:0,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:806,
                 from include/linux/gfp.h:5,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from drivers/mtd/ubi/block.c:38:
drivers/mtd/ubi/block.c:434:30: error: dereferencing pointer to incomplete type
  dev->wq = alloc_workqueue(gd->disk_name, 0, 0);
                              ^
include/linux/workqueue.h:424:25: note: in definition of macro 'alloc_workqueue'
  __alloc_workqueue_key((fmt), (flags), (max_active),  \
                         ^
drivers/mtd/ubi/block.c:444:2: error: implicit declaration of function
'add_disk' [-Werror=implicit-function-declaration]
  add_disk(dev->gd);
  ^
In file included from include/linux/kernel.h:13:0,
                 from /home/jim/linux/arch/x86/include/asm/percpu.h:44,
                 from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/mtd/ubi/block.c:38:
drivers/mtd/ubi/block.c:446:10: error: dereferencing pointer to incomplete type
   dev->gd->disk_name, dev->ubi_num, dev->vol_id, vi->name);
          ^
include/linux/printk.h:225:36: note: in definition of macro 'pr_notice'
  printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
drivers/mtd/ubi/block.c:445:2: note: in expansion of macro 'ubi_msg'
  ubi_msg("%s created from ubi%d:%d(%s)",
  ^
drivers/mtd/ubi/block.c:450:2: error: implicit declaration of function
'blk_cleanup_queue' [-Werror=implicit-function-declaration]
  blk_cleanup_queue(dev->rq);
  ^
drivers/mtd/ubi/block.c:452:2: error: implicit declaration of function
'put_disk' [-Werror=implicit-function-declaration]
  put_disk(dev->gd);
  ^
drivers/mtd/ubi/block.c: In function 'ubiblock_cleanup':
drivers/mtd/ubi/block.c:461:2: error: implicit declaration of function
'del_gendisk' [-Werror=implicit-function-declaration]
  del_gendisk(dev->gd);
  ^
In file included from include/linux/kernel.h:13:0,
                 from /home/jim/linux/arch/x86/include/asm/percpu.h:44,
                 from /home/jim/linux/arch/x86/include/asm/preempt.h:5,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/mtd/ubi/block.c:38:
drivers/mtd/ubi/block.c:463:32: error: dereferencing pointer to incomplete type
  ubi_msg("%s released", dev->gd->disk_name);
                                ^
include/linux/printk.h:225:36: note: in definition of macro 'pr_notice'
  printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
drivers/mtd/ubi/block.c:463:2: note: in expansion of macro 'ubi_msg'
  ubi_msg("%s released", dev->gd->disk_name);
  ^
drivers/mtd/ubi/block.c: In function 'ubiblock_resize':
drivers/mtd/ubi/block.c:518:42: error: dereferencing pointer to incomplete type
  ubi_msg("%s resized to %d LEBs", dev->gd->disk_name, vi->size);
                                          ^
include/linux/printk.h:225:36: note: in definition of macro 'pr_notice'
  printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
                                    ^
drivers/mtd/ubi/block.c:518:2: note: in expansion of macro 'ubi_msg'
  ubi_msg("%s resized to %d LEBs", dev->gd->disk_name, vi->size);
  ^
drivers/mtd/ubi/block.c: In function 'ubiblock_init':
drivers/mtd/ubi/block.c:616:2: error: implicit declaration of function
'register_blkdev' [-Werror=implicit-function-declaration]
  ubiblock_major = register_blkdev(0, "ubiblock");
  ^
drivers/mtd/ubi/block.c:635:2: error: implicit declaration of function
'unregister_blkdev' [-Werror=implicit-function-declaration]
  unregister_blkdev(ubiblock_major, "ubiblock");
  ^
cc1: some warnings being treated as errors
make[3]: *** [drivers/mtd/ubi/block.o] Error 1

--089e0163434e829e3604f3b52470
Content-Type: text/plain; charset=US-ASCII; name="randconfig-1393844332.txt"
Content-Disposition: attachment; filename="randconfig-1393844332.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4L3g4
NiAzLjE0LjAtcmM0IEtlcm5lbCBDb25maWd1cmF0aW9uCiMKIyBDT05GSUdfNjRCSVQgaXMgbm90
IHNldApDT05GSUdfWDg2XzMyPXkKQ09ORklHX1g4Nj15CkNPTkZJR19JTlNUUlVDVElPTl9ERUNP
REVSPXkKQ09ORklHX09VVFBVVF9GT1JNQVQ9ImVsZjMyLWkzODYiCkNPTkZJR19BUkNIX0RFRkNP
TkZJRz0iYXJjaC94ODYvY29uZmlncy9pMzg2X2RlZmNvbmZpZyIKQ09ORklHX0xPQ0tERVBfU1VQ
UE9SVD15CkNPTkZJR19TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9MQVRFTkNZVE9Q
X1NVUFBPUlQ9eQpDT05GSUdfTU1VPXkKQ09ORklHX05FRURfRE1BX01BUF9TVEFURT15CkNPTkZJ
R19ORUVEX1NHX0RNQV9MRU5HVEg9eQpDT05GSUdfR0VORVJJQ19JU0FfRE1BPXkKQ09ORklHX0dF
TkVSSUNfQlVHPXkKQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15CkNPTkZJR19BUkNIX01BWV9IQVZF
X1BDX0ZEQz15CkNPTkZJR19SV1NFTV9YQ0hHQUREX0FMR09SSVRITT15CkNPTkZJR19HRU5FUklD
X0NBTElCUkFURV9ERUxBWT15CkNPTkZJR19BUkNIX0hBU19DUFVfUkVMQVg9eQpDT05GSUdfQVJD
SF9IQVNfQ0FDSEVfTElORV9TSVpFPXkKQ09ORklHX0hBVkVfU0VUVVBfUEVSX0NQVV9BUkVBPXkK
Q09ORklHX05FRURfUEVSX0NQVV9FTUJFRF9GSVJTVF9DSFVOSz15CkNPTkZJR19ORUVEX1BFUl9D
UFVfUEFHRV9GSVJTVF9DSFVOSz15CkNPTkZJR19BUkNIX0hJQkVSTkFUSU9OX1BPU1NJQkxFPXkK
Q09ORklHX0FSQ0hfU1VTUEVORF9QT1NTSUJMRT15CkNPTkZJR19BUkNIX1dBTlRfSFVHRV9QTURf
U0hBUkU9eQpDT05GSUdfQVJDSF9XQU5UX0dFTkVSQUxfSFVHRVRMQj15CiMgQ09ORklHX1pPTkVf
RE1BMzIgaXMgbm90IHNldAojIENPTkZJR19BVURJVF9BUkNIIGlzIG5vdCBzZXQKQ09ORklHX0FS
Q0hfU1VQUE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfREVC
VUdfUEFHRUFMTE9DPXkKQ09ORklHX1g4Nl8zMl9MQVpZX0dTPXkKQ09ORklHX0FSQ0hfSFdFSUdI
VF9DRkxBR1M9Ii1mY2FsbC1zYXZlZC1lY3ggLWZjYWxsLXNhdmVkLWVkeCIKQ09ORklHX0FSQ0hf
U1VQUE9SVFNfVVBST0JFUz15CkNPTkZJR19ERUZDT05GSUdfTElTVD0iL2xpYi9tb2R1bGVzLyRV
TkFNRV9SRUxFQVNFLy5jb25maWciCkNPTkZJR19DT05TVFJVQ1RPUlM9eQpDT05GSUdfSVJRX1dP
Uks9eQpDT05GSUdfQlVJTERUSU1FX0VYVEFCTEVfU09SVD15CgojCiMgR2VuZXJhbCBzZXR1cAoj
CkNPTkZJR19CUk9LRU5fT05fU01QPXkKQ09ORklHX0lOSVRfRU5WX0FSR19MSU1JVD0zMgpDT05G
SUdfQ1JPU1NfQ09NUElMRT0iIgpDT05GSUdfQ09NUElMRV9URVNUPXkKQ09ORklHX0xPQ0FMVkVS
U0lPTj0iIgpDT05GSUdfTE9DQUxWRVJTSU9OX0FVVE89eQpDT05GSUdfSEFWRV9LRVJORUxfR1pJ
UD15CkNPTkZJR19IQVZFX0tFUk5FTF9CWklQMj15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk1BPXkK
Q09ORklHX0hBVkVfS0VSTkVMX1haPXkKQ09ORklHX0hBVkVfS0VSTkVMX0xaTz15CkNPTkZJR19I
QVZFX0tFUk5FTF9MWjQ9eQpDT05GSUdfS0VSTkVMX0daSVA9eQojIENPTkZJR19LRVJORUxfQlpJ
UDIgaXMgbm90IHNldAojIENPTkZJR19LRVJORUxfTFpNQSBpcyBub3Qgc2V0CiMgQ09ORklHX0tF
Uk5FTF9YWiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9MWk8gaXMgbm90IHNldAojIENPTkZJ
R19LRVJORUxfTFo0IGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSE9TVE5BTUU9Iihub25lKSIK
IyBDT05GSUdfU1lTVklQQyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZIQU5ETEUgaXMgbm90IHNldApD
T05GSUdfVVNFTElCPXkKCiMKIyBJUlEgc3Vic3lzdGVtCiMKQ09ORklHX0dFTkVSSUNfSVJRX1BS
T0JFPXkKQ09ORklHX0dFTkVSSUNfSVJRX1NIT1c9eQpDT05GSUdfSVJRX0RPTUFJTj15CiMgQ09O
RklHX0lSUV9ET01BSU5fREVCVUcgaXMgbm90IHNldApDT05GSUdfSVJRX0ZPUkNFRF9USFJFQURJ
Tkc9eQpDT05GSUdfU1BBUlNFX0lSUT15CkNPTkZJR19DTE9DS1NPVVJDRV9XQVRDSERPRz15CkNP
TkZJR19LVElNRV9TQ0FMQVI9eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJR19H
RU5FUklDX0NMT0NLRVZFTlRTX0JVSUxEPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfQlJP
QURDQVNUPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfTUlOX0FESlVTVD15CkNPTkZJR19H
RU5FUklDX0NNT1NfVVBEQVRFPXkKCiMKIyBUaW1lcnMgc3Vic3lzdGVtCiMKQ09ORklHX1RJQ0tf
T05FU0hPVD15CkNPTkZJR19OT19IWl9DT01NT049eQojIENPTkZJR19IWl9QRVJJT0RJQyBpcyBu
b3Qgc2V0CkNPTkZJR19OT19IWl9JRExFPXkKQ09ORklHX05PX0haPXkKIyBDT05GSUdfSElHSF9S
RVNfVElNRVJTIGlzIG5vdCBzZXQKCiMKIyBDUFUvVGFzayB0aW1lIGFuZCBzdGF0cyBhY2NvdW50
aW5nCiMKQ09ORklHX1RJQ0tfQ1BVX0FDQ09VTlRJTkc9eQojIENPTkZJR19JUlFfVElNRV9BQ0NP
VU5USU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfQlNEX1BST0NFU1NfQUNDVCBpcyBub3Qgc2V0Cgoj
CiMgUkNVIFN1YnN5c3RlbQojCkNPTkZJR19USU5ZX1JDVT15CiMgQ09ORklHX1BSRUVNUFRfUkNV
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1NUQUxMX0NPTU1PTiBpcyBub3Qgc2V0CiMgQ09ORklH
X1RSRUVfUkNVX1RSQUNFIGlzIG5vdCBzZXQKQ09ORklHX0lLQ09ORklHPXkKQ09ORklHX0xPR19C
VUZfU0hJRlQ9MTcKQ09ORklHX0hBVkVfVU5TVEFCTEVfU0NIRURfQ0xPQ0s9eQpDT05GSUdfQVJD
SF9TVVBQT1JUU19OVU1BX0JBTEFOQ0lORz15CkNPTkZJR19BUkNIX1dBTlRTX1BST1RfTlVNQV9Q
Uk9UX05PTkU9eQpDT05GSUdfQ0dST1VQUz15CkNPTkZJR19DR1JPVVBfREVCVUc9eQojIENPTkZJ
R19DR1JPVVBfRlJFRVpFUiBpcyBub3Qgc2V0CkNPTkZJR19DR1JPVVBfREVWSUNFPXkKIyBDT05G
SUdfQ1BVU0VUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NHUk9VUF9DUFVBQ0NUIGlzIG5vdCBzZXQK
IyBDT05GSUdfUkVTT1VSQ0VfQ09VTlRFUlMgaXMgbm90IHNldAojIENPTkZJR19DR1JPVVBfUEVS
RiBpcyBub3Qgc2V0CkNPTkZJR19DR1JPVVBfU0NIRUQ9eQpDT05GSUdfRkFJUl9HUk9VUF9TQ0hF
RD15CkNPTkZJR19DRlNfQkFORFdJRFRIPXkKIyBDT05GSUdfUlRfR1JPVVBfU0NIRUQgaXMgbm90
IHNldAojIENPTkZJR19DSEVDS1BPSU5UX1JFU1RPUkUgaXMgbm90IHNldAojIENPTkZJR19OQU1F
U1BBQ0VTIGlzIG5vdCBzZXQKQ09ORklHX1NDSEVEX0FVVE9HUk9VUD15CkNPTkZJR19TWVNGU19E
RVBSRUNBVEVEPXkKIyBDT05GSUdfU1lTRlNfREVQUkVDQVRFRF9WMiBpcyBub3Qgc2V0CiMgQ09O
RklHX1JFTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9JTklUUkQgaXMgbm90IHNldAoj
IENPTkZJR19DQ19PUFRJTUlaRV9GT1JfU0laRSBpcyBub3Qgc2V0CkNPTkZJR19BTk9OX0lOT0RF
Uz15CkNPTkZJR19IQVZFX1VJRDE2PXkKQ09ORklHX1NZU0NUTF9FWENFUFRJT05fVFJBQ0U9eQpD
T05GSUdfSEFWRV9QQ1NQS1JfUExBVEZPUk09eQpDT05GSUdfRVhQRVJUPXkKIyBDT05GSUdfVUlE
MTYgaXMgbm90IHNldApDT05GSUdfU1lTRlNfU1lTQ0FMTD15CkNPTkZJR19LQUxMU1lNUz15CkNP
TkZJR19LQUxMU1lNU19BTEw9eQojIENPTkZJR19QUklOVEsgaXMgbm90IHNldApDT05GSUdfQlVH
PXkKIyBDT05GSUdfUENTUEtSX1BMQVRGT1JNIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFTRV9GVUxM
IGlzIG5vdCBzZXQKQ09ORklHX0ZVVEVYPXkKQ09ORklHX0VQT0xMPXkKIyBDT05GSUdfU0lHTkFM
RkQgaXMgbm90IHNldApDT05GSUdfVElNRVJGRD15CkNPTkZJR19FVkVOVEZEPXkKQ09ORklHX1NI
TUVNPXkKIyBDT05GSUdfQUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfRU1CRURERUQgaXMgbm90IHNl
dApDT05GSUdfSEFWRV9QRVJGX0VWRU5UUz15CkNPTkZJR19QRVJGX1VTRV9WTUFMTE9DPXkKCiMK
IyBLZXJuZWwgUGVyZm9ybWFuY2UgRXZlbnRzIEFuZCBDb3VudGVycwojCkNPTkZJR19QRVJGX0VW
RU5UUz15CkNPTkZJR19ERUJVR19QRVJGX1VTRV9WTUFMTE9DPXkKIyBDT05GSUdfVk1fRVZFTlRf
Q09VTlRFUlMgaXMgbm90IHNldAojIENPTkZJR19TTFVCX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklH
X0NPTVBBVF9CUks9eQojIENPTkZJR19TTEFCIGlzIG5vdCBzZXQKQ09ORklHX1NMVUI9eQojIENP
TkZJR19TTE9CIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPRklMSU5HIGlzIG5vdCBzZXQKQ09ORklH
X0hBVkVfT1BST0ZJTEU9eQpDT05GSUdfT1BST0ZJTEVfTk1JX1RJTUVSPXkKQ09ORklHX0pVTVBf
TEFCRUw9eQojIENPTkZJR19IQVZFXzY0QklUX0FMSUdORURfQUNDRVNTIGlzIG5vdCBzZXQKQ09O
RklHX0hBVkVfRUZGSUNJRU5UX1VOQUxJR05FRF9BQ0NFU1M9eQpDT05GSUdfQVJDSF9VU0VfQlVJ
TFRJTl9CU1dBUD15CkNPTkZJR19IQVZFX0lPUkVNQVBfUFJPVD15CkNPTkZJR19IQVZFX0tQUk9C
RVM9eQpDT05GSUdfSEFWRV9LUkVUUFJPQkVTPXkKQ09ORklHX0hBVkVfT1BUUFJPQkVTPXkKQ09O
RklHX0hBVkVfS1BST0JFU19PTl9GVFJBQ0U9eQpDT05GSUdfSEFWRV9BUkNIX1RSQUNFSE9PSz15
CkNPTkZJR19IQVZFX0RNQV9BVFRSUz15CkNPTkZJR19IQVZFX0RNQV9DT05USUdVT1VTPXkKQ09O
RklHX0dFTkVSSUNfU01QX0lETEVfVEhSRUFEPXkKQ09ORklHX0hBVkVfUkVHU19BTkRfU1RBQ0tf
QUNDRVNTX0FQST15CkNPTkZJR19IQVZFX0RNQV9BUElfREVCVUc9eQpDT05GSUdfSEFWRV9IV19C
UkVBS1BPSU5UPXkKQ09ORklHX0hBVkVfTUlYRURfQlJFQUtQT0lOVFNfUkVHUz15CkNPTkZJR19I
QVZFX1VTRVJfUkVUVVJOX05PVElGSUVSPXkKQ09ORklHX0hBVkVfUEVSRl9FVkVOVFNfTk1JPXkK
Q09ORklHX0hBVkVfUEVSRl9SRUdTPXkKQ09ORklHX0hBVkVfUEVSRl9VU0VSX1NUQUNLX0RVTVA9
eQpDT05GSUdfSEFWRV9BUkNIX0pVTVBfTEFCRUw9eQpDT05GSUdfQVJDSF9IQVZFX05NSV9TQUZF
X0NNUFhDSEc9eQpDT05GSUdfSEFWRV9BTElHTkVEX1NUUlVDVF9QQUdFPXkKQ09ORklHX0hBVkVf
Q01QWENIR19MT0NBTD15CkNPTkZJR19IQVZFX0NNUFhDSEdfRE9VQkxFPXkKQ09ORklHX0FSQ0hf
V0FOVF9JUENfUEFSU0VfVkVSU0lPTj15CkNPTkZJR19IQVZFX0FSQ0hfU0VDQ09NUF9GSUxURVI9
eQpDT05GSUdfSEFWRV9DQ19TVEFDS1BST1RFQ1RPUj15CiMgQ09ORklHX0NDX1NUQUNLUFJPVEVD
VE9SIGlzIG5vdCBzZXQKQ09ORklHX0NDX1NUQUNLUFJPVEVDVE9SX05PTkU9eQojIENPTkZJR19D
Q19TVEFDS1BST1RFQ1RPUl9SRUdVTEFSIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0NfU1RBQ0tQUk9U
RUNUT1JfU1RST05HIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfSVJRX1RJTUVfQUNDT1VOVElORz15
CkNPTkZJR19IQVZFX0FSQ0hfVFJBTlNQQVJFTlRfSFVHRVBBR0U9eQpDT05GSUdfSEFWRV9BUkNI
X1NPRlRfRElSVFk9eQpDT05GSUdfTU9EVUxFU19VU0VfRUxGX1JFTD15CkNPTkZJR19DTE9ORV9C
QUNLV0FSRFM9eQpDT05GSUdfT0xEX1NJR1NVU1BFTkQzPXkKQ09ORklHX09MRF9TSUdBQ1RJT049
eQoKIwojIEdDT1YtYmFzZWQga2VybmVsIHByb2ZpbGluZwojCkNPTkZJR19HQ09WX0tFUk5FTD15
CkNPTkZJR19HQ09WX1BST0ZJTEVfQUxMPXkKQ09ORklHX0dDT1ZfRk9STUFUX0FVVE9ERVRFQ1Q9
eQojIENPTkZJR19HQ09WX0ZPUk1BVF8zXzQgaXMgbm90IHNldAojIENPTkZJR19HQ09WX0ZPUk1B
VF80XzcgaXMgbm90IHNldApDT05GSUdfSEFWRV9HRU5FUklDX0RNQV9DT0hFUkVOVD15CkNPTkZJ
R19SVF9NVVRFWEVTPXkKQ09ORklHX0JBU0VfU01BTEw9MQojIENPTkZJR19NT0RVTEVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkxPQ0sgaXMgbm90IHNldApDT05GSUdfVU5JTkxJTkVfU1BJTl9VTkxP
Q0s9eQojIENPTkZJR19GUkVFWkVSIGlzIG5vdCBzZXQKCiMKIyBQcm9jZXNzb3IgdHlwZSBhbmQg
ZmVhdHVyZXMKIwojIENPTkZJR19aT05FX0RNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NNUCBpcyBu
b3Qgc2V0CkNPTkZJR19YODZfTVBQQVJTRT15CkNPTkZJR19HT0xERklTSD15CkNPTkZJR19YODZf
RVhURU5ERURfUExBVEZPUk09eQpDT05GSUdfWDg2X0dPTERGSVNIPXkKQ09ORklHX1g4Nl9SREMz
MjFYPXkKQ09ORklHX1g4Nl8zMl9JUklTPXkKIyBDT05GSUdfU0NIRURfT01JVF9GUkFNRV9QT0lO
VEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSFlQRVJWSVNPUl9HVUVTVCBpcyBub3Qgc2V0CkNPTkZJ
R19OT19CT09UTUVNPXkKQ09ORklHX01FTVRFU1Q9eQojIENPTkZJR19NNDg2IGlzIG5vdCBzZXQK
IyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZUU0MgaXMgbm90IHNldAojIENP
TkZJR19NNTg2TU1YIGlzIG5vdCBzZXQKQ09ORklHX002ODY9eQojIENPTkZJR19NUEVOVElVTUlJ
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVBFTlRJVU1JSUkgaXMgbm90IHNldAojIENPTkZJR19NUEVO
VElVTU0gaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTTQgaXMgbm90IHNldAojIENPTkZJR19N
SzYgaXMgbm90IHNldAojIENPTkZJR19NSzcgaXMgbm90IHNldAojIENPTkZJR19NSzggaXMgbm90
IHNldAojIENPTkZJR19NQ1JVU09FIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVGRklDRU9OIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVdJTkNISVBDNiBpcyBub3Qgc2V0CiMgQ09ORklHX01XSU5DSElQM0Qg
aXMgbm90IHNldAojIENPTkZJR19NRUxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9ERUdYMSBp
cyBub3Qgc2V0CiMgQ09ORklHX01HRU9ERV9MWCBpcyBub3Qgc2V0CiMgQ09ORklHX01DWVJJWElJ
SSBpcyBub3Qgc2V0CiMgQ09ORklHX01WSUFDM18yIGlzIG5vdCBzZXQKIyBDT05GSUdfTVZJQUM3
IGlzIG5vdCBzZXQKIyBDT05GSUdfTUNPUkUyIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFUT00gaXMg
bm90IHNldAojIENPTkZJR19YODZfR0VORVJJQyBpcyBub3Qgc2V0CkNPTkZJR19YODZfSU5URVJO
T0RFX0NBQ0hFX1NISUZUPTUKQ09ORklHX1g4Nl9MMV9DQUNIRV9TSElGVD01CkNPTkZJR19YODZf
UFBST19GRU5DRT15CkNPTkZJR19YODZfVVNFX1BQUk9fQ0hFQ0tTVU09eQpDT05GSUdfWDg2X1RT
Qz15CkNPTkZJR19YODZfQ01QWENIRzY0PXkKQ09ORklHX1g4Nl9DTU9WPXkKQ09ORklHX1g4Nl9N
SU5JTVVNX0NQVV9GQU1JTFk9NQpDT05GSUdfWDg2X0RFQlVHQ1RMTVNSPXkKQ09ORklHX1BST0NF
U1NPUl9TRUxFQ1Q9eQojIENPTkZJR19DUFVfU1VQX0lOVEVMIGlzIG5vdCBzZXQKQ09ORklHX0NQ
VV9TVVBfQ1lSSVhfMzI9eQpDT05GSUdfQ1BVX1NVUF9BTUQ9eQojIENPTkZJR19DUFVfU1VQX0NF
TlRBVVIgaXMgbm90IHNldApDT05GSUdfQ1BVX1NVUF9UUkFOU01FVEFfMzI9eQpDT05GSUdfQ1BV
X1NVUF9VTUNfMzI9eQojIENPTkZJR19IUEVUX1RJTUVSIGlzIG5vdCBzZXQKQ09ORklHX0RNST15
CkNPTkZJR19OUl9DUFVTPTEKQ09ORklHX1BSRUVNUFRfTk9ORT15CiMgQ09ORklHX1BSRUVNUFRf
Vk9MVU5UQVJZIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVCBpcyBub3Qgc2V0CkNPTkZJR19Q
UkVFTVBUX0NPVU5UPXkKQ09ORklHX1g4Nl9VUF9BUElDPXkKIyBDT05GSUdfWDg2X1VQX0lPQVBJ
QyBpcyBub3Qgc2V0CkNPTkZJR19YODZfTE9DQUxfQVBJQz15CiMgQ09ORklHX1g4Nl9NQ0UgaXMg
bm90IHNldAojIENPTkZJR19WTTg2IGlzIG5vdCBzZXQKQ09ORklHX1RPU0hJQkE9eQpDT05GSUdf
SThLPXkKQ09ORklHX1g4Nl9SRUJPT1RGSVhVUFM9eQojIENPTkZJR19NSUNST0NPREUgaXMgbm90
IHNldAojIENPTkZJR19NSUNST0NPREVfSU5URUxfRUFSTFkgaXMgbm90IHNldAojIENPTkZJR19N
SUNST0NPREVfQU1EX0VBUkxZIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9NU1I9eQojIENPTkZJR19Y
ODZfQ1BVSUQgaXMgbm90IHNldAojIENPTkZJR19OT0hJR0hNRU0gaXMgbm90IHNldApDT05GSUdf
SElHSE1FTTRHPXkKIyBDT05GSUdfSElHSE1FTTY0RyBpcyBub3Qgc2V0CkNPTkZJR19WTVNQTElU
XzNHPXkKIyBDT05GSUdfVk1TUExJVF8zR19PUFQgaXMgbm90IHNldAojIENPTkZJR19WTVNQTElU
XzJHIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1TUExJVF8yR19PUFQgaXMgbm90IHNldAojIENPTkZJ
R19WTVNQTElUXzFHIGlzIG5vdCBzZXQKQ09ORklHX1BBR0VfT0ZGU0VUPTB4QzAwMDAwMDAKQ09O
RklHX0hJR0hNRU09eQpDT05GSUdfQVJDSF9GTEFUTUVNX0VOQUJMRT15CkNPTkZJR19BUkNIX1NQ
QVJTRU1FTV9FTkFCTEU9eQpDT05GSUdfQVJDSF9TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09ORklH
X0lMTEVHQUxfUE9JTlRFUl9WQUxVRT0wCkNPTkZJR19TRUxFQ1RfTUVNT1JZX01PREVMPXkKQ09O
RklHX0ZMQVRNRU1fTUFOVUFMPXkKIyBDT05GSUdfU1BBUlNFTUVNX01BTlVBTCBpcyBub3Qgc2V0
CkNPTkZJR19GTEFUTUVNPXkKQ09ORklHX0ZMQVRfTk9ERV9NRU1fTUFQPXkKQ09ORklHX1NQQVJT
RU1FTV9TVEFUSUM9eQpDT05GSUdfSEFWRV9NRU1CTE9DSz15CkNPTkZJR19IQVZFX01FTUJMT0NL
X05PREVfTUFQPXkKQ09ORklHX0FSQ0hfRElTQ0FSRF9NRU1CTE9DSz15CiMgQ09ORklHX0hBVkVf
Qk9PVE1FTV9JTkZPX05PREUgaXMgbm90IHNldApDT05GSUdfUEFHRUZMQUdTX0VYVEVOREVEPXkK
Q09ORklHX1NQTElUX1BUTE9DS19DUFVTPTQKQ09ORklHX0JBTExPT05fQ09NUEFDVElPTj15CkNP
TkZJR19DT01QQUNUSU9OPXkKQ09ORklHX01JR1JBVElPTj15CiMgQ09ORklHX1BIWVNfQUREUl9U
XzY0QklUIGlzIG5vdCBzZXQKQ09ORklHX1pPTkVfRE1BX0ZMQUc9MApDT05GSUdfVklSVF9UT19C
VVM9eQojIENPTkZJR19LU00gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9NTUFQX01JTl9BRERS
PTQwOTYKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0UgaXMgbm90IHNldAojIENPTkZJR19D
Uk9TU19NRU1PUllfQVRUQUNIIGlzIG5vdCBzZXQKQ09ORklHX05FRURfUEVSX0NQVV9LTT15CkNP
TkZJR19DTEVBTkNBQ0hFPXkKIyBDT05GSUdfQ01BIGlzIG5vdCBzZXQKIyBDT05GSUdfWkJVRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1pTTUFMTE9DIGlzIG5vdCBzZXQKQ09ORklHX0hJR0hQVEU9eQpD
T05GSUdfWDg2X0NIRUNLX0JJT1NfQ09SUlVQVElPTj15CiMgQ09ORklHX1g4Nl9CT09UUEFSQU1f
TUVNT1JZX0NPUlJVUFRJT05fQ0hFQ0sgaXMgbm90IHNldApDT05GSUdfWDg2X1JFU0VSVkVfTE9X
PTY0CkNPTkZJR19NQVRIX0VNVUxBVElPTj15CkNPTkZJR19NVFJSPXkKIyBDT05GSUdfTVRSUl9T
QU5JVElaRVIgaXMgbm90IHNldApDT05GSUdfWDg2X1BBVD15CkNPTkZJR19BUkNIX1VTRVNfUEdf
VU5DQUNIRUQ9eQpDT05GSUdfQVJDSF9SQU5ET009eQpDT05GSUdfWDg2X1NNQVA9eQpDT05GSUdf
U0VDQ09NUD15CiMgQ09ORklHX0haXzEwMCBpcyBub3Qgc2V0CkNPTkZJR19IWl8yNTA9eQojIENP
TkZJR19IWl8zMDAgaXMgbm90IHNldAojIENPTkZJR19IWl8xMDAwIGlzIG5vdCBzZXQKQ09ORklH
X0haPTI1MAojIENPTkZJR19TQ0hFRF9IUlRJQ0sgaXMgbm90IHNldAojIENPTkZJR19LRVhFQyBp
cyBub3Qgc2V0CkNPTkZJR19DUkFTSF9EVU1QPXkKQ09ORklHX1BIWVNJQ0FMX1NUQVJUPTB4MTAw
MDAwMAojIENPTkZJR19SRUxPQ0FUQUJMRSBpcyBub3Qgc2V0CkNPTkZJR19QSFlTSUNBTF9BTElH
Tj0weDIwMDAwMAojIENPTkZJR19DT01QQVRfVkRTTyBpcyBub3Qgc2V0CkNPTkZJR19DTURMSU5F
X0JPT0w9eQpDT05GSUdfQ01ETElORT0iIgpDT05GSUdfQ01ETElORV9PVkVSUklERT15CkNPTkZJ
R19BUkNIX0VOQUJMRV9NRU1PUllfSE9UUExVRz15CgojCiMgUG93ZXIgbWFuYWdlbWVudCBhbmQg
QUNQSSBvcHRpb25zCiMKIyBDT05GSUdfU1VTUEVORCBpcyBub3Qgc2V0CkNPTkZJR19QTV9SVU5U
SU1FPXkKQ09ORklHX1BNPXkKIyBDT05GSUdfUE1fREVCVUcgaXMgbm90IHNldApDT05GSUdfV1Ff
UE9XRVJfRUZGSUNJRU5UX0RFRkFVTFQ9eQojIENPTkZJR19TRkkgaXMgbm90IHNldAoKIwojIENQ
VSBGcmVxdWVuY3kgc2NhbGluZwojCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQKCiMKIyBD
UFUgSWRsZQojCkNPTkZJR19DUFVfSURMRT15CiMgQ09ORklHX0NQVV9JRExFX01VTFRJUExFX0RS
SVZFUlMgaXMgbm90IHNldAojIENPTkZJR19DUFVfSURMRV9HT1ZfTEFEREVSIGlzIG5vdCBzZXQK
Q09ORklHX0NQVV9JRExFX0dPVl9NRU5VPXkKIyBDT05GSUdfQVJDSF9ORUVEU19DUFVfSURMRV9D
T1VQTEVEIGlzIG5vdCBzZXQKCiMKIyBCdXMgb3B0aW9ucyAoUENJIGV0Yy4pCiMKIyBDT05GSUdf
UENJIGlzIG5vdCBzZXQKQ09ORklHX1BDSV9MQUJFTD15CkNPTkZJR19JU0FfRE1BX0FQST15CkNP
TkZJR19JU0E9eQojIENPTkZJR19FSVNBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0N4MjAwIGlzIG5v
dCBzZXQKIyBDT05GSUdfT0xQQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FMSVggaXMgbm90IHNldApD
T05GSUdfTkVUNTUwMT15CiMgQ09ORklHX0dFT1MgaXMgbm90IHNldApDT05GSUdfUENDQVJEPXkK
IyBDT05GSUdfUENNQ0lBIGlzIG5vdCBzZXQKCiMKIyBQQy1jYXJkIGJyaWRnZXMKIwpDT05GSUdf
UENNQ0lBX1BST0JFPXkKQ09ORklHX1g4Nl9TWVNGQj15CgojCiMgRXhlY3V0YWJsZSBmaWxlIGZv
cm1hdHMgLyBFbXVsYXRpb25zCiMKIyBDT05GSUdfQklORk1UX0VMRiBpcyBub3Qgc2V0CkNPTkZJ
R19BUkNIX0JJTkZNVF9FTEZfUkFORE9NSVpFX1BJRT15CiMgQ09ORklHX0JJTkZNVF9TQ1JJUFQg
aXMgbm90IHNldApDT05GSUdfSEFWRV9BT1VUPXkKIyBDT05GSUdfQklORk1UX0FPVVQgaXMgbm90
IHNldApDT05GSUdfQklORk1UX01JU0M9eQojIENPTkZJR19DT1JFRFVNUCBpcyBub3Qgc2V0CkNP
TkZJR19IQVZFX0FUT01JQ19JT01BUD15CiMgQ09ORklHX05FVCBpcyBub3Qgc2V0CgojCiMgRGV2
aWNlIERyaXZlcnMKIwoKIwojIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMKIwpDT05GSUdfVUVWRU5U
X0hFTFBFUl9QQVRIPSIiCkNPTkZJR19ERVZUTVBGUz15CkNPTkZJR19ERVZUTVBGU19NT1VOVD15
CiMgQ09ORklHX1NUQU5EQUxPTkUgaXMgbm90IHNldApDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9C
VUlMRD15CkNPTkZJR19GV19MT0FERVI9eQpDT05GSUdfRklSTVdBUkVfSU5fS0VSTkVMPXkKQ09O
RklHX0VYVFJBX0ZJUk1XQVJFPSIiCkNPTkZJR19GV19MT0FERVJfVVNFUl9IRUxQRVI9eQojIENP
TkZJR19ERUJVR19EUklWRVIgaXMgbm90IHNldApDT05GSUdfREVCVUdfREVWUkVTPXkKIyBDT05G
SUdfU1lTX0hZUEVSVklTT1IgaXMgbm90IHNldAojIENPTkZJR19HRU5FUklDX0NQVV9ERVZJQ0VT
IGlzIG5vdCBzZXQKQ09ORklHX0dFTkVSSUNfQ1BVX0FVVE9QUk9CRT15CkNPTkZJR19SRUdNQVA9
eQpDT05GSUdfUkVHTUFQX0kyQz15CkNPTkZJR19SRUdNQVBfTU1JTz15CkNPTkZJR19SRUdNQVBf
SVJRPXkKQ09ORklHX0RNQV9TSEFSRURfQlVGRkVSPXkKCiMKIyBCdXMgZGV2aWNlcwojCkNPTkZJ
R19NVEQ9eQpDT05GSUdfTVREX1JFREJPT1RfUEFSVFM9eQpDT05GSUdfTVREX1JFREJPT1RfRElS
RUNUT1JZX0JMT0NLPS0xCkNPTkZJR19NVERfUkVEQk9PVF9QQVJUU19VTkFMTE9DQVRFRD15CiMg
Q09ORklHX01URF9SRURCT09UX1BBUlRTX1JFQURPTkxZIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRE
X0NNRExJTkVfUEFSVFMgaXMgbm90IHNldApDT05GSUdfTVREX0FSN19QQVJUUz15CgojCiMgVXNl
ciBNb2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXllcnMKIwpDT05GSUdfTVREX09PUFM9eQoKIwoj
IFJBTS9ST00vRmxhc2ggY2hpcCBkcml2ZXJzCiMKIyBDT05GSUdfTVREX0NGSSBpcyBub3Qgc2V0
CkNPTkZJR19NVERfSkVERUNQUk9CRT15CkNPTkZJR19NVERfR0VOX1BST0JFPXkKIyBDT05GSUdf
TVREX0NGSV9BRFZfT1BUSU9OUyBpcyBub3Qgc2V0CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhf
MT15CkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfMj15CkNPTkZJR19NVERfTUFQX0JBTktfV0lE
VEhfND15CiMgQ09ORklHX01URF9NQVBfQkFOS19XSURUSF84IGlzIG5vdCBzZXQKIyBDT05GSUdf
TVREX01BUF9CQU5LX1dJRFRIXzE2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREX01BUF9CQU5LX1dJ
RFRIXzMyIGlzIG5vdCBzZXQKQ09ORklHX01URF9DRklfSTE9eQpDT05GSUdfTVREX0NGSV9JMj15
CiMgQ09ORklHX01URF9DRklfSTQgaXMgbm90IHNldAojIENPTkZJR19NVERfQ0ZJX0k4IGlzIG5v
dCBzZXQKQ09ORklHX01URF9DRklfSU5URUxFWFQ9eQpDT05GSUdfTVREX0NGSV9BTURTVEQ9eQpD
T05GSUdfTVREX0NGSV9TVEFBPXkKQ09ORklHX01URF9DRklfVVRJTD15CkNPTkZJR19NVERfUkFN
PXkKQ09ORklHX01URF9ST009eQojIENPTkZJR19NVERfQUJTRU5UIGlzIG5vdCBzZXQKCiMKIyBN
YXBwaW5nIGRyaXZlcnMgZm9yIGNoaXAgYWNjZXNzCiMKIyBDT05GSUdfTVREX0NPTVBMRVhfTUFQ
UElOR1MgaXMgbm90IHNldAojIENPTkZJR19NVERfUEhZU01BUCBpcyBub3Qgc2V0CkNPTkZJR19N
VERfVFM1NTAwPXkKQ09ORklHX01URF9BTUQ3NlhST009eQpDT05GSUdfTVREX0lDSFhST009eQpD
T05GSUdfTVREX05FVHRlbD15CiMgQ09ORklHX01URF9MNDQwR1ggaXMgbm90IHNldApDT05GSUdf
TVREX1BMQVRSQU09eQoKIwojIFNlbGYtY29udGFpbmVkIE1URCBkZXZpY2UgZHJpdmVycwojCkNP
TkZJR19NVERfU0xSQU09eQpDT05GSUdfTVREX1BIUkFNPXkKQ09ORklHX01URF9NVERSQU09eQpD
T05GSUdfTVREUkFNX1RPVEFMX1NJWkU9NDA5NgpDT05GSUdfTVREUkFNX0VSQVNFX1NJWkU9MTI4
CkNPTkZJR19NVERSQU1fQUJTX1BPUz0wCgojCiMgRGlzay1Pbi1DaGlwIERldmljZSBEcml2ZXJz
CiMKQ09ORklHX01URF9ET0NHMz15CkNPTkZJR19CQ0hfQ09OU1RfTT0xNApDT05GSUdfQkNIX0NP
TlNUX1Q9NApDT05GSUdfTVREX05BTkRfRUNDPXkKIyBDT05GSUdfTVREX05BTkRfRUNDX1NNQyBp
cyBub3Qgc2V0CkNPTkZJR19NVERfTkFORD15CkNPTkZJR19NVERfTkFORF9CQ0g9eQpDT05GSUdf
TVREX05BTkRfRUNDX0JDSD15CiMgQ09ORklHX01URF9TTV9DT01NT04gaXMgbm90IHNldApDT05G
SUdfTVREX05BTkRfREVOQUxJPXkKIyBDT05GSUdfTVREX05BTkRfR1BJTyBpcyBub3Qgc2V0CkNP
TkZJR19NVERfTkFORF9JRFM9eQojIENPTkZJR19NVERfTkFORF9ESVNLT05DSElQIGlzIG5vdCBz
ZXQKQ09ORklHX01URF9OQU5EX0RPQ0c0PXkKIyBDT05GSUdfTVREX05BTkRfQ1M1NTNYIGlzIG5v
dCBzZXQKIyBDT05GSUdfTVREX05BTkRfTkFORFNJTSBpcyBub3Qgc2V0CkNPTkZJR19NVERfTkFO
RF9QTEFURk9STT15CiMgQ09ORklHX01URF9OQU5EX1NIX0ZMQ1RMIGlzIG5vdCBzZXQKQ09ORklH
X01URF9PTkVOQU5EPXkKQ09ORklHX01URF9PTkVOQU5EX1ZFUklGWV9XUklURT15CiMgQ09ORklH
X01URF9PTkVOQU5EX0dFTkVSSUMgaXMgbm90IHNldAojIENPTkZJR19NVERfT05FTkFORF9PVFAg
aXMgbm90IHNldAojIENPTkZJR19NVERfT05FTkFORF8yWF9QUk9HUkFNIGlzIG5vdCBzZXQKCiMK
IyBMUEREUiBmbGFzaCBtZW1vcnkgZHJpdmVycwojCkNPTkZJR19NVERfTFBERFI9eQpDT05GSUdf
TVREX1FJTkZPX1BST0JFPXkKQ09ORklHX01URF9VQkk9eQpDT05GSUdfTVREX1VCSV9XTF9USFJF
U0hPTEQ9NDA5NgpDT05GSUdfTVREX1VCSV9CRUJfTElNSVQ9MjAKQ09ORklHX01URF9VQklfRkFT
VE1BUD15CkNPTkZJR19NVERfVUJJX0dMVUVCST15CkNPTkZJR19NVERfVUJJX0JMT0NLPXkKIyBD
T05GSUdfUEFSUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX01JR0hUX0hBVkVfUENfUEFSUE9S
VD15CkNPTkZJR19QTlA9eQpDT05GSUdfUE5QX0RFQlVHX01FU1NBR0VTPXkKCiMKIyBQcm90b2Nv
bHMKIwojIENPTkZJR19JU0FQTlAgaXMgbm90IHNldAojIENPTkZJR19QTlBCSU9TIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUE5QQUNQSSBpcyBub3Qgc2V0CgojCiMgTWlzYyBkZXZpY2VzCiMKQ09ORklH
X1NFTlNPUlNfTElTM0xWMDJEPXkKQ09ORklHX0FENTI1WF9EUE9UPXkKIyBDT05GSUdfQUQ1MjVY
X0RQT1RfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfRFVNTVlfSVJRIGlzIG5vdCBzZXQKQ09ORklH
X0lDUzkzMlM0MDE9eQojIENPTkZJR19BVE1FTF9TU0MgaXMgbm90IHNldAojIENPTkZJR19FTkNM
T1NVUkVfU0VSVklDRVMgaXMgbm90IHNldApDT05GSUdfQVBEUzk4MDJBTFM9eQojIENPTkZJR19J
U0wyOTAwMyBpcyBub3Qgc2V0CkNPTkZJR19JU0wyOTAyMD15CkNPTkZJR19TRU5TT1JTX1RTTDI1
NTA9eQpDT05GSUdfU0VOU09SU19CSDE3ODA9eQpDT05GSUdfU0VOU09SU19CSDE3NzA9eQpDT05G
SUdfU0VOU09SU19BUERTOTkwWD15CkNPTkZJR19ITUM2MzUyPXkKIyBDT05GSUdfRFMxNjgyIGlz
IG5vdCBzZXQKQ09ORklHX0JNUDA4NT15CkNPTkZJR19CTVAwODVfSTJDPXkKQ09ORklHX1VTQl9T
V0lUQ0hfRlNBOTQ4MD15CkNPTkZJR19TUkFNPXkKQ09ORklHX0MyUE9SVD15CkNPTkZJR19DMlBP
UlRfRFVSQU1BUl8yMTUwPXkKCiMKIyBFRVBST00gc3VwcG9ydAojCkNPTkZJR19FRVBST01fQVQy
ND15CkNPTkZJR19FRVBST01fTEVHQUNZPXkKIyBDT05GSUdfRUVQUk9NX01BWDY4NzUgaXMgbm90
IHNldApDT05GSUdfRUVQUk9NXzkzQ1g2PXkKCiMKIyBUZXhhcyBJbnN0cnVtZW50cyBzaGFyZWQg
dHJhbnNwb3J0IGxpbmUgZGlzY2lwbGluZQojCkNPTkZJR19TRU5TT1JTX0xJUzNfSTJDPXkKCiMK
IyBBbHRlcmEgRlBHQSBmaXJtd2FyZSBkb3dubG9hZCBtb2R1bGUKIwojIENPTkZJR19BTFRFUkFf
U1RBUEwgaXMgbm90IHNldAoKIwojIEludGVsIE1JQyBIb3N0IERyaXZlcgojCgojCiMgSW50ZWwg
TUlDIENhcmQgRHJpdmVyCiMKIyBDT05GSUdfRUNITyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0lE
RT15CgojCiMgU0NTSSBkZXZpY2Ugc3VwcG9ydAojCkNPTkZJR19TQ1NJX01PRD15CiMgQ09ORklH
X1NDU0lfRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9ORVRMSU5LIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUFDSU5UT1NIX0RSSVZFUlMgaXMgbm90IHNldAoKIwojIElucHV0IGRldmljZSBzdXBw
b3J0CiMKQ09ORklHX0lOUFVUPXkKQ09ORklHX0lOUFVUX0ZGX01FTUxFU1M9eQpDT05GSUdfSU5Q
VVRfUE9MTERFVj15CkNPTkZJR19JTlBVVF9TUEFSU0VLTUFQPXkKQ09ORklHX0lOUFVUX01BVFJJ
WEtNQVA9eQoKIwojIFVzZXJsYW5kIGludGVyZmFjZXMKIwpDT05GSUdfSU5QVVRfTU9VU0VERVY9
eQojIENPTkZJR19JTlBVVF9NT1VTRURFVl9QU0FVWCBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9N
T1VTRURFVl9TQ1JFRU5fWD0xMDI0CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWT03NjgK
Q09ORklHX0lOUFVUX0pPWURFVj15CkNPTkZJR19JTlBVVF9FVkRFVj15CiMgQ09ORklHX0lOUFVU
X0VWQlVHIGlzIG5vdCBzZXQKCiMKIyBJbnB1dCBEZXZpY2UgRHJpdmVycwojCiMgQ09ORklHX0lO
UFVUX0tFWUJPQVJEIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX0xFRFM9eQojIENPTkZJR19JTlBV
VF9NT1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0pPWVNUSUNLIGlzIG5vdCBzZXQKQ09O
RklHX0lOUFVUX1RBQkxFVD15CkNPTkZJR19JTlBVVF9UT1VDSFNDUkVFTj15CkNPTkZJR19UT1VD
SFNDUkVFTl9BRDc4Nzk9eQojIENPTkZJR19UT1VDSFNDUkVFTl9BRDc4NzlfSTJDIGlzIG5vdCBz
ZXQKQ09ORklHX1RPVUNIU0NSRUVOX0FUTUVMX01YVD15CiMgQ09ORklHX1RPVUNIU0NSRUVOX0FV
T19QSVhDSVIgaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fQlUyMTAxMz15CiMgQ09ORklH
X1RPVUNIU0NSRUVOX0NZOENUTUcxMTAgaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fQ1lU
VFNQX0NPUkU9eQojIENPTkZJR19UT1VDSFNDUkVFTl9DWVRUU1BfSTJDIGlzIG5vdCBzZXQKQ09O
RklHX1RPVUNIU0NSRUVOX0NZVFRTUDRfQ09SRT15CkNPTkZJR19UT1VDSFNDUkVFTl9DWVRUU1A0
X0kyQz15CkNPTkZJR19UT1VDSFNDUkVFTl9EQTkwMzQ9eQojIENPTkZJR19UT1VDSFNDUkVFTl9E
WU5BUFJPIGlzIG5vdCBzZXQKQ09ORklHX1RPVUNIU0NSRUVOX0hBTVBTSElSRT15CkNPTkZJR19U
T1VDSFNDUkVFTl9FRVRJPXkKQ09ORklHX1RPVUNIU0NSRUVOX0ZVSklUU1U9eQpDT05GSUdfVE9V
Q0hTQ1JFRU5fSUxJMjEwWD15CkNPTkZJR19UT1VDSFNDUkVFTl9HVU5aRT15CkNPTkZJR19UT1VD
SFNDUkVFTl9FTE89eQpDT05GSUdfVE9VQ0hTQ1JFRU5fV0FDT01fVzgwMDE9eQojIENPTkZJR19U
T1VDSFNDUkVFTl9XQUNPTV9JMkMgaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fTUFYMTE4
MDE9eQpDT05GSUdfVE9VQ0hTQ1JFRU5fTUNTNTAwMD15CkNPTkZJR19UT1VDSFNDUkVFTl9NTVMx
MTQ9eQojIENPTkZJR19UT1VDSFNDUkVFTl9NVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9JTkVYSU8gaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5fTUs3MTI9eQpDT05G
SUdfVE9VQ0hTQ1JFRU5fSFRDUEVOPXkKQ09ORklHX1RPVUNIU0NSRUVOX1BFTk1PVU5UPXkKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fRURUX0ZUNVgwNiBpcyBub3Qgc2V0CkNPTkZJR19UT1VDSFNDUkVF
Tl9UT1VDSFJJR0hUPXkKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU4gaXMgbm90IHNldAoj
IENPTkZJR19UT1VDSFNDUkVFTl9USV9BTTMzNVhfVFNDIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fUElYQ0lSIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fV004MzFYIGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTUMxMzc4MyBpcyBub3Qgc2V0CkNPTkZJR19U
T1VDSFNDUkVFTl9UT1VDSElUMjEzPXkKQ09ORklHX1RPVUNIU0NSRUVOX1RTQ19TRVJJTz15CiMg
Q09ORklHX1RPVUNIU0NSRUVOX1RTQzIwMDcgaXMgbm90IHNldApDT05GSUdfVE9VQ0hTQ1JFRU5f
U1QxMjMyPXkKQ09ORklHX1RPVUNIU0NSRUVOX1NUTVBFPXkKQ09ORklHX1RPVUNIU0NSRUVOX1RQ
UzY1MDdYPXkKQ09ORklHX1RPVUNIU0NSRUVOX1pGT1JDRT15CkNPTkZJR19JTlBVVF9NSVNDPXkK
Q09ORklHX0lOUFVUX0FENzE0WD15CkNPTkZJR19JTlBVVF9BRDcxNFhfSTJDPXkKQ09ORklHX0lO
UFVUX0JNQTE1MD15CkNPTkZJR19JTlBVVF9NQzEzNzgzX1BXUkJVVFRPTj15CkNPTkZJR19JTlBV
VF9NTUE4NDUwPXkKQ09ORklHX0lOUFVUX01QVTMwNTA9eQpDT05GSUdfSU5QVVRfQVBBTkVMPXkK
Q09ORklHX0lOUFVUX0dQMkE9eQpDT05GSUdfSU5QVVRfR1BJT19USUxUX1BPTExFRD15CkNPTkZJ
R19JTlBVVF9XSVNUUk9OX0JUTlM9eQojIENPTkZJR19JTlBVVF9LWFRKOSBpcyBub3Qgc2V0CkNP
TkZJR19JTlBVVF9SRVRVX1BXUkJVVFRPTj15CkNPTkZJR19JTlBVVF9UV0w0MDMwX1BXUkJVVFRP
Tj15CkNPTkZJR19JTlBVVF9UV0w0MDMwX1ZJQlJBPXkKQ09ORklHX0lOUFVUX1VJTlBVVD15CkNP
TkZJR19JTlBVVF9QQ0Y1MDYzM19QTVU9eQpDT05GSUdfSU5QVVRfUENGODU3ND15CiMgQ09ORklH
X0lOUFVUX1BXTV9CRUVQRVIgaXMgbm90IHNldApDT05GSUdfSU5QVVRfR1BJT19ST1RBUllfRU5D
T0RFUj15CiMgQ09ORklHX0lOUFVUX0RBOTA1NV9PTktFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lO
UFVUX1dNODMxWF9PTiBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9BRFhMMzRYPXkKIyBDT05GSUdf
SU5QVVRfQURYTDM0WF9JMkMgaXMgbm90IHNldApDT05GSUdfSU5QVVRfQ01BMzAwMD15CkNPTkZJ
R19JTlBVVF9DTUEzMDAwX0kyQz15CkNPTkZJR19JTlBVVF9JREVBUEFEX1NMSURFQkFSPXkKCiMK
IyBIYXJkd2FyZSBJL08gcG9ydHMKIwpDT05GSUdfU0VSSU89eQpDT05GSUdfQVJDSF9NSUdIVF9I
QVZFX1BDX1NFUklPPXkKQ09ORklHX1NFUklPX0k4MDQyPXkKQ09ORklHX1NFUklPX0NUODJDNzEw
PXkKQ09ORklHX1NFUklPX0xJQlBTMj15CkNPTkZJR19TRVJJT19SQVc9eQpDT05GSUdfU0VSSU9f
QUxURVJBX1BTMj15CiMgQ09ORklHX1NFUklPX1BTMk1VTFQgaXMgbm90IHNldApDT05GSUdfU0VS
SU9fQVJDX1BTMj15CkNPTkZJR19HQU1FUE9SVD15CkNPTkZJR19HQU1FUE9SVF9OUzU1OD15CkNP
TkZJR19HQU1FUE9SVF9MND15CgojCiMgQ2hhcmFjdGVyIGRldmljZXMKIwojIENPTkZJR19UVFkg
aXMgbm90IHNldApDT05GSUdfREVWS01FTT15CkNPTkZJR19JUE1JX0hBTkRMRVI9eQojIENPTkZJ
R19JUE1JX1BBTklDX0VWRU5UIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBNSV9ERVZJQ0VfSU5URVJG
QUNFIGlzIG5vdCBzZXQKQ09ORklHX0lQTUlfU0k9eQojIENPTkZJR19JUE1JX1dBVENIRE9HIGlz
IG5vdCBzZXQKQ09ORklHX0lQTUlfUE9XRVJPRkY9eQpDT05GSUdfSFdfUkFORE9NPXkKIyBDT05G
SUdfSFdfUkFORE9NX1RJTUVSSU9NRU0gaXMgbm90IHNldApDT05GSUdfSFdfUkFORE9NX1ZJQT15
CkNPTkZJR19IV19SQU5ET01fVklSVElPPXkKQ09ORklHX05WUkFNPXkKIyBDT05GSUdfRFRMSyBp
cyBub3Qgc2V0CkNPTkZJR19QQzg3MzZ4X0dQSU89eQpDT05GSUdfTlNDX0dQSU89eQpDT05GSUdf
SEFOR0NIRUNLX1RJTUVSPXkKIyBDT05GSUdfVENHX1RQTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RF
TENMT0NLIGlzIG5vdCBzZXQKQ09ORklHX0RFVlBPUlQ9eQpDT05GSUdfSTJDPXkKQ09ORklHX0ky
Q19CT0FSRElORk89eQojIENPTkZJR19JMkNfQ09NUEFUIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19D
SEFSREVWPXkKQ09ORklHX0kyQ19NVVg9eQoKIwojIE11bHRpcGxleGVyIEkyQyBDaGlwIHN1cHBv
cnQKIwpDT05GSUdfSTJDX01VWF9HUElPPXkKIyBDT05GSUdfSTJDX01VWF9QQ0E5NTQxIGlzIG5v
dCBzZXQKIyBDT05GSUdfSTJDX01VWF9QQ0E5NTR4IGlzIG5vdCBzZXQKQ09ORklHX0kyQ19IRUxQ
RVJfQVVUTz15CkNPTkZJR19JMkNfQUxHT0JJVD15CkNPTkZJR19JMkNfQUxHT1BDRj15CkNPTkZJ
R19JMkNfQUxHT1BDQT15CgojCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CiMKCiMKIyBJMkMg
c3lzdGVtIGJ1cyBkcml2ZXJzIChtb3N0bHkgZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hpcCkKIwpD
T05GSUdfSTJDX0NCVVNfR1BJTz15CkNPTkZJR19JMkNfREVTSUdOV0FSRV9DT1JFPXkKQ09ORklH
X0kyQ19ERVNJR05XQVJFX1BMQVRGT1JNPXkKQ09ORklHX0kyQ19HUElPPXkKQ09ORklHX0kyQ19L
RU1QTEQ9eQpDT05GSUdfSTJDX09DT1JFUz15CiMgQ09ORklHX0kyQ19QQ0FfUExBVEZPUk0gaXMg
bm90IHNldAojIENPTkZJR19JMkNfUFhBX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19SSUlD
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NIX01PQklMRSBpcyBub3Qgc2V0CkNPTkZJR19JMkNf
U0lNVEVDPXkKIyBDT05GSUdfSTJDX1hJTElOWCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19SQ0FS
IGlzIG5vdCBzZXQKCiMKIyBFeHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzCiMKIyBD
T05GSUdfSTJDX1BBUlBPUlRfTElHSFQgaXMgbm90IHNldAoKIwojIE90aGVyIEkyQy9TTUJ1cyBi
dXMgZHJpdmVycwojCkNPTkZJR19JMkNfRUxFS1RPUj15CkNPTkZJR19JMkNfUENBX0lTQT15CkNP
TkZJR19JMkNfREVCVUdfQ09SRT15CiMgQ09ORklHX0kyQ19ERUJVR19BTEdPIGlzIG5vdCBzZXQK
Q09ORklHX0kyQ19ERUJVR19CVVM9eQojIENPTkZJR19TUEkgaXMgbm90IHNldApDT05GSUdfU1BN
ST15CkNPTkZJR19IU0k9eQpDT05GSUdfSFNJX0JPQVJESU5GTz15CgojCiMgSFNJIGNsaWVudHMK
IwpDT05GSUdfSFNJX0NIQVI9eQoKIwojIFBQUyBzdXBwb3J0CiMKQ09ORklHX1BQUz15CiMgQ09O
RklHX1BQU19ERUJVRyBpcyBub3Qgc2V0CgojCiMgUFBTIGNsaWVudHMgc3VwcG9ydAojCkNPTkZJ
R19QUFNfQ0xJRU5UX0tUSU1FUj15CkNPTkZJR19QUFNfQ0xJRU5UX0dQSU89eQoKIwojIFBQUyBn
ZW5lcmF0b3JzIHN1cHBvcnQKIwoKIwojIFBUUCBjbG9jayBzdXBwb3J0CiMKQ09ORklHX1BUUF8x
NTg4X0NMT0NLPXkKCiMKIyBFbmFibGUgUEhZTElCIGFuZCBORVRXT1JLX1BIWV9USU1FU1RBTVBJ
TkcgdG8gc2VlIHRoZSBhZGRpdGlvbmFsIGNsb2Nrcy4KIwpDT05GSUdfUFRQXzE1ODhfQ0xPQ0tf
UENIPXkKQ09ORklHX0FSQ0hfV0FOVF9PUFRJT05BTF9HUElPTElCPXkKQ09ORklHX0dQSU9MSUI9
eQpDT05GSUdfR1BJT19ERVZSRVM9eQojIENPTkZJR19ERUJVR19HUElPIGlzIG5vdCBzZXQKQ09O
RklHX0dQSU9fU1lTRlM9eQpDT05GSUdfR1BJT19HRU5FUklDPXkKIyBDT05GSUdfR1BJT19EQTkw
NTUgaXMgbm90IHNldApDT05GSUdfR1BJT19NQVg3MzBYPXkKCiMKIyBNZW1vcnkgbWFwcGVkIEdQ
SU8gZHJpdmVyczoKIwpDT05GSUdfR1BJT19DTFBTNzExWD15CiMgQ09ORklHX0dQSU9fR0VORVJJ
Q19QTEFURk9STSBpcyBub3Qgc2V0CkNPTkZJR19HUElPX0lUODc2MUU9eQpDT05GSUdfR1BJT19G
NzE4OFg9eQojIENPTkZJR19HUElPX1NDSDMxMVggaXMgbm90IHNldApDT05GSUdfR1BJT19UUzU1
MDA9eQoKIwojIEkyQyBHUElPIGV4cGFuZGVyczoKIwpDT05GSUdfR1BJT19BUklaT05BPXkKQ09O
RklHX0dQSU9fTFAzOTQzPXkKQ09ORklHX0dQSU9fTUFYNzMwMD15CiMgQ09ORklHX0dQSU9fTUFY
NzMyWCBpcyBub3Qgc2V0CkNPTkZJR19HUElPX1BDQTk1M1g9eQpDT05GSUdfR1BJT19QQ0E5NTNY
X0lSUT15CkNPTkZJR19HUElPX1BDRjg1N1g9eQojIENPTkZJR19HUElPX1NYMTUwWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0dQSU9fU1RNUEUgaXMgbm90IHNldApDT05GSUdfR1BJT19UQzM1ODlYPXkK
Q09ORklHX0dQSU9fVFBTNjU5MTI9eQpDT05GSUdfR1BJT19UV0w0MDMwPXkKQ09ORklHX0dQSU9f
V004MzFYPXkKIyBDT05GSUdfR1BJT19XTTg5OTQgaXMgbm90IHNldApDT05GSUdfR1BJT19BRFA1
NTIwPXkKQ09ORklHX0dQSU9fQURQNTU4OD15CiMgQ09ORklHX0dQSU9fQURQNTU4OF9JUlEgaXMg
bm90IHNldAoKIwojIFBDSSBHUElPIGV4cGFuZGVyczoKIwoKIwojIFNQSSBHUElPIGV4cGFuZGVy
czoKIwoKIwojIEFDOTcgR1BJTyBleHBhbmRlcnM6CiMKCiMKIyBMUEMgR1BJTyBleHBhbmRlcnM6
CiMKIyBDT05GSUdfR1BJT19LRU1QTEQgaXMgbm90IHNldAoKIwojIE1PRFVMYnVzIEdQSU8gZXhw
YW5kZXJzOgojCiMgQ09ORklHX0dQSU9fUEFMTUFTIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19U
UFM2NTg2WCBpcyBub3Qgc2V0CkNPTkZJR19HUElPX1RQUzY1OTEwPXkKCiMKIyBVU0IgR1BJTyBl
eHBhbmRlcnM6CiMKQ09ORklHX1cxPXkKCiMKIyAxLXdpcmUgQnVzIE1hc3RlcnMKIwpDT05GSUdf
VzFfTUFTVEVSX0RTMjQ4Mj15CiMgQ09ORklHX1cxX01BU1RFUl9NWEMgaXMgbm90IHNldAojIENP
TkZJR19XMV9NQVNURVJfRFMxV00gaXMgbm90IHNldAojIENPTkZJR19XMV9NQVNURVJfR1BJTyBp
cyBub3Qgc2V0CgojCiMgMS13aXJlIFNsYXZlcwojCkNPTkZJR19XMV9TTEFWRV9USEVSTT15CkNP
TkZJR19XMV9TTEFWRV9TTUVNPXkKQ09ORklHX1cxX1NMQVZFX0RTMjQwOD15CkNPTkZJR19XMV9T
TEFWRV9EUzI0MDhfUkVBREJBQ0s9eQojIENPTkZJR19XMV9TTEFWRV9EUzI0MTMgaXMgbm90IHNl
dApDT05GSUdfVzFfU0xBVkVfRFMyNDIzPXkKQ09ORklHX1cxX1NMQVZFX0RTMjQzMT15CkNPTkZJ
R19XMV9TTEFWRV9EUzI0MzM9eQojIENPTkZJR19XMV9TTEFWRV9EUzI0MzNfQ1JDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVzFfU0xBVkVfRFMyNzYwIGlzIG5vdCBzZXQKQ09ORklHX1cxX1NMQVZFX0RT
Mjc4MD15CkNPTkZJR19XMV9TTEFWRV9EUzI3ODE9eQpDT05GSUdfVzFfU0xBVkVfRFMyOEUwND15
CiMgQ09ORklHX1cxX1NMQVZFX0JRMjcwMDAgaXMgbm90IHNldApDT05GSUdfUE9XRVJfU1VQUExZ
PXkKQ09ORklHX1BPV0VSX1NVUFBMWV9ERUJVRz15CkNPTkZJR19QREFfUE9XRVI9eQpDT05GSUdf
V004MzFYX0JBQ0tVUD15CkNPTkZJR19XTTgzMVhfUE9XRVI9eQpDT05GSUdfVEVTVF9QT1dFUj15
CkNPTkZJR19CQVRURVJZX0RTMjc4MD15CkNPTkZJR19CQVRURVJZX0RTMjc4MT15CkNPTkZJR19C
QVRURVJZX0RTMjc4Mj15CkNPTkZJR19CQVRURVJZX1NCUz15CiMgQ09ORklHX0JBVFRFUllfQlEy
N3gwMCBpcyBub3Qgc2V0CkNPTkZJR19CQVRURVJZX0RBOTAzMD15CkNPTkZJR19CQVRURVJZX01B
WDE3MDQwPXkKIyBDT05GSUdfQkFUVEVSWV9NQVgxNzA0MiBpcyBub3Qgc2V0CkNPTkZJR19CQVRU
RVJZX1RXTDQwMzBfTUFEQz15CiMgQ09ORklHX0NIQVJHRVJfUENGNTA2MzMgaXMgbm90IHNldApD
T05GSUdfQkFUVEVSWV9SWDUxPXkKQ09ORklHX0NIQVJHRVJfTUFYODkwMz15CiMgQ09ORklHX0NI
QVJHRVJfVFdMNDAzMCBpcyBub3Qgc2V0CkNPTkZJR19DSEFSR0VSX0xQODcyNz15CkNPTkZJR19D
SEFSR0VSX0dQSU89eQojIENPTkZJR19DSEFSR0VSX01BWDE0NTc3IGlzIG5vdCBzZXQKQ09ORklH
X0NIQVJHRVJfQlEyNDE1WD15CkNPTkZJR19DSEFSR0VSX0JRMjQxOTA9eQpDT05GSUdfQ0hBUkdF
Ul9CUTI0NzM1PXkKQ09ORklHX0NIQVJHRVJfU01CMzQ3PXkKQ09ORklHX0JBVFRFUllfR09MREZJ
U0g9eQpDT05GSUdfUE9XRVJfUkVTRVQ9eQojIENPTkZJR19QT1dFUl9BVlMgaXMgbm90IHNldApD
T05GSUdfSFdNT049eQpDT05GSUdfSFdNT05fVklEPXkKQ09ORklHX0hXTU9OX0RFQlVHX0NISVA9
eQoKIwojIE5hdGl2ZSBkcml2ZXJzCiMKQ09ORklHX1NFTlNPUlNfQUJJVFVHVVJVPXkKIyBDT05G
SUdfU0VOU09SU19BQklUVUdVUlUzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRDc0MTQg
aXMgbm90IHNldApDT05GSUdfU0VOU09SU19BRDc0MTg9eQojIENPTkZJR19TRU5TT1JTX0FETTEw
MjEgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19BRE0xMDI1PXkKQ09ORklHX1NFTlNPUlNfQURN
MTAyNj15CkNPTkZJR19TRU5TT1JTX0FETTEwMjk9eQpDT05GSUdfU0VOU09SU19BRE0xMDMxPXkK
IyBDT05GSUdfU0VOU09SU19BRE05MjQwIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfQURUN1gx
MD15CkNPTkZJR19TRU5TT1JTX0FEVDc0MTA9eQojIENPTkZJR19TRU5TT1JTX0FEVDc0MTEgaXMg
bm90IHNldApDT05GSUdfU0VOU09SU19BRFQ3NDYyPXkKIyBDT05GSUdfU0VOU09SU19BRFQ3NDcw
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQKQ09ORklHX1NF
TlNPUlNfQVNDNzYyMT15CkNPTkZJR19TRU5TT1JTX0FQUExFU01DPXkKQ09ORklHX1NFTlNPUlNf
QVNCMTAwPXkKIyBDT05GSUdfU0VOU09SU19BVFhQMSBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JT
X0RTNjIwPXkKQ09ORklHX1NFTlNPUlNfRFMxNjIxPXkKQ09ORklHX1NFTlNPUlNfREE5MDU1PXkK
IyBDT05GSUdfU0VOU09SU19GNzE4MDVGIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfRjcxODgy
Rkc9eQojIENPTkZJR19TRU5TT1JTX0Y3NTM3NVMgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19N
QzEzNzgzX0FEQz15CkNPTkZJR19TRU5TT1JTX0ZTQ0hNRD15CiMgQ09ORklHX1NFTlNPUlNfR0w1
MThTTSBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0dMNTIwU009eQpDT05GSUdfU0VOU09SU19H
NzYwQT15CiMgQ09ORklHX1NFTlNPUlNfRzc2MiBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0dQ
SU9fRkFOPXkKQ09ORklHX1NFTlNPUlNfSElINjEzMD15CiMgQ09ORklHX1NFTlNPUlNfSUJNQUVN
IGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfSUJNUEVYPXkKQ09ORklHX1NFTlNPUlNfQ09SRVRF
TVA9eQojIENPTkZJR19TRU5TT1JTX0lUODcgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19KQzQy
PXkKQ09ORklHX1NFTlNPUlNfTElORUFHRT15CkNPTkZJR19TRU5TT1JTX0xUQzI5NDU9eQpDT05G
SUdfU0VOU09SU19MVEM0MTUxPXkKQ09ORklHX1NFTlNPUlNfTFRDNDIxNT15CkNPTkZJR19TRU5T
T1JTX0xUQzQyMjI9eQpDT05GSUdfU0VOU09SU19MVEM0MjQ1PXkKQ09ORklHX1NFTlNPUlNfTFRD
NDI2MD15CkNPTkZJR19TRU5TT1JTX0xUQzQyNjE9eQpDT05GSUdfU0VOU09SU19NQVgxNjA2NT15
CkNPTkZJR19TRU5TT1JTX01BWDE2MTk9eQpDT05GSUdfU0VOU09SU19NQVgxNjY4PXkKQ09ORklH
X1NFTlNPUlNfTUFYMTk3PXkKQ09ORklHX1NFTlNPUlNfTUFYNjYzOT15CkNPTkZJR19TRU5TT1JT
X01BWDY2NDI9eQojIENPTkZJR19TRU5TT1JTX01BWDY2NTAgaXMgbm90IHNldApDT05GSUdfU0VO
U09SU19NQVg2Njk3PXkKIyBDT05GSUdfU0VOU09SU19IVFUyMSBpcyBub3Qgc2V0CkNPTkZJR19T
RU5TT1JTX01DUDMwMjE9eQojIENPTkZJR19TRU5TT1JTX0xNNjMgaXMgbm90IHNldApDT05GSUdf
U0VOU09SU19MTTczPXkKIyBDT05GSUdfU0VOU09SU19MTTc1IGlzIG5vdCBzZXQKQ09ORklHX1NF
TlNPUlNfTE03Nz15CiMgQ09ORklHX1NFTlNPUlNfTE03OCBpcyBub3Qgc2V0CkNPTkZJR19TRU5T
T1JTX0xNODA9eQojIENPTkZJR19TRU5TT1JTX0xNODMgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX0xNODUgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19MTTg3PXkKQ09ORklHX1NFTlNPUlNf
TE05MD15CiMgQ09ORklHX1NFTlNPUlNfTE05MiBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0xN
OTM9eQpDT05GSUdfU0VOU09SU19MTTk1MjM0PXkKQ09ORklHX1NFTlNPUlNfTE05NTI0MT15CiMg
Q09ORklHX1NFTlNPUlNfTE05NTI0NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfUEM4NzM2
MCBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX1BDODc0Mjc9eQpDT05GSUdfU0VOU09SU19OVENf
VEhFUk1JU1RPUj15CiMgQ09ORklHX1NFTlNPUlNfTkNUNjc3NSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfUENGODU5MSBpcyBub3Qgc2V0CkNPTkZJR19QTUJVUz15CkNPTkZJR19TRU5TT1JT
X1BNQlVTPXkKQ09ORklHX1NFTlNPUlNfQURNMTI3NT15CkNPTkZJR19TRU5TT1JTX0xNMjUwNjY9
eQpDT05GSUdfU0VOU09SU19MVEMyOTc4PXkKIyBDT05GSUdfU0VOU09SU19NQVgxNjA2NCBpcyBu
b3Qgc2V0CkNPTkZJR19TRU5TT1JTX01BWDM0NDQwPXkKQ09ORklHX1NFTlNPUlNfTUFYODY4OD15
CkNPTkZJR19TRU5TT1JTX1VDRDkwMDA9eQpDT05GSUdfU0VOU09SU19VQ0Q5MjAwPXkKQ09ORklH
X1NFTlNPUlNfWkw2MTAwPXkKQ09ORklHX1NFTlNPUlNfU0hUMTU9eQojIENPTkZJR19TRU5TT1JT
X1NIVDIxIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfRE1FMTczNz15CiMgQ09ORklHX1NFTlNP
UlNfRU1DMTQwMyBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0VNQzIxMDM9eQpDT05GSUdfU0VO
U09SU19FTUM2VzIwMT15CkNPTkZJR19TRU5TT1JTX1NNU0M0N00xPXkKIyBDT05GSUdfU0VOU09S
U19TTVNDNDdNMTkyIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfU01TQzQ3QjM5Nz15CiMgQ09O
RklHX1NFTlNPUlNfU0NINTZYWF9DT01NT04gaXMgbm90IHNldApDT05GSUdfU0VOU09SU19TTU02
NjU9eQpDT05GSUdfU0VOU09SU19BREMxMjhEODE4PXkKQ09ORklHX1NFTlNPUlNfQURTMTAxNT15
CiMgQ09ORklHX1NFTlNPUlNfQURTNzgyOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQU1D
NjgyMSBpcyBub3Qgc2V0CkNPTkZJR19TRU5TT1JTX0lOQTIwOT15CkNPTkZJR19TRU5TT1JTX0lO
QTJYWD15CiMgQ09ORklHX1NFTlNPUlNfVEhNQzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19UTVAxMDIgaXMgbm90IHNldApDT05GSUdfU0VOU09SU19UTVA0MDE9eQpDT05GSUdfU0VOU09S
U19UTVA0MjE9eQpDT05GSUdfU0VOU09SU19UV0w0MDMwX01BREM9eQojIENPTkZJR19TRU5TT1JT
X1ZJQV9DUFVURU1QIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfVlQxMjExPXkKIyBDT05GSUdf
U0VOU09SU19XODM3ODFEIGlzIG5vdCBzZXQKQ09ORklHX1NFTlNPUlNfVzgzNzkxRD15CkNPTkZJ
R19TRU5TT1JTX1c4Mzc5MkQ9eQpDT05GSUdfU0VOU09SU19XODM3OTM9eQpDT05GSUdfU0VOU09S
U19XODM3OTU9eQojIENPTkZJR19TRU5TT1JTX1c4Mzc5NV9GQU5DVFJMIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19XODNMNzg1VFMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4M0w3
ODZORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNjI3SEYgaXMgbm90IHNldApDT05G
SUdfU0VOU09SU19XODM2MjdFSEY9eQojIENPTkZJR19TRU5TT1JTX1dNODMxWCBpcyBub3Qgc2V0
CkNPTkZJR19USEVSTUFMPXkKQ09ORklHX1RIRVJNQUxfSFdNT049eQpDT05GSUdfVEhFUk1BTF9E
RUZBVUxUX0dPVl9TVEVQX1dJU0U9eQojIENPTkZJR19USEVSTUFMX0RFRkFVTFRfR09WX0ZBSVJf
U0hBUkUgaXMgbm90IHNldAojIENPTkZJR19USEVSTUFMX0RFRkFVTFRfR09WX1VTRVJfU1BBQ0Ug
aXMgbm90IHNldAojIENPTkZJR19USEVSTUFMX0dPVl9GQUlSX1NIQVJFIGlzIG5vdCBzZXQKQ09O
RklHX1RIRVJNQUxfR09WX1NURVBfV0lTRT15CkNPTkZJR19USEVSTUFMX0dPVl9VU0VSX1NQQUNF
PXkKIyBDT05GSUdfVEhFUk1BTF9FTVVMQVRJT04gaXMgbm90IHNldApDT05GSUdfUkNBUl9USEVS
TUFMPXkKCiMKIyBUZXhhcyBJbnN0cnVtZW50cyB0aGVybWFsIGRyaXZlcnMKIwojIENPTkZJR19X
QVRDSERPRyBpcyBub3Qgc2V0CkNPTkZJR19TU0JfUE9TU0lCTEU9eQoKIwojIFNvbmljcyBTaWxp
Y29uIEJhY2twbGFuZQojCiMgQ09ORklHX1NTQiBpcyBub3Qgc2V0CkNPTkZJR19CQ01BX1BPU1NJ
QkxFPXkKCiMKIyBCcm9hZGNvbSBzcGVjaWZpYyBBTUJBCiMKQ09ORklHX0JDTUE9eQojIENPTkZJ
R19CQ01BX0hPU1RfU09DIGlzIG5vdCBzZXQKIyBDT05GSUdfQkNNQV9EUklWRVJfR01BQ19DTU4g
aXMgbm90IHNldApDT05GSUdfQkNNQV9EUklWRVJfR1BJTz15CkNPTkZJR19CQ01BX0RFQlVHPXkK
CiMKIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJzCiMKQ09ORklHX01GRF9DT1JFPXkKIyBD
T05GSUdfTUZEX0FTMzcxMSBpcyBub3Qgc2V0CkNPTkZJR19QTUlDX0FEUDU1MjA9eQojIENPTkZJ
R19NRkRfQUFUMjg3MF9DT1JFIGlzIG5vdCBzZXQKQ09ORklHX01GRF9DUk9TX0VDPXkKQ09ORklH
X01GRF9DUk9TX0VDX0kyQz15CkNPTkZJR19QTUlDX0RBOTAzWD15CiMgQ09ORklHX01GRF9EQTkw
NTJfSTJDIGlzIG5vdCBzZXQKQ09ORklHX01GRF9EQTkwNTU9eQpDT05GSUdfTUZEX0RBOTA2Mz15
CkNPTkZJR19NRkRfTUMxM1hYWD15CkNPTkZJR19NRkRfTUMxM1hYWF9JMkM9eQojIENPTkZJR19I
VENfUEFTSUMzIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRDX0kyQ1BMRCBpcyBub3Qgc2V0CkNPTkZJ
R19NRkRfS0VNUExEPXkKIyBDT05GSUdfTUZEXzg4UE04MDAgaXMgbm90IHNldApDT05GSUdfTUZE
Xzg4UE04MDU9eQojIENPTkZJR19NRkRfODhQTTg2MFggaXMgbm90IHNldApDT05GSUdfTUZEX01B
WDE0NTc3PXkKIyBDT05GSUdfTUZEX01BWDc3Njg2IGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01B
WDc3NjkzIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01BWDg5MDcgaXMgbm90IHNldAojIENPTkZJ
R19NRkRfTUFYODkyNSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg4OTk3IGlzIG5vdCBzZXQK
Q09ORklHX01GRF9NQVg4OTk4PXkKQ09ORklHX01GRF9SRVRVPXkKQ09ORklHX01GRF9QQ0Y1MDYz
Mz15CiMgQ09ORklHX1BDRjUwNjMzX0FEQyBpcyBub3Qgc2V0CkNPTkZJR19QQ0Y1MDYzM19HUElP
PXkKIyBDT05GSUdfTUZEX1JDNVQ1ODMgaXMgbm90IHNldApDT05GSUdfTUZEX1NFQ19DT1JFPXkK
IyBDT05GSUdfTUZEX1NJNDc2WF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1NNNTAxIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX1NNU0MgaXMgbm90IHNldAojIENPTkZJR19BQlg1MDBfQ09S
RSBpcyBub3Qgc2V0CkNPTkZJR19NRkRfU1RNUEU9eQoKIwojIFNUTWljcm9lbGVjdHJvbmljcyBT
VE1QRSBJbnRlcmZhY2UgRHJpdmVycwojCkNPTkZJR19TVE1QRV9JMkM9eQpDT05GSUdfTUZEX1NZ
U0NPTj15CkNPTkZJR19NRkRfVElfQU0zMzVYX1RTQ0FEQz15CkNPTkZJR19NRkRfTFAzOTQzPXkK
IyBDT05GSUdfTUZEX0xQODc4OCBpcyBub3Qgc2V0CkNPTkZJR19NRkRfUEFMTUFTPXkKIyBDT05G
SUdfVFBTNjEwNVggaXMgbm90IHNldApDT05GSUdfVFBTNjUwMTA9eQpDT05GSUdfVFBTNjUwN1g9
eQojIENPTkZJR19NRkRfVFBTNjUwOTAgaXMgbm90IHNldApDT05GSUdfTUZEX1RQUzY1MjE3PXkK
Q09ORklHX01GRF9UUFM2NTg2WD15CkNPTkZJR19NRkRfVFBTNjU5MTA9eQpDT05GSUdfTUZEX1RQ
UzY1OTEyPXkKQ09ORklHX01GRF9UUFM2NTkxMl9JMkM9eQpDT05GSUdfTUZEX1RQUzgwMDMxPXkK
Q09ORklHX1RXTDQwMzBfQ09SRT15CkNPTkZJR19UV0w0MDMwX01BREM9eQpDT05GSUdfTUZEX1RX
TDQwMzBfQVVESU89eQojIENPTkZJR19UV0w2MDQwX0NPUkUgaXMgbm90IHNldApDT05GSUdfTUZE
X1dMMTI3M19DT1JFPXkKIyBDT05GSUdfTUZEX0xNMzUzMyBpcyBub3Qgc2V0CkNPTkZJR19NRkRf
VEMzNTg5WD15CiMgQ09ORklHX01GRF9UTUlPIGlzIG5vdCBzZXQKQ09ORklHX01GRF9BUklaT05B
PXkKQ09ORklHX01GRF9BUklaT05BX0kyQz15CkNPTkZJR19NRkRfV001MTAyPXkKIyBDT05GSUdf
TUZEX1dNNTExMCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTg5OTcgaXMgbm90IHNldAojIENP
TkZJR19NRkRfV004NDAwIGlzIG5vdCBzZXQKQ09ORklHX01GRF9XTTgzMVg9eQpDT05GSUdfTUZE
X1dNODMxWF9JMkM9eQojIENPTkZJR19NRkRfV004MzUwX0kyQyBpcyBub3Qgc2V0CkNPTkZJR19N
RkRfV004OTk0PXkKIyBDT05GSUdfUkVHVUxBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVESUFf
U1VQUE9SVCBpcyBub3Qgc2V0CgojCiMgR3JhcGhpY3Mgc3VwcG9ydAojCkNPTkZJR19EUk09eQoj
IENPTkZJR19WR0FTVEFURSBpcyBub3Qgc2V0CkNPTkZJR19WSURFT19PVVRQVVRfQ09OVFJPTD15
CkNPTkZJR19IRE1JPXkKQ09ORklHX0ZCPXkKIyBDT05GSUdfRklSTVdBUkVfRURJRCBpcyBub3Qg
c2V0CiMgQ09ORklHX0ZCX0REQyBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0JPT1RfVkVTQV9TVVBQ
T1JUIGlzIG5vdCBzZXQKQ09ORklHX0ZCX0NGQl9GSUxMUkVDVD15CkNPTkZJR19GQl9DRkJfQ09Q
WUFSRUE9eQpDT05GSUdfRkJfQ0ZCX0lNQUdFQkxJVD15CiMgQ09ORklHX0ZCX0NGQl9SRVZfUElY
RUxTX0lOX0JZVEUgaXMgbm90IHNldApDT05GSUdfRkJfU1lTX0ZJTExSRUNUPXkKQ09ORklHX0ZC
X1NZU19DT1BZQVJFQT15CkNPTkZJR19GQl9TWVNfSU1BR0VCTElUPXkKQ09ORklHX0ZCX0ZPUkVJ
R05fRU5ESUFOPXkKQ09ORklHX0ZCX0JPVEhfRU5ESUFOPXkKIyBDT05GSUdfRkJfQklHX0VORElB
TiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0xJVFRMRV9FTkRJQU4gaXMgbm90IHNldApDT05GSUdf
RkJfU1lTX0ZPUFM9eQpDT05GSUdfRkJfREVGRVJSRURfSU89eQpDT05GSUdfRkJfSEVDVUJBPXkK
IyBDT05GSUdfRkJfU1ZHQUxJQiBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX01BQ01PREVTIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkJfQkFDS0xJR0hUIGlzIG5vdCBzZXQKQ09ORklHX0ZCX01PREVfSEVM
UEVSUz15CkNPTkZJR19GQl9USUxFQkxJVFRJTkc9eQoKIwojIEZyYW1lIGJ1ZmZlciBoYXJkd2Fy
ZSBkcml2ZXJzCiMKQ09ORklHX0ZCX0FSQz15CiMgQ09ORklHX0ZCX1ZHQTE2IGlzIG5vdCBzZXQK
IyBDT05GSUdfRkJfVkVTQSBpcyBub3Qgc2V0CkNPTkZJR19GQl9ONDExPXkKIyBDT05GSUdfRkJf
SEdBIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfT1BFTkNPUkVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
RkJfUzFEMTNYWFggaXMgbm90IHNldAojIENPTkZJR19GQl9UTUlPIGlzIG5vdCBzZXQKQ09ORklH
X0ZCX0dPTERGSVNIPXkKQ09ORklHX0ZCX1ZJUlRVQUw9eQojIENPTkZJR19GQl9NRVRST05PTUUg
aXMgbm90IHNldAojIENPTkZJR19GQl9CUk9BRFNIRUVUIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJf
QVVPX0sxOTBYIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU0lNUExFIGlzIG5vdCBzZXQKQ09ORklH
X0VYWU5PU19WSURFTz15CkNPTkZJR19CQUNLTElHSFRfTENEX1NVUFBPUlQ9eQpDT05GSUdfTENE
X0NMQVNTX0RFVklDRT15CkNPTkZJR19MQ0RfUExBVEZPUk09eQpDT05GSUdfQkFDS0xJR0hUX0NM
QVNTX0RFVklDRT15CkNPTkZJR19CQUNLTElHSFRfR0VORVJJQz15CkNPTkZJR19CQUNLTElHSFRf
UFdNPXkKIyBDT05GSUdfQkFDS0xJR0hUX0RBOTAzWCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tM
SUdIVF9TQUhBUkEgaXMgbm90IHNldApDT05GSUdfQkFDS0xJR0hUX1dNODMxWD15CkNPTkZJR19C
QUNLTElHSFRfQURQNTUyMD15CiMgQ09ORklHX0JBQ0tMSUdIVF9BRFA4ODYwIGlzIG5vdCBzZXQK
Q09ORklHX0JBQ0tMSUdIVF9BRFA4ODcwPXkKQ09ORklHX0JBQ0tMSUdIVF9QQ0Y1MDYzMz15CkNP
TkZJR19CQUNLTElHSFRfTE0zNjMwQT15CkNPTkZJR19CQUNLTElHSFRfTE0zNjM5PXkKQ09ORklH
X0JBQ0tMSUdIVF9MUDg1NVg9eQpDT05GSUdfQkFDS0xJR0hUX1BBTkRPUkE9eQojIENPTkZJR19C
QUNLTElHSFRfVFBTNjUyMTcgaXMgbm90IHNldApDT05GSUdfQkFDS0xJR0hUX0dQSU89eQpDT05G
SUdfQkFDS0xJR0hUX0xWNTIwN0xQPXkKQ09ORklHX0JBQ0tMSUdIVF9CRDYxMDc9eQpDT05GSUdf
TE9HTz15CiMgQ09ORklHX0xPR09fTElOVVhfTU9OTyBpcyBub3Qgc2V0CiMgQ09ORklHX0xPR09f
TElOVVhfVkdBMTYgaXMgbm90IHNldAojIENPTkZJR19MT0dPX0xJTlVYX0NMVVQyMjQgaXMgbm90
IHNldApDT05GSUdfU09VTkQ9eQpDT05GSUdfU09VTkRfT1NTX0NPUkU9eQpDT05GSUdfU09VTkRf
T1NTX0NPUkVfUFJFQ0xBSU09eQojIENPTkZJR19TTkQgaXMgbm90IHNldApDT05GSUdfU09VTkRf
UFJJTUU9eQojIENPTkZJR19TT1VORF9NU05EQ0xBUyBpcyBub3Qgc2V0CkNPTkZJR19TT1VORF9N
U05EUElOPXkKCiMKIyBDb21waWxlZC1pbiBNU05EIFBpbm5hY2xlIHN1cHBvcnQgcmVxdWlyZXMg
ZmlybXdhcmUgZHVyaW5nIGNvbXBpbGF0aW9uLgojCkNPTkZJR19NU05EUElOX0hBVkVfQk9PVD15
CkNPTkZJR19NU05EUElOX0lOSVRfRklMRT0iL2V0Yy9zb3VuZC9wbmRzcGluaS5iaW4iCkNPTkZJ
R19NU05EUElOX1BFUk1fRklMRT0iL2V0Yy9zb3VuZC9wbmRzcGVybS5iaW4iCkNPTkZJR19NU05E
UElOX0lSUT01CkNPTkZJR19NU05EUElOX01FTT1EMDAwMApDT05GSUdfTVNORFBJTl9JTz0yOTAK
IyBDT05GSUdfTVNORFBJTl9ESUdJVEFMIGlzIG5vdCBzZXQKQ09ORklHX01TTkRQSU5fTk9OUE5Q
PXkKCiMKIyBNU05EIFBpbm5hY2xlIERTUCBzZWN0aW9uIHdpbGwgYmUgY29uZmlndXJlZCB0byBh
Ym92ZSBwYXJhbWV0ZXJzLgojCkNPTkZJR19NU05EUElOX0NGRz0yNTAKCiMKIyBQaW5uYWNsZS1z
cGVjaWZpYyBEZXZpY2UgQ29uZmlndXJhdGlvbiAoMCBkaXNhYmxlcykKIwpDT05GSUdfTVNORFBJ
Tl9NUFVfSU89MApDT05GSUdfTVNORFBJTl9NUFVfSVJRPTAKQ09ORklHX01TTkRQSU5fSURFX0lP
MD0wCkNPTkZJR19NU05EUElOX0lERV9JTzE9MApDT05GSUdfTVNORFBJTl9JREVfSVJRPTAKQ09O
RklHX01TTkRQSU5fSk9ZU1RJQ0tfSU89MApDT05GSUdfTVNORF9GSUZPU0laRT0xMjgKIyBDT05G
SUdfU09VTkRfT1NTIGlzIG5vdCBzZXQKCiMKIyBISUQgc3VwcG9ydAojCkNPTkZJR19ISUQ9eQpD
T05GSUdfSElEX0JBVFRFUllfU1RSRU5HVEg9eQojIENPTkZJR19ISURSQVcgaXMgbm90IHNldAoj
IENPTkZJR19VSElEIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9HRU5FUklDPXkKCiMKIyBTcGVjaWFs
IEhJRCBkcml2ZXJzCiMKQ09ORklHX0hJRF9BNFRFQ0g9eQpDT05GSUdfSElEX0FDUlVYPXkKIyBD
T05GSUdfSElEX0FDUlVYX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9BUFBMRT15CkNPTkZJR19I
SURfQVVSRUFMPXkKQ09ORklHX0hJRF9CRUxLSU49eQpDT05GSUdfSElEX0NIRVJSWT15CkNPTkZJ
R19ISURfQ0hJQ09OWT15CiMgQ09ORklHX0hJRF9DWVBSRVNTIGlzIG5vdCBzZXQKQ09ORklHX0hJ
RF9EUkFHT05SSVNFPXkKIyBDT05GSUdfRFJBR09OUklTRV9GRiBpcyBub3Qgc2V0CkNPTkZJR19I
SURfRU1TX0ZGPXkKQ09ORklHX0hJRF9FTEVDT009eQojIENPTkZJR19ISURfRVpLRVkgaXMgbm90
IHNldApDT05GSUdfSElEX0tFWVRPVUNIPXkKQ09ORklHX0hJRF9LWUU9eQpDT05GSUdfSElEX1VD
TE9HSUM9eQojIENPTkZJR19ISURfV0FMVE9QIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9HWVJBVElP
Tj15CkNPTkZJR19ISURfSUNBREU9eQpDT05GSUdfSElEX1RXSU5IQU49eQojIENPTkZJR19ISURf
S0VOU0lOR1RPTiBpcyBub3Qgc2V0CkNPTkZJR19ISURfTENQT1dFUj15CkNPTkZJR19ISURfTEVO
T1ZPX1RQS0JEPXkKIyBDT05GSUdfSElEX0xPR0lURUNIIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9N
QUdJQ01PVVNFPXkKQ09ORklHX0hJRF9NSUNST1NPRlQ9eQpDT05GSUdfSElEX01PTlRFUkVZPXkK
Q09ORklHX0hJRF9NVUxUSVRPVUNIPXkKIyBDT05GSUdfSElEX09SVEVLIGlzIG5vdCBzZXQKQ09O
RklHX0hJRF9QQU5USEVSTE9SRD15CkNPTkZJR19QQU5USEVSTE9SRF9GRj15CkNPTkZJR19ISURf
UEVUQUxZTlg9eQpDT05GSUdfSElEX1BJQ09MQ0Q9eQojIENPTkZJR19ISURfUElDT0xDRF9GQiBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QSUNPTENEX0JBQ0tMSUdIVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0hJRF9QSUNPTENEX0xDRCBpcyBub3Qgc2V0CkNPTkZJR19ISURfUElDT0xDRF9MRURTPXkK
IyBDT05GSUdfSElEX1BSSU1BWCBpcyBub3Qgc2V0CkNPTkZJR19ISURfU0FJVEVLPXkKQ09ORklH
X0hJRF9TQU1TVU5HPXkKQ09ORklHX0hJRF9TUEVFRExJTks9eQojIENPTkZJR19ISURfU1RFRUxT
RVJJRVMgaXMgbm90IHNldApDT05GSUdfSElEX1NVTlBMVVM9eQojIENPTkZJR19ISURfR1JFRU5B
U0lBIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9TTUFSVEpPWVBMVVM9eQojIENPTkZJR19TTUFSVEpP
WVBMVVNfRkYgaXMgbm90IHNldAojIENPTkZJR19ISURfVElWTyBpcyBub3Qgc2V0CkNPTkZJR19I
SURfVE9QU0VFRD15CkNPTkZJR19ISURfVEhJTkdNPXkKQ09ORklHX0hJRF9USFJVU1RNQVNURVI9
eQpDT05GSUdfVEhSVVNUTUFTVEVSX0ZGPXkKQ09ORklHX0hJRF9XQUNPTT15CkNPTkZJR19ISURf
V0lJTU9URT15CiMgQ09ORklHX0hJRF9YSU5NTyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9aRVJP
UExVUyBpcyBub3Qgc2V0CkNPTkZJR19ISURfWllEQUNST049eQpDT05GSUdfSElEX1NFTlNPUl9I
VUI9eQoKIwojIEkyQyBISUQgc3VwcG9ydAojCkNPTkZJR19JMkNfSElEPXkKQ09ORklHX1VTQl9P
SENJX0xJVFRMRV9FTkRJQU49eQojIENPTkZJR19VU0JfU1VQUE9SVCBpcyBub3Qgc2V0CiMgQ09O
RklHX01NQyBpcyBub3Qgc2V0CkNPTkZJR19NRU1TVElDSz15CiMgQ09ORklHX01FTVNUSUNLX0RF
QlVHIGlzIG5vdCBzZXQKCiMKIyBNZW1vcnlTdGljayBkcml2ZXJzCiMKQ09ORklHX01FTVNUSUNL
X1VOU0FGRV9SRVNVTUU9eQoKIwojIE1lbW9yeVN0aWNrIEhvc3QgQ29udHJvbGxlciBEcml2ZXJz
CiMKQ09ORklHX05FV19MRURTPXkKQ09ORklHX0xFRFNfQ0xBU1M9eQoKIwojIExFRCBkcml2ZXJz
CiMKQ09ORklHX0xFRFNfTE0zNTMwPXkKQ09ORklHX0xFRFNfTE0zNjQyPXkKIyBDT05GSUdfTEVE
U19QQ0E5NTMyIGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfR1BJTz15CiMgQ09ORklHX0xFRFNfTFAz
OTQ0IGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfTFA1NVhYX0NPTU1PTj15CiMgQ09ORklHX0xFRFNf
TFA1NTIxIGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfTFA1NTIzPXkKQ09ORklHX0xFRFNfTFA1NTYy
PXkKQ09ORklHX0xFRFNfTFA4NTAxPXkKQ09ORklHX0xFRFNfQ0xFVk9fTUFJTD15CkNPTkZJR19M
RURTX1BDQTk1NVg9eQpDT05GSUdfTEVEU19QQ0E5NjNYPXkKIyBDT05GSUdfTEVEU19QQ0E5Njg1
IGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfV004MzFYX1NUQVRVUz15CkNPTkZJR19MRURTX0RBOTAz
WD15CiMgQ09ORklHX0xFRFNfUFdNIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19CRDI4MDIgaXMg
bm90IHNldApDT05GSUdfTEVEU19MVDM1OTM9eQpDT05GSUdfTEVEU19BRFA1NTIwPXkKIyBDT05G
SUdfTEVEU19NQzEzNzgzIGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfVENBNjUwNz15CkNPTkZJR19M
RURTX0xNMzU1eD15CiMgQ09ORklHX0xFRFNfT1QyMDAgaXMgbm90IHNldAojIENPTkZJR19MRURT
X0JMSU5LTSBpcyBub3Qgc2V0CgojCiMgTEVEIFRyaWdnZXJzCiMKQ09ORklHX0xFRFNfVFJJR0dF
UlM9eQpDT05GSUdfTEVEU19UUklHR0VSX1RJTUVSPXkKIyBDT05GSUdfTEVEU19UUklHR0VSX09O
RVNIT1QgaXMgbm90IHNldAojIENPTkZJR19MRURTX1RSSUdHRVJfSEVBUlRCRUFUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX0JBQ0tMSUdIVCBpcyBub3Qgc2V0CiMgQ09ORklHX0xF
RFNfVFJJR0dFUl9DUFUgaXMgbm90IHNldApDT05GSUdfTEVEU19UUklHR0VSX0dQSU89eQpDT05G
SUdfTEVEU19UUklHR0VSX0RFRkFVTFRfT049eQoKIwojIGlwdGFibGVzIHRyaWdnZXIgaXMgdW5k
ZXIgTmV0ZmlsdGVyIGNvbmZpZyAoTEVEIHRhcmdldCkKIwpDT05GSUdfTEVEU19UUklHR0VSX1RS
QU5TSUVOVD15CkNPTkZJR19MRURTX1RSSUdHRVJfQ0FNRVJBPXkKIyBDT05GSUdfQUNDRVNTSUJJ
TElUWSBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUMgaXMgbm90IHNldApDT05GSUdfUlRDX0xJQj15
CiMgQ09ORklHX1JUQ19DTEFTUyBpcyBub3Qgc2V0CkNPTkZJR19ETUFERVZJQ0VTPXkKIyBDT05G
SUdfRE1BREVWSUNFU19ERUJVRyBpcyBub3Qgc2V0CgojCiMgRE1BIERldmljZXMKIwpDT05GSUdf
RFdfRE1BQ19DT1JFPXkKQ09ORklHX0RXX0RNQUM9eQpDT05GSUdfVElNQl9ETUE9eQpDT05GSUdf
RE1BX0VOR0lORT15CgojCiMgRE1BIENsaWVudHMKIwpDT05GSUdfQVNZTkNfVFhfRE1BPXkKIyBD
T05GSUdfRE1BVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FVWERJU1BMQVkgaXMgbm90IHNldApD
T05GSUdfVUlPPXkKQ09ORklHX1VJT19QRFJWX0dFTklSUT15CkNPTkZJR19VSU9fRE1FTV9HRU5J
UlE9eQpDT05GSUdfVklSVF9EUklWRVJTPXkKQ09ORklHX1ZJUlRJTz15CgojCiMgVmlydGlvIGRy
aXZlcnMKIwpDT05GSUdfVklSVElPX0JBTExPT049eQpDT05GSUdfVklSVElPX01NSU89eQojIENP
TkZJR19WSVJUSU9fTU1JT19DTURMSU5FX0RFVklDRVMgaXMgbm90IHNldAoKIwojIE1pY3Jvc29m
dCBIeXBlci1WIGd1ZXN0IHN1cHBvcnQKIwpDT05GSUdfU1RBR0lORz15CkNPTkZJR19GVDEwMDA9
eQoKIwojIFNwZWFrdXAgY29uc29sZSBzcGVlY2gKIwojIENPTkZJR19UT1VDSFNDUkVFTl9DTEVB
UlBBRF9UTTEyMTcgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9TWU5BUFRJQ1NfSTJD
X1JNSTQgaXMgbm90IHNldApDT05GSUdfU1RBR0lOR19NRURJQT15CgojCiMgQW5kcm9pZAojCiMg
Q09ORklHX0FORFJPSUQgaXMgbm90IHNldApDT05GSUdfR09MREZJU0hfQVVESU89eQojIENPTkZJ
R19NVERfR09MREZJU0hfTkFORCBpcyBub3Qgc2V0CiMgQ09ORklHX0dTX0ZQR0FCT09UIGlzIG5v
dCBzZXQKIyBDT05GSUdfWDg2X1BMQVRGT1JNX0RFVklDRVMgaXMgbm90IHNldAojIENPTkZJR19H
T0xERklTSF9QSVBFIGlzIG5vdCBzZXQKQ09ORklHX0NIUk9NRV9QTEFURk9STVM9eQpDT05GSUdf
Q0hST01FT1NfTEFQVE9QPXkKIyBDT05GSUdfQ0hST01FT1NfUFNUT1JFIGlzIG5vdCBzZXQKCiMK
IyBIYXJkd2FyZSBTcGlubG9jayBkcml2ZXJzCiMKQ09ORklHX0NMS1NSQ19JODI1Mz15CkNPTkZJ
R19DTEtFVlRfSTgyNTM9eQpDT05GSUdfQ0xLQkxEX0k4MjUzPXkKQ09ORklHX01BSUxCT1g9eQoj
IENPTkZJR19JT01NVV9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBSZW1vdGVwcm9jIGRyaXZlcnMK
IwojIENPTkZJR19TVEVfTU9ERU1fUlBST0MgaXMgbm90IHNldAoKIwojIFJwbXNnIGRyaXZlcnMK
IwpDT05GSUdfUE1fREVWRlJFUT15CgojCiMgREVWRlJFUSBHb3Zlcm5vcnMKIwpDT05GSUdfREVW
RlJFUV9HT1ZfU0lNUExFX09OREVNQU5EPXkKIyBDT05GSUdfREVWRlJFUV9HT1ZfUEVSRk9STUFO
Q0UgaXMgbm90IHNldAojIENPTkZJR19ERVZGUkVRX0dPVl9QT1dFUlNBVkUgaXMgbm90IHNldApD
T05GSUdfREVWRlJFUV9HT1ZfVVNFUlNQQUNFPXkKCiMKIyBERVZGUkVRIERyaXZlcnMKIwojIENP
TkZJR19FWFRDT04gaXMgbm90IHNldAojIENPTkZJR19NRU1PUlkgaXMgbm90IHNldAojIENPTkZJ
R19JSU8gaXMgbm90IHNldApDT05GSUdfUFdNPXkKQ09ORklHX1BXTV9TWVNGUz15CiMgQ09ORklH
X1BXTV9MUDM5NDMgaXMgbm90IHNldApDT05GSUdfUFdNX1JFTkVTQVNfVFBVPXkKIyBDT05GSUdf
UFdNX1RXTCBpcyBub3Qgc2V0CiMgQ09ORklHX1BXTV9UV0xfTEVEIGlzIG5vdCBzZXQKQ09ORklH
X0lQQUNLX0JVUz15CiMgQ09ORklHX1JFU0VUX0NPTlRST0xMRVIgaXMgbm90IHNldApDT05GSUdf
Rk1DPXkKQ09ORklHX0ZNQ19GQUtFREVWPXkKQ09ORklHX0ZNQ19UUklWSUFMPXkKQ09ORklHX0ZN
Q19XUklURV9FRVBST009eQpDT05GSUdfRk1DX0NIQVJERVY9eQoKIwojIFBIWSBTdWJzeXN0ZW0K
IwpDT05GSUdfR0VORVJJQ19QSFk9eQpDT05GSUdfUEhZX0VYWU5PU19NSVBJX1ZJREVPPXkKIyBD
T05GSUdfQkNNX0tPTkFfVVNCMl9QSFkgaXMgbm90IHNldApDT05GSUdfUE9XRVJDQVA9eQojIENP
TkZJR19JTlRFTF9SQVBMIGlzIG5vdCBzZXQKQ09ORklHX01DQj15CgojCiMgRmlybXdhcmUgRHJp
dmVycwojCiMgQ09ORklHX0VERCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZJUk1XQVJFX01FTU1BUCBp
cyBub3Qgc2V0CkNPTkZJR19ERUxMX1JCVT15CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CiMg
Q09ORklHX0RNSUlEIGlzIG5vdCBzZXQKQ09ORklHX0RNSV9TWVNGUz15CkNPTkZJR19ETUlfU0NB
Tl9NQUNISU5FX05PTl9FRklfRkFMTEJBQ0s9eQojIENPTkZJR19HT09HTEVfRklSTVdBUkUgaXMg
bm90IHNldAoKIwojIEZpbGUgc3lzdGVtcwojCkNPTkZJR19EQ0FDSEVfV09SRF9BQ0NFU1M9eQoj
IENPTkZJR19GU19QT1NJWF9BQ0wgaXMgbm90IHNldApDT05GSUdfRklMRV9MT0NLSU5HPXkKQ09O
RklHX0ZTTk9USUZZPXkKQ09ORklHX0ROT1RJRlk9eQojIENPTkZJR19JTk9USUZZX1VTRVIgaXMg
bm90IHNldAojIENPTkZJR19GQU5PVElGWSBpcyBub3Qgc2V0CkNPTkZJR19RVU9UQT15CiMgQ09O
RklHX1BSSU5UX1FVT1RBX1dBUk5JTkcgaXMgbm90IHNldApDT05GSUdfUVVPVEFfREVCVUc9eQpD
T05GSUdfUVVPVEFfVFJFRT15CkNPTkZJR19RRk1UX1YxPXkKQ09ORklHX1FGTVRfVjI9eQpDT05G
SUdfUVVPVEFDVEw9eQpDT05GSUdfQVVUT0ZTNF9GUz15CkNPTkZJR19GVVNFX0ZTPXkKIyBDT05G
SUdfQ1VTRSBpcyBub3Qgc2V0CgojCiMgQ2FjaGVzCiMKQ09ORklHX0ZTQ0FDSEU9eQojIENPTkZJ
R19GU0NBQ0hFX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBQc2V1ZG8gZmlsZXN5c3RlbXMKIwojIENP
TkZJR19QUk9DX0ZTIGlzIG5vdCBzZXQKQ09ORklHX0tFUk5GUz15CkNPTkZJR19TWVNGUz15CiMg
Q09ORklHX1RNUEZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSFVHRVRMQkZTIGlzIG5vdCBzZXQKIyBD
T05GSUdfSFVHRVRMQl9QQUdFIGlzIG5vdCBzZXQKQ09ORklHX0NPTkZJR0ZTX0ZTPXkKQ09ORklH
X01JU0NfRklMRVNZU1RFTVM9eQpDT05GSUdfSkZGUzJfRlM9eQpDT05GSUdfSkZGUzJfRlNfREVC
VUc9MAojIENPTkZJR19KRkZTMl9GU19XUklURUJVRkZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0pG
RlMyX1NVTU1BUlkgaXMgbm90IHNldAojIENPTkZJR19KRkZTMl9GU19YQVRUUiBpcyBub3Qgc2V0
CkNPTkZJR19KRkZTMl9DT01QUkVTU0lPTl9PUFRJT05TPXkKQ09ORklHX0pGRlMyX1pMSUI9eQpD
T05GSUdfSkZGUzJfTFpPPXkKIyBDT05GSUdfSkZGUzJfUlRJTUUgaXMgbm90IHNldApDT05GSUdf
SkZGUzJfUlVCSU49eQojIENPTkZJR19KRkZTMl9DTU9ERV9OT05FIGlzIG5vdCBzZXQKQ09ORklH
X0pGRlMyX0NNT0RFX1BSSU9SSVRZPXkKIyBDT05GSUdfSkZGUzJfQ01PREVfU0laRSBpcyBub3Qg
c2V0CiMgQ09ORklHX0pGRlMyX0NNT0RFX0ZBVk9VUkxaTyBpcyBub3Qgc2V0CkNPTkZJR19VQklG
U19GUz15CkNPTkZJR19VQklGU19GU19BRFZBTkNFRF9DT01QUj15CiMgQ09ORklHX1VCSUZTX0ZT
X0xaTyBpcyBub3Qgc2V0CiMgQ09ORklHX1VCSUZTX0ZTX1pMSUIgaXMgbm90IHNldAojIENPTkZJ
R19MT0dGUyBpcyBub3Qgc2V0CkNPTkZJR19ST01GU19GUz15CkNPTkZJR19ST01GU19CQUNLRURf
QllfTVREPXkKQ09ORklHX1JPTUZTX09OX01URD15CiMgQ09ORklHX1BTVE9SRSBpcyBub3Qgc2V0
CkNPTkZJR19OTFM9eQpDT05GSUdfTkxTX0RFRkFVTFQ9Imlzbzg4NTktMSIKIyBDT05GSUdfTkxT
X0NPREVQQUdFXzQzNyBpcyBub3Qgc2V0CkNPTkZJR19OTFNfQ09ERVBBR0VfNzM3PXkKQ09ORklH
X05MU19DT0RFUEFHRV83NzU9eQpDT05GSUdfTkxTX0NPREVQQUdFXzg1MD15CiMgQ09ORklHX05M
U19DT0RFUEFHRV84NTIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODU1IGlzIG5v
dCBzZXQKQ09ORklHX05MU19DT0RFUEFHRV84NTc9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfODYw
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MSBpcyBub3Qgc2V0CkNPTkZJR19O
TFNfQ09ERVBBR0VfODYyPXkKQ09ORklHX05MU19DT0RFUEFHRV84NjM9eQpDT05GSUdfTkxTX0NP
REVQQUdFXzg2ND15CkNPTkZJR19OTFNfQ09ERVBBR0VfODY1PXkKQ09ORklHX05MU19DT0RFUEFH
RV84NjY9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfODY5IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0NPREVQQUdFXzkzNiBpcyBub3Qgc2V0CkNPTkZJR19OTFNfQ09ERVBBR0VfOTUwPXkKQ09ORklH
X05MU19DT0RFUEFHRV85MzI9eQojIENPTkZJR19OTFNfQ09ERVBBR0VfOTQ5IGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0NPREVQQUdFXzg3NCBpcyBub3Qgc2V0CkNPTkZJR19OTFNfSVNPODg1OV84
PXkKIyBDT05GSUdfTkxTX0NPREVQQUdFXzEyNTAgaXMgbm90IHNldApDT05GSUdfTkxTX0NPREVQ
QUdFXzEyNTE9eQpDT05GSUdfTkxTX0FTQ0lJPXkKIyBDT05GSUdfTkxTX0lTTzg4NTlfMSBpcyBu
b3Qgc2V0CkNPTkZJR19OTFNfSVNPODg1OV8yPXkKQ09ORklHX05MU19JU084ODU5XzM9eQpDT05G
SUdfTkxTX0lTTzg4NTlfND15CiMgQ09ORklHX05MU19JU084ODU5XzUgaXMgbm90IHNldApDT05G
SUdfTkxTX0lTTzg4NTlfNj15CkNPTkZJR19OTFNfSVNPODg1OV83PXkKIyBDT05GSUdfTkxTX0lT
Tzg4NTlfOSBpcyBub3Qgc2V0CkNPTkZJR19OTFNfSVNPODg1OV8xMz15CiMgQ09ORklHX05MU19J
U084ODU5XzE0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTUgaXMgbm90IHNldApD
T05GSUdfTkxTX0tPSThfUj15CiMgQ09ORklHX05MU19LT0k4X1UgaXMgbm90IHNldApDT05GSUdf
TkxTX01BQ19ST01BTj15CiMgQ09ORklHX05MU19NQUNfQ0VMVElDIGlzIG5vdCBzZXQKQ09ORklH
X05MU19NQUNfQ0VOVEVVUk89eQpDT05GSUdfTkxTX01BQ19DUk9BVElBTj15CiMgQ09ORklHX05M
U19NQUNfQ1lSSUxMSUMgaXMgbm90IHNldAojIENPTkZJR19OTFNfTUFDX0dBRUxJQyBpcyBub3Qg
c2V0CkNPTkZJR19OTFNfTUFDX0dSRUVLPXkKIyBDT05GSUdfTkxTX01BQ19JQ0VMQU5EIGlzIG5v
dCBzZXQKQ09ORklHX05MU19NQUNfSU5VSVQ9eQpDT05GSUdfTkxTX01BQ19ST01BTklBTj15CiMg
Q09ORklHX05MU19NQUNfVFVSS0lTSCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19VVEY4IGlzIG5v
dCBzZXQKCiMKIyBLZXJuZWwgaGFja2luZwojCkNPTkZJR19UUkFDRV9JUlFGTEFHU19TVVBQT1JU
PXkKCiMKIyBwcmludGsgYW5kIGRtZXNnIG9wdGlvbnMKIwpDT05GSUdfREVGQVVMVF9NRVNTQUdF
X0xPR0xFVkVMPTQKCiMKIyBDb21waWxlLXRpbWUgY2hlY2tzIGFuZCBjb21waWxlciBvcHRpb25z
CiMKIyBDT05GSUdfRU5BQkxFX1dBUk5fREVQUkVDQVRFRCBpcyBub3Qgc2V0CkNPTkZJR19FTkFC
TEVfTVVTVF9DSEVDSz15CkNPTkZJR19GUkFNRV9XQVJOPTEwMjQKQ09ORklHX1NUUklQX0FTTV9T
WU1TPXkKIyBDT05GSUdfUkVBREFCTEVfQVNNIGlzIG5vdCBzZXQKIyBDT05GSUdfVU5VU0VEX1NZ
TUJPTFMgaXMgbm90IHNldApDT05GSUdfREVCVUdfRlM9eQpDT05GSUdfSEVBREVSU19DSEVDSz15
CiMgQ09ORklHX0RFQlVHX1NFQ1RJT05fTUlTTUFUQ0ggaXMgbm90IHNldApDT05GSUdfQVJDSF9X
QU5UX0ZSQU1FX1BPSU5URVJTPXkKQ09ORklHX0ZSQU1FX1BPSU5URVI9eQojIENPTkZJR19ERUJV
R19GT1JDRV9XRUFLX1BFUl9DUFUgaXMgbm90IHNldApDT05GSUdfTUFHSUNfU1lTUlE9eQpDT05G
SUdfTUFHSUNfU1lTUlFfREVGQVVMVF9FTkFCTEU9MHgxCkNPTkZJR19ERUJVR19LRVJORUw9eQoK
IwojIE1lbW9yeSBEZWJ1Z2dpbmcKIwpDT05GSUdfREVCVUdfUEFHRUFMTE9DPXkKQ09ORklHX1dB
TlRfUEFHRV9ERUJVR19GTEFHUz15CkNPTkZJR19QQUdFX0dVQVJEPXkKIyBDT05GSUdfREVCVUdf
T0JKRUNUUyBpcyBub3Qgc2V0CkNPTkZJR19TTFVCX1NUQVRTPXkKQ09ORklHX0hBVkVfREVCVUdf
S01FTUxFQUs9eQojIENPTkZJR19ERUJVR19LTUVNTEVBSyBpcyBub3Qgc2V0CkNPTkZJR19ERUJV
R19TVEFDS19VU0FHRT15CkNPTkZJR19ERUJVR19WTT15CiMgQ09ORklHX0RFQlVHX1ZNX1JCIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfVklSVFVBTCBpcyBub3Qgc2V0CkNPTkZJR19ERUJVR19N
RU1PUllfSU5JVD15CkNPTkZJR19ERUJVR19ISUdITUVNPXkKQ09ORklHX0hBVkVfREVCVUdfU1RB
Q0tPVkVSRkxPVz15CiMgQ09ORklHX0RFQlVHX1NUQUNLT1ZFUkZMT1cgaXMgbm90IHNldApDT05G
SUdfSEFWRV9BUkNIX0tNRU1DSEVDSz15CiMgQ09ORklHX0tNRU1DSEVDSyBpcyBub3Qgc2V0CkNP
TkZJR19ERUJVR19TSElSUT15CgojCiMgRGVidWcgTG9ja3VwcyBhbmQgSGFuZ3MKIwpDT05GSUdf
TE9DS1VQX0RFVEVDVE9SPXkKQ09ORklHX0hBUkRMT0NLVVBfREVURUNUT1I9eQojIENPTkZJR19C
T09UUEFSQU1fSEFSRExPQ0tVUF9QQU5JQyBpcyBub3Qgc2V0CkNPTkZJR19CT09UUEFSQU1fSEFS
RExPQ0tVUF9QQU5JQ19WQUxVRT0wCiMgQ09ORklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklD
IGlzIG5vdCBzZXQKQ09ORklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklDX1ZBTFVFPTAKQ09O
RklHX0RFVEVDVF9IVU5HX1RBU0s9eQpDT05GSUdfREVGQVVMVF9IVU5HX1RBU0tfVElNRU9VVD0x
MjAKQ09ORklHX0JPT1RQQVJBTV9IVU5HX1RBU0tfUEFOSUM9eQpDT05GSUdfQk9PVFBBUkFNX0hV
TkdfVEFTS19QQU5JQ19WQUxVRT0xCiMgQ09ORklHX1BBTklDX09OX09PUFMgaXMgbm90IHNldApD
T05GSUdfUEFOSUNfT05fT09QU19WQUxVRT0wCkNPTkZJR19QQU5JQ19USU1FT1VUPTAKCiMKIyBM
b2NrIERlYnVnZ2luZyAoc3BpbmxvY2tzLCBtdXRleGVzLCBldGMuLi4pCiMKIyBDT05GSUdfREVC
VUdfUlRfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUX01VVEVYX1RFU1RFUiBpcyBub3Qg
c2V0CkNPTkZJR19ERUJVR19TUElOTE9DSz15CkNPTkZJR19ERUJVR19NVVRFWEVTPXkKQ09ORklH
X0RFQlVHX1dXX01VVEVYX1NMT1dQQVRIPXkKQ09ORklHX0RFQlVHX0xPQ0tfQUxMT0M9eQpDT05G
SUdfUFJPVkVfTE9DS0lORz15CkNPTkZJR19MT0NLREVQPXkKIyBDT05GSUdfTE9DS19TVEFUIGlz
IG5vdCBzZXQKQ09ORklHX0RFQlVHX0xPQ0tERVA9eQpDT05GSUdfREVCVUdfQVRPTUlDX1NMRUVQ
PXkKQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUz15CiMgQ09ORklHX0xPQ0tfVE9S
VFVSRV9URVNUIGlzIG5vdCBzZXQKQ09ORklHX1RSQUNFX0lSUUZMQUdTPXkKQ09ORklHX1NUQUNL
VFJBQ0U9eQojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdf
QlVHVkVSQk9TRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1dSSVRFQ09VTlQgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19MSVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU0cgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19OT1RJRklFUlMgaXMgbm90IHNldApDT05GSUdfREVCVUdfQ1JF
REVOVElBTFM9eQoKIwojIFJDVSBEZWJ1Z2dpbmcKIwpDT05GSUdfUFJPVkVfUkNVPXkKQ09ORklH
X1BST1ZFX1JDVV9SRVBFQVRFRExZPXkKIyBDT05GSUdfU1BBUlNFX1JDVV9QT0lOVEVSIGlzIG5v
dCBzZXQKQ09ORklHX1RPUlRVUkVfVEVTVD15CkNPTkZJR19SQ1VfVE9SVFVSRV9URVNUPXkKIyBD
T05GSUdfUkNVX1RPUlRVUkVfVEVTVF9SVU5OQUJMRSBpcyBub3Qgc2V0CiMgQ09ORklHX1JDVV9U
UkFDRSBpcyBub3Qgc2V0CkNPTkZJR19OT1RJRklFUl9FUlJPUl9JTkpFQ1RJT049eQpDT05GSUdf
UE1fTk9USUZJRVJfRVJST1JfSU5KRUNUPXkKQ09ORklHX0ZBVUxUX0lOSkVDVElPTj15CiMgQ09O
RklHX0ZBSUxTTEFCIGlzIG5vdCBzZXQKQ09ORklHX0ZBSUxfUEFHRV9BTExPQz15CkNPTkZJR19G
QVVMVF9JTkpFQ1RJT05fREVCVUdfRlM9eQpDT05GSUdfRkFVTFRfSU5KRUNUSU9OX1NUQUNLVFJB
Q0VfRklMVEVSPXkKQ09ORklHX0FSQ0hfSEFTX0RFQlVHX1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tT
PXkKQ09ORklHX0RFQlVHX1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tTPXkKQ09ORklHX1VTRVJfU1RB
Q0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkKQ09ORklHX0hB
VkVfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfRlBf
VEVTVD15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFX01DT1VOVF9URVNUPXkKQ09ORklHX0hB
VkVfRFlOQU1JQ19GVFJBQ0U9eQpDT05GSUdfSEFWRV9EWU5BTUlDX0ZUUkFDRV9XSVRIX1JFR1M9
eQpDT05GSUdfSEFWRV9GVFJBQ0VfTUNPVU5UX1JFQ09SRD15CkNPTkZJR19IQVZFX1NZU0NBTExf
VFJBQ0VQT0lOVFM9eQpDT05GSUdfSEFWRV9DX1JFQ09SRE1DT1VOVD15CkNPTkZJR19UUkFDSU5H
X1NVUFBPUlQ9eQojIENPTkZJR19GVFJBQ0UgaXMgbm90IHNldAoKIwojIFJ1bnRpbWUgVGVzdGlu
ZwojCkNPTkZJR19URVNUX0xJU1RfU09SVD15CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1Qg
aXMgbm90IHNldAojIENPTkZJR19SQlRSRUVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUT01J
QzY0X1NFTEZURVNUIGlzIG5vdCBzZXQKQ09ORklHX1RFU1RfU1RSSU5HX0hFTFBFUlM9eQojIENP
TkZJR19URVNUX0tTVFJUT1ggaXMgbm90IHNldApDT05GSUdfQlVJTERfRE9DU1JDPXkKQ09ORklH
X0RNQV9BUElfREVCVUc9eQojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVf
QVJDSF9LR0RCPXkKQ09ORklHX0tHREI9eQojIENPTkZJR19LR0RCX1RFU1RTIGlzIG5vdCBzZXQK
IyBDT05GSUdfS0dEQl9MT1dfTEVWRUxfVFJBUCBpcyBub3Qgc2V0CkNPTkZJR19LR0RCX0tEQj15
CkNPTkZJR19LREJfQ09OVElOVUVfQ0FUQVNUUk9QSElDPTAKIyBDT05GSUdfU1RSSUNUX0RFVk1F
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9WRVJCT1NFX0JPT1RVUCBpcyBub3Qgc2V0CkNPTkZJ
R19FQVJMWV9QUklOVEs9eQojIENPTkZJR19YODZfUFREVU1QIGlzIG5vdCBzZXQKQ09ORklHX0RF
QlVHX1JPREFUQT15CkNPTkZJR19ERUJVR19ST0RBVEFfVEVTVD15CkNPTkZJR19ET1VCTEVGQVVM
VD15CkNPTkZJR19ERUJVR19UTEJGTFVTSD15CkNPTkZJR19JT01NVV9TVFJFU1M9eQpDT05GSUdf
SEFWRV9NTUlPVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19JT19ERUxBWV9UWVBFXzBYODA9MApDT05G
SUdfSU9fREVMQVlfVFlQRV8wWEVEPTEKQ09ORklHX0lPX0RFTEFZX1RZUEVfVURFTEFZPTIKQ09O
RklHX0lPX0RFTEFZX1RZUEVfTk9ORT0zCkNPTkZJR19JT19ERUxBWV8wWDgwPXkKIyBDT05GSUdf
SU9fREVMQVlfMFhFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0lPX0RFTEFZX1VERUxBWSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lPX0RFTEFZX05PTkUgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9JT19E
RUxBWV9UWVBFPTAKQ09ORklHX0RFQlVHX0JPT1RfUEFSQU1TPXkKQ09ORklHX0NQQV9ERUJVRz15
CiMgQ09ORklHX09QVElNSVpFX0lOTElOSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTk1J
X1NFTEZURVNUIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9ERUJVR19TVEFUSUNfQ1BVX0hBUz15Cgoj
CiMgU2VjdXJpdHkgb3B0aW9ucwojCiMgQ09ORklHX0tFWVMgaXMgbm90IHNldApDT05GSUdfU0VD
VVJJVFlfRE1FU0dfUkVTVFJJQ1Q9eQojIENPTkZJR19TRUNVUklUWSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFQ1VSSVRZRlMgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9TRUNVUklUWV9EQUM9eQpD
T05GSUdfREVGQVVMVF9TRUNVUklUWT0iIgpDT05GSUdfQ1JZUFRPPXkKCiMKIyBDcnlwdG8gY29y
ZSBvciBoZWxwZXIKIwojIENPTkZJR19DUllQVE9fRklQUyBpcyBub3Qgc2V0CkNPTkZJR19DUllQ
VE9fQUxHQVBJPXkKQ09ORklHX0NSWVBUT19BTEdBUEkyPXkKQ09ORklHX0NSWVBUT19BRUFEPXkK
Q09ORklHX0NSWVBUT19BRUFEMj15CkNPTkZJR19DUllQVE9fQkxLQ0lQSEVSPXkKQ09ORklHX0NS
WVBUT19CTEtDSVBIRVIyPXkKQ09ORklHX0NSWVBUT19IQVNIPXkKQ09ORklHX0NSWVBUT19IQVNI
Mj15CkNPTkZJR19DUllQVE9fUk5HPXkKQ09ORklHX0NSWVBUT19STkcyPXkKQ09ORklHX0NSWVBU
T19QQ09NUDI9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVI9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVIy
PXkKIyBDT05GSUdfQ1JZUFRPX01BTkFHRVJfRElTQUJMRV9URVNUUyBpcyBub3Qgc2V0CkNPTkZJ
R19DUllQVE9fR0YxMjhNVUw9eQpDT05GSUdfQ1JZUFRPX05VTEw9eQpDT05GSUdfQ1JZUFRPX1dP
UktRVUVVRT15CkNPTkZJR19DUllQVE9fQ1JZUFREPXkKIyBDT05GSUdfQ1JZUFRPX0FVVEhFTkMg
aXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0FCTEtfSEVMUEVSPXkKCiMKIyBBdXRoZW50aWNhdGVk
IEVuY3J5cHRpb24gd2l0aCBBc3NvY2lhdGVkIERhdGEKIwojIENPTkZJR19DUllQVE9fQ0NNIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0dDTSBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fU0VR
SVY9eQoKIwojIEJsb2NrIG1vZGVzCiMKQ09ORklHX0NSWVBUT19DQkM9eQpDT05GSUdfQ1JZUFRP
X0NUUj15CkNPTkZJR19DUllQVE9fQ1RTPXkKIyBDT05GSUdfQ1JZUFRPX0VDQiBpcyBub3Qgc2V0
CkNPTkZJR19DUllQVE9fTFJXPXkKQ09ORklHX0NSWVBUT19QQ0JDPXkKQ09ORklHX0NSWVBUT19Y
VFM9eQoKIwojIEhhc2ggbW9kZXMKIwojIENPTkZJR19DUllQVE9fQ01BQyBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19ITUFDIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19YQ0JDPXkKQ09ORklH
X0NSWVBUT19WTUFDPXkKCiMKIyBEaWdlc3QKIwpDT05GSUdfQ1JZUFRPX0NSQzMyQz15CkNPTkZJ
R19DUllQVE9fQ1JDMzJDX0lOVEVMPXkKQ09ORklHX0NSWVBUT19DUkMzMj15CiMgQ09ORklHX0NS
WVBUT19DUkMzMl9QQ0xNVUwgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX0NSQ1QxMERJRj15CkNP
TkZJR19DUllQVE9fR0hBU0g9eQpDT05GSUdfQ1JZUFRPX01END15CiMgQ09ORklHX0NSWVBUT19N
RDUgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fTUlDSEFFTF9NSUMgaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fUk1EMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1JNRDE2MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19STUQyNTYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
Uk1EMzIwIGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19TSEExPXkKQ09ORklHX0NSWVBUT19TSEEy
NTY9eQpDT05GSUdfQ1JZUFRPX1NIQTUxMj15CiMgQ09ORklHX0NSWVBUT19UR1IxOTIgaXMgbm90
IHNldApDT05GSUdfQ1JZUFRPX1dQNTEyPXkKCiMKIyBDaXBoZXJzCiMKQ09ORklHX0NSWVBUT19B
RVM9eQpDT05GSUdfQ1JZUFRPX0FFU181ODY9eQpDT05GSUdfQ1JZUFRPX0FFU19OSV9JTlRFTD15
CkNPTkZJR19DUllQVE9fQU5VQklTPXkKQ09ORklHX0NSWVBUT19BUkM0PXkKQ09ORklHX0NSWVBU
T19CTE9XRklTSD15CkNPTkZJR19DUllQVE9fQkxPV0ZJU0hfQ09NTU9OPXkKQ09ORklHX0NSWVBU
T19DQU1FTExJQT15CkNPTkZJR19DUllQVE9fQ0FTVF9DT01NT049eQpDT05GSUdfQ1JZUFRPX0NB
U1Q1PXkKQ09ORklHX0NSWVBUT19DQVNUNj15CiMgQ09ORklHX0NSWVBUT19ERVMgaXMgbm90IHNl
dApDT05GSUdfQ1JZUFRPX0ZDUllQVD15CkNPTkZJR19DUllQVE9fS0hBWkFEPXkKQ09ORklHX0NS
WVBUT19TQUxTQTIwPXkKQ09ORklHX0NSWVBUT19TQUxTQTIwXzU4Nj15CiMgQ09ORklHX0NSWVBU
T19TRUVEIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFUlBFTlQgaXMgbm90IHNldAojIENP
TkZJR19DUllQVE9fU0VSUEVOVF9TU0UyXzU4NiBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fVEVB
PXkKIyBDT05GSUdfQ1JZUFRPX1RXT0ZJU0ggaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1RXT0ZJ
U0hfQ09NTU9OPXkKQ09ORklHX0NSWVBUT19UV09GSVNIXzU4Nj15CgojCiMgQ29tcHJlc3Npb24K
IwojIENPTkZJR19DUllQVE9fREVGTEFURSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19aTElC
IGlzIG5vdCBzZXQKQ09ORklHX0NSWVBUT19MWk89eQpDT05GSUdfQ1JZUFRPX0xaND15CkNPTkZJ
R19DUllQVE9fTFo0SEM9eQoKIwojIFJhbmRvbSBOdW1iZXIgR2VuZXJhdGlvbgojCkNPTkZJR19D
UllQVE9fQU5TSV9DUFJORz15CiMgQ09ORklHX0NSWVBUT19IVyBpcyBub3Qgc2V0CkNPTkZJR19I
QVZFX0tWTT15CkNPTkZJR19WSVJUVUFMSVpBVElPTj15CiMgQ09ORklHX0JJTkFSWV9QUklOVEYg
aXMgbm90IHNldAoKIwojIExpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfQklUUkVWRVJTRT15CkNP
TkZJR19HRU5FUklDX1NUUk5DUFlfRlJPTV9VU0VSPXkKQ09ORklHX0dFTkVSSUNfU1RSTkxFTl9V
U0VSPXkKQ09ORklHX0dFTkVSSUNfRklORF9GSVJTVF9CSVQ9eQpDT05GSUdfR0VORVJJQ19QQ0lf
SU9NQVA9eQpDT05GSUdfR0VORVJJQ19JT01BUD15CkNPTkZJR19HRU5FUklDX0lPPXkKQ09ORklH
X0NSQ19DQ0lUVD15CkNPTkZJR19DUkMxNj15CkNPTkZJR19DUkNfVDEwRElGPXkKIyBDT05GSUdf
Q1JDX0lUVV9UIGlzIG5vdCBzZXQKQ09ORklHX0NSQzMyPXkKIyBDT05GSUdfQ1JDMzJfU0VMRlRF
U1QgaXMgbm90IHNldApDT05GSUdfQ1JDMzJfU0xJQ0VCWTg9eQojIENPTkZJR19DUkMzMl9TTElD
RUJZNCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQzMyX1NBUldBVEUgaXMgbm90IHNldAojIENPTkZJ
R19DUkMzMl9CSVQgaXMgbm90IHNldApDT05GSUdfQ1JDNz15CiMgQ09ORklHX0xJQkNSQzMyQyBp
cyBub3Qgc2V0CkNPTkZJR19DUkM4PXkKQ09ORklHX0NSQzY0X0VDTUE9eQpDT05GSUdfUkFORE9N
MzJfU0VMRlRFU1Q9eQpDT05GSUdfWkxJQl9JTkZMQVRFPXkKQ09ORklHX1pMSUJfREVGTEFURT15
CkNPTkZJR19MWk9fQ09NUFJFU1M9eQpDT05GSUdfTFpPX0RFQ09NUFJFU1M9eQpDT05GSUdfTFo0
X0NPTVBSRVNTPXkKQ09ORklHX0xaNEhDX0NPTVBSRVNTPXkKQ09ORklHX0xaNF9ERUNPTVBSRVNT
PXkKIyBDT05GSUdfWFpfREVDIGlzIG5vdCBzZXQKIyBDT05GSUdfWFpfREVDX0JDSiBpcyBub3Qg
c2V0CkNPTkZJR19HRU5FUklDX0FMTE9DQVRPUj15CkNPTkZJR19CQ0g9eQpDT05GSUdfQkNIX0NP
TlNUX1BBUkFNUz15CkNPTkZJR19IQVNfSU9NRU09eQpDT05GSUdfSEFTX0lPUE9SVF9NQVA9eQpD
T05GSUdfSEFTX0RNQT15CkNPTkZJR19DSEVDS19TSUdOQVRVUkU9eQpDT05GSUdfQVJDSF9IQVNf
QVRPTUlDNjRfREVDX0lGX1BPU0lUSVZFPXkKIyBDT05GSUdfQVZFUkFHRSBpcyBub3Qgc2V0CiMg
Q09ORklHX0NPUkRJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0REUiBpcyBub3Qgc2V0Cg==
--089e0163434e829e3604f3b52470--
