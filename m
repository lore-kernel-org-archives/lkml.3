Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaHEPng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:43:36 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42775 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaHEPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
References: <14048583172593@kroah.com> <8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
 <s5h38e9mg5v.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBBF8@BLRX7MCDC203.AMER.DELL.COM>
 <s5hy4w1l0s3.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBC06@BLRX7MCDC203.AMER.DELL.COM>
 <s5hpphdkyi6.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FD6FBDAB@BLRX7MCDC203.AMER.DELL.COM>
 <s5hoawvkimg.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE07C773@BLRX7MCDC203.AMER.DELL.COM>
 <s5h7g3frmg7.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE07CC64@BLRX7MCDC203.AMER.DELL.COM>
 <s5hlhrrizbq.wl%tiwai@suse.de> <8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Tue, 5 Aug 2014 17:43:17 +0200
Message-ID: <CAL8zT=jDUyxjimFxBFk56q+B9VwZdnijrU9VF7LBm4X4mNKp+g@mail.gmail.com>
Subject: Re: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
To: B_B_Singh@dell.com
Cc: tiwai@suse.de, Greg KH <gregkh@linuxfoundation.org>,
        Abhay_Salunke@dell.com, Arnd Bergmann <arnd@arndb.de>, kay@vrfy.org,
        ming.lei@canonical.com, Stefan Roese <sr@denx.de>, teg@jklm.no,
        Stuart_Hayes@dell.com, Srinivas_G_Gowda@dell.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-01 22:01 GMT+02:00  <B_B_Singh@dell.com>:
> Hi Takashi,
>
> Sorry for the late response,  I tried with latest stable kernel 3.15.8.  surprisingly the BIOS update works even without applying the patch in both the cases.

Hi,I'm sorry for my late answer too, but I didn't try this patch recently...

I have a Lattice FPGA on my board, and it seems that your patch breaks
the firmware loading.
I have the following config :
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_USER_HELPER=n
FW_LOADER_USER_HELPER_FALLBACK=n
LATTICE_ECP3_CONFIG=y


