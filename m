Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3IPJQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:16:08 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1190 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab3IPJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:16:06 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <5236CC49.7000206@broadcom.com>
Date: Mon, 16 Sep 2013 11:15:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Fengguang Wu" <fengguang.wu@intel.com>
cc: "Hante Meuleman" <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com
Subject: Re: [brcmfmac] BUG: unable to handle kernel paging request at
 ffffffff82196446
References: <20130902102327.GB14264@localhost>
In-Reply-To: <20130902102327.GB14264@localhost>
X-WSS-ID: 7E2816592L885076152-01-01
Content-Type: multipart/mixed;
 boundary=------------030703020205050901000101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------030703020205050901000101
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2013 12:23 PM, Fengguang Wu wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is

Hi Fengguang,

I could not reproduce this issue. Could you retest with the attached 
patch file applied and let me know if that fixes the problem?

Regards,
Arend

> commit 668761ac01d6f5a36b8e5a24d4e154550e2c4c3b
> Author: Hante Meuleman <meuleman@broadcom.com>
> Date:   Fri Apr 12 10:55:55 2013 +0200
>
>      brcmfmac: define and use platform specific data for SDIO.
>
>      This patch adds support for platform specific data for SDIO
>      fullmac devices. Currently OOB interrupts are configured by Kconfig
>      BRCMFMAC_SDIO_OOB but that is now determined dynamically by checking
>      availibility of platform data.
>
>      Cc: Hauke Mehrtens <hauke@hauke-m.de>
>      Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>      Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>      Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>      Reviewed-by: Piotr Haber <phaber@broadcom.com>
>      Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>      Signed-off-by: Arend van Spriel <arend@broadcom.com>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
>
> [   48.966342] Switched to clocksource tsc
> [   48.970002] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> [   48.970851] BUG: unable to handle kernel paging request at ffffffff82196446
> [   48.970957] IP: [<ffffffff82196446>] classes_init+0x26/0x26
> [   48.970957] PGD 1e76067 PUD 1e77063 PMD f388063 PTE 8000000002196163
> [   48.970957] Oops: 0011 [#1]
> [   48.970957] CPU: 0 PID: 17 Comm: kworker/0:1 Not tainted 3.11.0-rc7-00444-gc52dd7f #23
> [   48.970957] Workqueue: events brcmf_driver_init
> [   48.970957] task: ffff8800001d2000 ti: ffff8800001d4000 task.ti: ffff8800001d4000
> [   48.970957] RIP: 0010:[<ffffffff82196446>]  [<ffffffff82196446>] classes_init+0x26/0x26
> [   48.970957] RSP: 0000:ffff8800001d5d40  EFLAGS: 00000286
> [   48.970957] RAX: 0000000000000001 RBX: ffffffff820c5620 RCX: 0000000000000000
> [   48.970957] RDX: 0000000000000001 RSI: ffffffff816f7380 RDI: ffffffff820c56c0
> [   48.970957] RBP: ffff8800001d5d50 R08: ffff8800001d2508 R09: 0000000000000002
> [   48.970957] R10: 0000000000000000 R11: 0001f7ce298c5620 R12: ffff8800001c76b0
> [   48.970957] R13: ffffffff81e91d40 R14: 0000000000000000 R15: ffff88000e0ce300
> [   48.970957] FS:  0000000000000000(0000) GS:ffffffff81e84000(0000) knlGS:0000000000000000
> [   48.970957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   48.970957] CR2: ffffffff82196446 CR3: 0000000001e75000 CR4: 00000000000006b0
> [   48.970957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   48.970957] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [   48.970957] Stack:
> [   48.970957]  ffffffff816f7df8 ffffffff820c5620 ffff8800001d5d60 ffffffff816eeec9
> [   48.970957]  ffff8800001d5de0 ffffffff81073dc5 ffffffff81073d68 ffff8800001d5db8
> [   48.970957]  0000000000000086 ffffffff820c5620 ffffffff824f7fd0 0000000000000000
> [   48.970957] Call Trace:
> [   48.970957]  [<ffffffff816f7df8>] ? brcmf_sdio_init+0x18/0x70
> [   48.970957]  [<ffffffff816eeec9>] brcmf_driver_init+0x9/0x10
> [   48.970957]  [<ffffffff81073dc5>] process_one_work+0x1d5/0x480
> [   48.970957]  [<ffffffff81073d68>] ? process_one_work+0x178/0x480
> [   48.970957]  [<ffffffff81074188>] worker_thread+0x118/0x3a0
> [   48.970957]  [<ffffffff81074070>] ? process_one_work+0x480/0x480
> [   48.970957]  [<ffffffff8107aa17>] kthread+0xe7/0xf0
> [   48.970957]  [<ffffffff810829f7>] ? finish_task_switch.constprop.57+0x37/0xd0
> [   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
> [   48.970957]  [<ffffffff81a6923a>] ret_from_fork+0x7a/0xb0
> [   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
> [   48.970957] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> [   48.970957] RIP  [<ffffffff82196446>] classes_init+0x26/0x26
> [   48.970957]  RSP <ffff8800001d5d40>
> [   48.970957] CR2: ffffffff82196446
> [   48.970957] ---[ end trace 62980817cd525f14 ]---
>
> git bisect start v3.10 v3.9 --
> git bisect  bad 20b4fb485227404329e41ad15588afad3df23050  # 12:16      9-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect good 19b344efa35dbc253e2d10403dafe6aafda73c56  # 17:54    800+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
> git bisect  bad 20074f357da4a637430aec2879c9d864c5d2c23c  # 18:03      1-  filter: fix va_list build error
> git bisect good 953c96e0d85615d1ab1f100e525d376053294dc2  # 21:38    800+  tg3: Use bool not int
> git bisect  bad 4de41bef3e075dbc787f7c53b3562f23295f1d6d  # 22:21    102-  wil6210: Use cached copy of Tx descriptor
> git bisect good e73dcfbf061b524fe9aaef56cf3c2e234a45ec19  # 01:19    800+  Bluetooth: hidp: fix sending output reports on intr channel
> git bisect good c79490e1b5ebf35415147fe06f02d8e77ccfe6d4  # 07:18    800+  NFC: pn533: Avoid function declarations
> git bisect  bad 06d961a8e210035bff7e82f466107f9ab4a8fd94  # 07:49     55-  mac80211/minstrel: use the new rate control API
> git bisect good 97990a060e6757f48b931a3946b17c1c4362c3fb  # 10:43    800+  nl80211: allow using wdev identifiers to get scan results
> git bisect  bad 31ed07dc1e83b7926ce8ee2215ea21599a215990  # 11:15     77-  brcmfmac: remove ifidx variable from brcmf_fws_process_skb()
> git bisect good 1e9ab4dd258ecbb0f1c377fd4dbe227cdb93d9bd  # 14:16    800+  brcmfmac: setup SDIO reset behavior
> git bisect  bad 668761ac01d6f5a36b8e5a24d4e154550e2c4c3b  # 15:03     38-  brcmfmac: define and use platform specific data for SDIO.
> git bisect good 369508c5656db290f09b32d213effeea6c1431b8  # 18:30    800+  brcmfmac: Add 43143 SDIO support.
> git bisect good 979c29205ffa607c59ba2c9f9c083b967d356c97  # 19:54    800+  brcmfmac: Add drive strength programming for SDIO 43143.
> git bisect good 979c29205ffa607c59ba2c9f9c083b967d356c97  # 05:19   2400+  brcmfmac: Add drive strength programming for SDIO 43143.
> git bisect  bad c52dd7f94c5d5386413cb95462ac802847fa5f3a  # 05:20      0-  Merge remote-tracking branch 'sound/for-linus' into devel-cairo-x86_64-201308281454
> git bisect  bad d9eda0fae1394ea1e1c59c94d4a120ad9c06e64a  # 11:50     27-  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect  bad 797c8d18e6804f054e68555e6cf827827b6a073c  # 12:47      1-  Add linux-next specific files for 20130830
>
> Thanks,
> Fengguang
>


--------------030703020205050901000101
Content-Type: text/plain;
 name=0001-brcmfmac-obtain-platform-data-upon-module-initializa.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0=0001-brcmfmac-obtain-platform-data-upon-module-initializa.pa;
 filename*1=tch

>From f2d01b847944dc329ed4fd420acb270319dc853d Mon Sep 17 00:00:00 2001
From: Arend van Spriel <arend@broadcom.com>
Date: Fri, 13 Sep 2013 15:36:05 +0200
Subject: [PATCH] brcmfmac: obtain platform data upon module initialization

The driver uses platform_driver_probe() to obtain platform data
if any. However, that function is placed in the .init section so
it must be called upon driver module initialization.

The problem was reported by Fenguang Wu resulting in a kernel
oops because the .init section was already freed.

[   48.966342] Switched to clocksource tsc
[   48.970002] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[   48.970851] BUG: unable to handle kernel paging request at ffffffff82196446
[   48.970957] IP: [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] PGD 1e76067 PUD 1e77063 PMD f388063 PTE 8000000002196163
[   48.970957] Oops: 0011 [#1]
[   48.970957] CPU: 0 PID: 17 Comm: kworker/0:1 Not tainted 3.11.0-rc7-00444-gc52dd7f #23
[   48.970957] Workqueue: events brcmf_driver_init
[   48.970957] task: ffff8800001d2000 ti: ffff8800001d4000 task.ti: ffff8800001d4000
[   48.970957] RIP: 0010:[<ffffffff82196446>]  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957] RSP: 0000:ffff8800001d5d40  EFLAGS: 00000286
[   48.970957] RAX: 0000000000000001 RBX: ffffffff820c5620 RCX: 0000000000000000
[   48.970957] RDX: 0000000000000001 RSI: ffffffff816f7380 RDI: ffffffff820c56c0
[   48.970957] RBP: ffff8800001d5d50 R08: ffff8800001d2508 R09: 0000000000000002
[   48.970957] R10: 0000000000000000 R11: 0001f7ce298c5620 R12: ffff8800001c76b0
[   48.970957] R13: ffffffff81e91d40 R14: 0000000000000000 R15: ffff88000e0ce300
[   48.970957] FS:  0000000000000000(0000) GS:ffffffff81e84000(0000) knlGS:0000000000000000
[   48.970957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   48.970957] CR2: ffffffff82196446 CR3: 0000000001e75000 CR4: 00000000000006b0
[   48.970957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.970957] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   48.970957] Stack:
[   48.970957]  ffffffff816f7df8 ffffffff820c5620 ffff8800001d5d60 ffffffff816eeec9
[   48.970957]  ffff8800001d5de0 ffffffff81073dc5 ffffffff81073d68 ffff8800001d5db8
[   48.970957]  0000000000000086 ffffffff820c5620 ffffffff824f7fd0 0000000000000000
[   48.970957] Call Trace:
[   48.970957]  [<ffffffff816f7df8>] ? brcmf_sdio_init+0x18/0x70
[   48.970957]  [<ffffffff816eeec9>] brcmf_driver_init+0x9/0x10
[   48.970957]  [<ffffffff81073dc5>] process_one_work+0x1d5/0x480
[   48.970957]  [<ffffffff81073d68>] ? process_one_work+0x178/0x480
[   48.970957]  [<ffffffff81074188>] worker_thread+0x118/0x3a0
[   48.970957]  [<ffffffff81074070>] ? process_one_work+0x480/0x480
[   48.970957]  [<ffffffff8107aa17>] kthread+0xe7/0xf0
[   48.970957]  [<ffffffff810829f7>] ? finish_task_switch.constprop.57+0x37/0xd0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957]  [<ffffffff81a6923a>] ret_from_fork+0x7a/0xb0
[   48.970957]  [<ffffffff8107a930>] ? __kthread_parkme+0x80/0x80
[   48.970957] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
[   48.970957] RIP  [<ffffffff82196446>] classes_init+0x26/0x26
[   48.970957]  RSP <ffff8800001d5d40>
[   48.970957] CR2: ffffffff82196446
[   48.970957] ---[ end trace 62980817cd525f14 ]---

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   28 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    3 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   14 +++++-----
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 +-
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index f849d73..40dcfe5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -459,8 +459,6 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 
 static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 {
-	int ret;
-
 	brcmf_dbg(SDIO, "Enter\n");
 
 	brcmfmac_sdio_pdata = pdev->dev.platform_data;
@@ -468,11 +466,7 @@ static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 	if (brcmfmac_sdio_pdata->power_on)
 		brcmfmac_sdio_pdata->power_on();
 
-	ret = sdio_register_driver(&brcmf_sdmmc_driver);
-	if (ret)
-		brcmf_err("sdio_register_driver failed: %d\n", ret);
-
-	return ret;
+	return 0;
 }
 
 static int brcmf_sdio_pd_remove(struct platform_device *pdev)
@@ -495,6 +489,15 @@ static struct platform_driver brcmf_sdio_pd = {
 	}
 };
 
