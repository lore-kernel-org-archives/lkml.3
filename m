Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab3FPVRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 17:17:23 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39734 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3FPVRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 17:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAP9ODKof+yv27-zHSO9MTLC9Wv6F6Ya-Ot-vW7OK7kwadYK8Xg@mail.gmail.com>
References: <CAP9ODKof+yv27-zHSO9MTLC9Wv6F6Ya-Ot-vW7OK7kwadYK8Xg@mail.gmail.com>
Date: Sun, 16 Jun 2013 18:09:26 -0300
X-Google-Sender-Auth: Ty8odA8YuZEGCdSc5VLdM4abU6E
Message-ID: <CAP9ODKq92LW-xQyiHkVe6AkwaaYV11nt92DxCEzUioEVARTZXw@mail.gmail.com>
Subject: Fwd: mxs-lradc oops when unloading module
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I am resending as it didn't make iio mailing list as the message
wasn't plain text ]

Hello,

When using mxs-lradc, as module, in a MX23 and unloading the driver,
it sometimes oops as:

[   46.340000] Unable to handle kernel NULL pointer dereference at
virtual address 00000005
[   46.340000] pgd = c7744000
[   46.350000] [00000005] *pgd=46f4d831, *pte=00000000, *ppte=00000000
[   46.360000] Internal error: Oops: 1 [#1] ARM
[   46.360000] Modules linked in: mxs_lradc(C-) industrialio_triggered_buffer
[   46.360000] CPU: 0 PID: 359 Comm: rmmod Tainted: G         C
3.10.0-rc5+ #24
[   46.360000] task: c6f6a200 ti: c680e000 task.ti: c680e000
[   46.360000] PC is at module_put+0x18/0x80
[   46.360000] LR is at iio_device_unregister_trigger_consumer+0x1c/0x28
[   46.360000] pc : [<c0063334>]    lr : [<c0373808>]    psr: a0000013
[   46.360000] sp : c680feb0  ip : 60000013  fp : 01324008
[   46.360000] r10: 00000013  r9 : c680e000  r8 : 00000000
[   46.360000] r7 : c6ee9418  r6 : c0373808  r5 : c6ee8800  r4 : c6ee9810
[   46.360000] r3 : 00000001  r2 : c067a428  r1 : 000002e0  r0 : c6ee8800
[   46.360000] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   46.360000] Control: 0005317f  Table: 47744000  DAC: 00000015
[   46.360000] Process rmmod (pid: 359, stack limit = 0xc680e1b8)
[   46.360000] Stack: (0xc680feb0 to 0xc6810000)
[   46.360000] fea0:                                     c6ee9810
c6ee9400 c76cff80 c0373808
[   46.360000] fec0: c6ee9410 c036f9bc c036f990 c6ee9418 c6ee9410
c02a9610 c6ee9434 c065fbe0
[   46.360000] fee0: c77ccbe0 c024bc40 00000000 c6ee9400 00000000
c74c0644 c680e000 bf0049c4
[   46.360000] ff00: bf004940 c74c0610 bf00589c c02ae058 c02ae044
c02ac8f0 bf00589c c74c0610
[   46.360000] ff20: bf00589c c02ad0dc bf0058dc bf00589c c065fe60
c02ac730 bf0058dc 00000000
[   46.360000] ff40: 00000800 c0064010 ffffffff 5f73786d 6461726c
00000063 c6f6a200 c680e000
[   46.360000] ff60: c6f6a200 c000edcc 00000001 00000000 c680e000
bec16e48 01324008 c005c754
[   46.360000] ff80: 01324088 00000800 01324088 01324088 00000800
01324088 00000081 c000ef08
[   46.360000] ffa0: 00000000 c000ed40 01324088 00000800 013240b8
00000800 bec16c08 ffffeffc
[   46.360000] ffc0: 01324088 00000800 01324088 00000081 00000001
bec16c38 bec16e48 01324008
[   46.360000] ffe0: 4d819ef0 bec16bf4 4d808768 4d721e6c 20000010
013240b8 15401540 51110540
[   46.360000] [<c0063334>] (module_put+0x18/0x80) from [<c0373808>]
(iio_device_unregister_trigger_consumer+0x1c/0x28)
[   46.360000] [<c0373808>]
(iio_device_unregister_trigger_consumer+0x1c/0x28) from [<c036f9bc>]
(iio_dev_release+0x2c/0x6c)
[   46.360000] [<c036f9bc>] (iio_dev_release+0x2c/0x6c) from
[<c02a9610>] (device_release+0x2c/0x90)
[   46.360000] [<c02a9610>] (device_release+0x2c/0x90) from
[<c024bc40>] (kobject_release+0x48/0x7c)
[   46.360000] [<c024bc40>] (kobject_release+0x48/0x7c) from
[<bf0049c4>] (mxs_lradc_remove+0x84/0x90 [mxs_lradc])
[   46.360000] [<bf0049c4>] (mxs_lradc_remove+0x84/0x90 [mxs_lradc])
from [<c02ae058>] (platform_drv_remove+0x14/0x18)
[   46.360000] [<c02ae058>] (platform_drv_remove+0x14/0x18) from
[<c02ac8f0>] (__device_release_driver+0x58/0xb4)
[   46.360000] [<c02ac8f0>] (__device_release_driver+0x58/0xb4) from
[<c02ad0dc>] (driver_detach+0xb4/0xb8)
[   46.360000] [<c02ad0dc>] (driver_detach+0xb4/0xb8) from
[<c02ac730>] (bus_remove_driver+0x7c/0xc0)
[   46.360000] [<c02ac730>] (bus_remove_driver+0x7c/0xc0) from
[<c0064010>] (SyS_delete_module+0x150/0x26c)
[   46.360000] [<c0064010>] (SyS_delete_module+0x150/0x26c) from
[<c000ed40>] (ret_fast_syscall+0x0/0x44)
[   46.360000] Code: e1a0600e 08bd8070 e5953174 e59f2060 (e5931004)
[   46.650000] ---[ end trace 7379015df3468e61 ]---

>From what I could grasp, it might be related to the IIO subsystem but
I couldn't find the culprit.

It seems "iio_device_unregister_trigger_consumer", as:

void iio_device_unregister_trigger_consumer(struct iio_dev *indio_dev)
{
/* Clean up an associated but not attached trigger reference */
if (indio_dev->trig)
iio_trigger_put(indio_dev->trig);
}

and , as:

static inline void iio_trigger_put(struct iio_trigger *trig)
{
module_put(trig->ops->owner);
put_device(&trig->dev);
}

so, somehow the trig->ops is NULL here.

Do someone has a clue?

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