And my kernel panics :
[    1.180677] lattice-ecp3 spi2.3: FPGA bitstream configuration
driver registered
[    1.188285] lattice-ecp3 spi2.3: Direct firmware load for
lattice-ecp3.bit failed with error -2
[    1.197063] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[    1.203616] spi_imx 2010000.ecspi: probed
[    1.215947] pgd = 80004000
[    1.218671] [00000000] *pgd=00000000
[    1.222284] Internal error: Oops: 5 [#1] SMP ARM
[    1.226914] Modules linked in:
[    1.230007] CPU: 1 PID: 47 Comm: kworker/1:1 Not tainted
3.16.0+yocto+g403c2fc #1
[    1.237516] Workqueue: events request_firmware_work_func
[    1.242861] task: be1d2700 ti: be20e000 task.ti: be20e000
[    1.248281] PC is at firmware_load+0x10/0x47c
[    1.252652] LR is at request_firmware_work_func+0x38/0x58
[    1.258064] pc : [<80390490>]    lr : [<803834c8>]    psr: 20000113
[    1.258064] sp : be20fda0  ip : be20fe68  fp : be20fe64
[    1.269552] r10: be20e008  r9 : 00000001  r8 : be7c5a00
[    1.274788] r7 : be20fea8  r6 : be7c2500  r5 : be3f95c0  r4 : be3f95c0
[    1.281326] r3 : 80390480  r2 : be3f9600  r1 : bd829800  r0 : 00000000
[    1.287866] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[    1.295185] Control: 10c5387d  Table: 1000404a  DAC: 00000015
[    1.300941] Process kworker/1:1 (pid: 47, stack limit = 0xbe20e240)
[    1.307220] Stack: (0xbe20fda0 to 0xbe210000)
[    1.311595] fda0: be20fdd4 be20fdb0 803825b4 800e44f8 00000001
00000000 80382614 be3f9600
[    1.319787] fdc0: 811ccae8 be3f9600 806e3bd4 be3f9600 fffffffe
fffffffe 00000001 be0eb000
[    1.327980] fde0: be20fe04 be20fdf0 803826c8 800e44f8 be1d2700
80870aa8 be20fe64 be20fe08
[    1.336172] fe00: 80382d18 80382668 be3fa348 be20e000 be1d2700
be078000 80870aa8 be3f9600
[    1.344364] fe20: be3fa348 be20fe6c bd829800 00000003 be3fa300
803834b8 00000001 be3f95c0
[    1.352556] fe40: be3f95c0 be7c2500 be20fea8 be7c5a00 00000001
be20e008 be20fe84 be20fe68
[    1.360748] fe60: 803834c8 8039048c be0c2800 00000000 be7c2500
be0c2800 be20fee4 be20fe88
[    1.368939] fe80: 8004245c 8038349c 00000001 00000000 800423e8
be7c2500 80042e54 00000000
[    1.377131] fea0: 00000000 00000000 811ccb7c 80b0bd70 00000000
8086f89c 806acc48 be7c2500
[    1.385322] fec0: be7c2530 be20e028 be20e000 be0c2818 00000008
be0c2800 be20ff24 be20fee8
[    1.393514] fee0: 80042f30 800422bc 806acd4c be0c5280 00000000
be0c2800 80042de8 be0c5280
[    1.401706] ff00: 00000000 be0c2800 80042de8 00000000 00000000
00000000 be20ffac be20ff28
[    1.409898] ff20: 80048ed0 80042df4 800675d0 00000000 be20ff54
be0c2800 00000000 00000000
[    1.418089] ff40: dead4ead ffffffff ffffffff 809caae0 00000000
00000000 80825c5c be20ff5c
[    1.426280] ff60: be20ff5c 00000000 00000000 dead4ead ffffffff
ffffffff 809caae0 00000000
[    1.434472] ff80: 00000000 80825c5c be20ff88 be20ff88 be0c5280
80048df4 00000000 00000000
[    1.442663] ffa0: 00000000 be20ffb0 8000f748 80048e00 00000000
00000000 00000000 00000000
[    1.450853] ffc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    1.459044] ffe0: 00000000 00000000 00000000 00000000 00000013
00000000 40030210 12290009
[    1.467229] Backtrace:
[    1.469719] [<80390480>] (firmware_load) from [<803834c8>]
(request_firmware_work_func+0x38/0x58)
[    1.478600]  r10:be20e008 r9:00000001 r8:be7c5a00 r7:be20fea8
r6:be7c2500 r5:be3f95c0
[    1.486548]  r4:be3f95c0
[    1.489131] [<80383490>] (request_firmware_work_func) from
[<8004245c>] (process_one_work+0x1ac/0x414)
[    1.498446]  r4:be0c2800
[    1.501019] [<800422b0>] (process_one_work) from [<80042f30>]
(worker_thread+0x148/0x4e4)
[    1.509206]  r10:be0c2800 r9:00000008 r8:be0c2818 r7:be20e000
r6:be20e028 r5:be7c2530
[    1.517152]  r4:be7c2500
[    1.519729] [<80042de8>] (worker_thread) from [<80048ed0>]
(kthread+0xdc/0xf8)
[    1.526960]  r10:00000000 r9:00000000 r8:00000000 r7:80042de8
r6:be0c2800 r5:00000000
[    1.534906]  r4:be0c5280
[    1.537483] [<80048df4>] (kthread) from [<8000f748>]
(ret_from_fork+0x14/0x2c)
[    1.544715]  r7:00000000 r6:00000000 r5:80048df4 r4:be0c5280
[    1.550474] Code: e1a0c00d e92ddff0 e24cb004 e24dd09c (e5903000)
[    1.556642] ---[ end trace d18e8b19760cc1e3 ]---

JM