+void brcmf_sdio_register(void)
+{
+	int ret;
+
+	ret = sdio_register_driver(&brcmf_sdmmc_driver);
+	if (ret)
+		brcmf_err("sdio_register_driver failed: %d\n", ret);
+}
+
 void brcmf_sdio_exit(void)
 {
 	brcmf_dbg(SDIO, "Enter\n");
@@ -505,18 +508,13 @@ void brcmf_sdio_exit(void)
 		sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
 
-void brcmf_sdio_init(void)
+void __init brcmf_sdio_init(void)
 {
 	int ret;
 
 	brcmf_dbg(SDIO, "Enter\n");
 
 	ret = platform_driver_probe(&brcmf_sdio_pd, brcmf_sdio_pd_probe);
-	if (ret == -ENODEV) {
-		brcmf_dbg(SDIO, "No platform data available, registering without.\n");
-		ret = sdio_register_driver(&brcmf_sdmmc_driver);
-	}
-
-	if (ret)
-		brcmf_err("driver registration failed: %d\n", ret);
+	if (ret == -ENODEV)
+		brcmf_dbg(SDIO, "No platform data available.\n");
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index f7c1985..74156f8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -156,10 +156,11 @@ extern int brcmf_bus_start(struct device *dev);
 #ifdef CONFIG_BRCMFMAC_SDIO
 extern void brcmf_sdio_exit(void);
 extern void brcmf_sdio_init(void);
+extern void brcmf_sdio_register(void);
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
 extern void brcmf_usb_exit(void);
-extern void brcmf_usb_init(void);
+extern void brcmf_usb_register(void);
 #endif
 
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b45a4e8..5b330c8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1230,21 +1230,23 @@ u32 brcmf_get_chip_info(struct brcmf_if *ifp)
 	return bus->chip << 4 | bus->chiprev;
 }
 
-static void brcmf_driver_init(struct work_struct *work)
+static void brcmf_driver_register(struct work_struct *work)
 {
-	brcmf_debugfs_init();
-
 #ifdef CONFIG_BRCMFMAC_SDIO
-	brcmf_sdio_init();
+	brcmf_sdio_register();
 #endif
 #ifdef CONFIG_BRCMFMAC_USB
-	brcmf_usb_init();
+	brcmf_usb_register();
 #endif
 }
-static DECLARE_WORK(brcmf_driver_work, brcmf_driver_init);
+static DECLARE_WORK(brcmf_driver_work, brcmf_driver_register);
 
 static int __init brcmfmac_module_init(void)
 {
+	brcmf_debugfs_init();
+#ifdef CONFIG_BRCMFMAC_SDIO
+	brcmf_sdio_init();
+#endif
 	if (!schedule_work(&brcmf_driver_work))
 		return -EBUSY;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 39e01a7..f4aea47 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1539,7 +1539,7 @@ void brcmf_usb_exit(void)
 	brcmf_release_fw(&fw_image_list);
 }
 
-void brcmf_usb_init(void)
+void brcmf_usb_register(void)
 {
 	brcmf_dbg(USB, "Enter\n");
 	INIT_LIST_HEAD(&fw_image_list);
-- 
1.7.10.4


--------------030703020205050901000101--

