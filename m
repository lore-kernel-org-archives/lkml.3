Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab3ENByO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:54:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab3ENByN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:54:13 -0400
Message-ID: <5191993F.4010407@vlnb.net>
Date: Mon, 13 May 2013 18:54:07 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: WARNING: at lib/dma-debug.c:937 check_unmap+0x45f/0x8b0() (ioat_dma_self_test
 [ioatdma])
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:bKAzPr9kNA5D3slubaQw4EvzpR9QQQVjSSEhER3p5W7
 L3v8JpUe1NFdmb2VW+ScGLdpmr7K8i3CKOQ2GwiVjcUHlwyQ/B
 lZ+KTP0yYo06jSsHR7jm5hq0Ycx083Gir99QxUJ00JOyz0ajkB
 PkOamh9d5z3G7Wh8cHHWAo5ovZSBHkAQQ8p4rhI/i/b6uvBukL
 L2T+r5hQoyCTgu4yPgC4DKEo/zybEpa3uQ69bp/WpfeumWkC32
 1Ufvz4hS8t2jcqGkdYClWx4k2CR/4Pu/T3Pn+HuT2toMvn+8V9
 VMKKkwxuej1lqfbJQ1uTNS1c9OhljlxBBHbYsgFEwepG1Z58w=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I keep getting on each reboot of my kernel 3.9.1 debug system:

[   42.037225] ------------[ cut here ]------------
[   42.037237] WARNING: at lib/dma-debug.c:937 check_unmap+0x45f/0x8b0()
[   42.037240] Hardware name: PowerEdge R710
[   42.037243] ioatdma 0000:00:16.0: DMA-API: device driver failed to check map error[device address=0x00000001268fc0f8] [size=2000 bytes] [mapped as single]
[   42.037245] Modules linked in: lpc_ich(+) ehci_pci(+) mfd_core ehci_hcd ioatdma(+) dca i7core_edac acpi_power_meter hwmon evdev processor bnx2 firmware_class loop sg ata_generic pata_acpi usbhid hid raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 multipath linear crc32c_intel ata_piix libata uhci_hcd mptsas mptscsih mptbase
[   42.037287] Pid: 4457, comm: modprobe Not tainted 3.9.1-scst-dbg #4
[   42.037289] Call Trace:
[   42.037297]  [<ffffffff8103e88f>] warn_slowpath_common+0x7f/0xc0
[   42.037302]  [<ffffffff8103e986>] warn_slowpath_fmt+0x46/0x50
[   42.037306]  [<ffffffff812bea9f>] check_unmap+0x45f/0x8b0
[   42.037312]  [<ffffffff81095ef6>] ? __lock_release+0x106/0x170
[   42.037316]  [<ffffffff812bf15a>] debug_dma_unmap_page+0x5a/0x60
[   42.037326]  [<ffffffffa01b12c7>] ioat_dma_self_test+0x387/0x600 [ioatdma]
[   42.037332]  [<ffffffff81356a8f>] ? devres_add+0x4f/0x70
[   42.037338]  [<ffffffff814cc5d2>] ? wait_for_completion_timeout+0xf2/0x120
[   42.037346]  [<ffffffffa01b70b6>] ioat3_dma_self_test+0x16/0x30 [ioatdma]
[   42.037352]  [<ffffffffa01afbc9>] ioat_probe+0xe9/0x100 [ioatdma]
[   42.037359]  [<ffffffffa01b3eb6>] ioat3_dma_probe+0x176/0x2d0 [ioatdma]
[   42.037365]  [<ffffffffa01af231>] ioat_pci_probe+0x1b1/0x1d0 [ioatdma]
[   42.037370]  [<ffffffff812ccf03>] local_pci_probe+0x23/0x40
[   42.037374]  [<ffffffff812cd329>] __pci_device_probe+0xd9/0xe0
[   42.037377]  [<ffffffff812cd512>] ? pci_dev_get+0x22/0x30
[   42.037381]  [<ffffffff812cd55a>] pci_device_probe+0x3a/0x60
[   42.037385]  [<ffffffff813536ac>] really_probe+0x6c/0x320
[   42.037389]  [<ffffffff8135399b>] driver_probe_device+0x3b/0x80
[   42.037392]  [<ffffffff81353a7b>] __driver_attach+0x9b/0xa0
[   42.037396]  [<ffffffff813539e0>] ? driver_probe_device+0x80/0x80
[   42.037400]  [<ffffffff813539e0>] ? driver_probe_device+0x80/0x80
[   42.037403]  [<ffffffff81351808>] bus_for_each_dev+0x98/0xc0
[   42.037407]  [<ffffffff8135338e>] driver_attach+0x1e/0x20
[   42.037411]  [<ffffffff81352d88>] bus_add_driver+0x208/0x290
[   42.037415]  [<ffffffffa01c0000>] ? 0xffffffffa01bffff
[   42.037418]  [<ffffffff81353de8>] driver_register+0x78/0x160
[   42.037422]  [<ffffffffa01c0000>] ? 0xffffffffa01bffff
[   42.037426]  [<ffffffff812cd664>] __pci_register_driver+0x64/0x70
[   42.037432]  [<ffffffffa01c006d>] ioat_init_module+0x6d/0x1000 [ioatdma]
[   42.037438]  [<ffffffff81000212>] do_one_initcall+0x42/0x170
[   42.037443]  [<ffffffff810a425a>] do_init_module+0xaa/0x220
[   42.037447]  [<ffffffff810a567e>] load_module+0x4ae/0x590
[   42.037452]  [<ffffffff812bce00>] ? ddebug_dyndbg_boot_param_cb+0x60/0x60
[   42.037457]  [<ffffffff8129bba0>] ? copy_user_generic_string+0x30/0x40
[   42.037461]  [<ffffffff810a1570>] ? module_sect_show+0x30/0x30
[   42.037464]  [<ffffffff810a58c4>] sys_init_module+0x94/0xc0
[   42.037470]  [<ffffffff814d5f42>] system_call_fastpath+0x16/0x1b
[   42.037473] ---[ end trace 4d301874fd4a843a ]---
[   42.037475] Mapped at:
[   42.037477]  [<ffffffff812bf4ad>] debug_dma_map_page+0xbd/0x160
[   42.037480]  [<ffffffffa01b10d5>] ioat_dma_self_test+0x195/0x600 [ioatdma]
[   42.037487]  [<ffffffffa01b70b6>] ioat3_dma_self_test+0x16/0x30 [ioatdma]
[   42.037493]  [<ffffffffa01afbc9>] ioat_probe+0xe9/0x100 [ioatdma]
[   42.037499]  [<ffffffffa01b3eb6>] ioat3_dma_probe+0x176/0x2d0 [ioatdma]

First time I've had it for 3.8. I see patch to fix it was sent some time ago for 3.9-rcX, but, apparently, it wasn't applied to the final 3.9.

Thanks,
Vlad
