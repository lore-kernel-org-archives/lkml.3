Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaLAKll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:41:41 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:62329 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaLAKlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:41:40 -0500
MIME-Version: 1.0
In-Reply-To: <547C41C0.9090000@mentor.com>
References: <547C41C0.9090000@mentor.com>
Date: Mon, 1 Dec 2014 11:41:39 +0100
Message-ID: <CAPDyKFpdJCRCtJe8EHGtYHhSk+ont2pzkidx=GbAay1BT8=5eQ@mail.gmail.com>
Subject: Re: [Patch] Improve error handling in allocation of bounce buffers in mmc_init_queue
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Bhuvanesh <bhuvanesh_surachari@mentor.com>
Cc: Chris Ball <chris@printf.net>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@fb.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Joe Perches <joe@perches.com>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 December 2014 at 11:24, Bhuvanesh <bhuvanesh_surachari@mentor.com> wrote:
> Hi,
>
>   During our rigorous testing of inserting and removing SD card, we
> found exception in the kernel. Please find the backtrace is as below:
>
> [ 1899.301985] Backtrace:
> [ 1899.325461] [<800117c4>] (dump_backtrace+0x0/0x100) from [<803f2cf4>] (dump_stack+0x18/0x1c)
> [ 1899.375000] [<803f2cdc>] (dump_stack+0x0/0x1c) from [<800b4038>] (warn_alloc_failed+0xec/0x10c)
> [ 1899.415523] [<800b3f4c>] (warn_alloc_failed+0x0/0x10c) from [<800b6d10>] (__alloc_pages_nodemask+0x764/0x890)
> [ 1899.452807] [<800b65ac>] (__alloc_pages_nodemask+0x0/0x890) from [<800b6e54>] (__get_free_pages+0x18/0x54)
> [ 1899.474315] [<800b6e3c>] (__get_free_pages+0x0/0x54) from [<800e4504>] (kmalloc_order_trace+0x2c/0xe8)
> [ 1899.496752] [<800e44d8>] (kmalloc_order_trace+0x0/0xe8) from [<800e5c4c>] (__kmalloc+0x38/0x1e4)
> [ 1899.520215] [<800e5c14>] (__kmalloc+0x0/0x1e4) from [<8026ac50>] (mmc_init_queue+0x198/0x444)
> [ 1899.543510] [<8026aab8>] (mmc_init_queue+0x0/0x444) from [<80268638>] (mmc_blk_alloc_req+0x184/0x354)
> [ 1899.576244] [<802684b4>] (mmc_blk_alloc_req+0x0/0x354) from [<80268f54>] (mmc_blk_probe+0x7c/0x28c)
> [ 1899.598040] [<80268ed8>] (mmc_blk_probe+0x0/0x28c) from [<8025e8f0>] (mmc_bus_probe+0x1c/0x20)
> [ 1899.616881] [<8025e8d4>] (mmc_bus_probe+0x0/0x20) from [<802a0d2c>] (driver_probe_device+0xb4/0x204)
> [ 1899.654133] [<802a0c78>] (driver_probe_device+0x0/0x204) from [<802a0eac>] (__device_attach+0x30/0x4c)
> [ 1899.683947] [<802a0e7c>] (__device_attach+0x0/0x4c) from [<8029f3b4>] (bus_for_each_drv+0x80/0x94)
> [ 1899.704480] [<8029f334>] (bus_for_each_drv+0x0/0x94) from [<802a0c2c>] (device_attach+0x70/0x94)
> [ 1899.755221] [<802a0bbc>] (device_attach+0x0/0x94) from [<802a01e0>] (bus_probe_device+0x30/0xa0)
> [ 1899.779171] [<802a01b0>] (bus_probe_device+0x0/0xa0) from [<8029e8bc>] (device_add+0x42c/0x570)
> [ 1899.799454] [<8029e490>] (device_add+0x0/0x570) from [<8025eda0>] (mmc_add_card+0x188/0x1e4)
> [ 1899.829667] [<8025ec18>] (mmc_add_card+0x0/0x1e4) from [<802637bc>] (mmc_attach_sd+0x188/0x210)
> [ 1899.870286] [<80263634>] (mmc_attach_sd+0x0/0x210) from [<8025e508>] (mmc_rescan+0x240/0x2ac)
> [ 1899.907069] [<8025e2c8>] (mmc_rescan+0x0/0x2ac) from [<8003cde0>] (process_one_work+0x2cc/0x460)
> [ 1899.939740] [<8003cb14>] (process_one_work+0x0/0x460) from [<8003d240>] (worker_thread+0x298/0x3ec)
> [ 1899.967170] [<8003cfa8>] (worker_thread+0x0/0x3ec) from [<80042490>] (kthread+0xb4/0xc0)
> [ 1899.995888] [<800423dc>] (kthread+0x0/0xc0) from [<8000d9b8>] (ret_from_fork+0x14/0x3c)
> [ 1902.728313] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [ 1902.766137] pgd = 80004000
> [ 1902.781650] [00000000] *pgd=00000000
> [ 1902.790794] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> [ 1902.796302] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat rfcomm bnep hci_uart bluetooth mascassi sg scsi_mod pram asix usbnet mii zforce_ts caam unifi_sdio_v6 spidev mxc_asrc rtc_inc exchnd mousedev imx2_wdt inc_wdt adc_inc input_inc boardcfg snd_aloop i2c_dev imx_thermal thermal_sys evdev snd_soc_fsl_ssi snd_soc_imx_generic pwm_inc snd_soc_imx_audmux snd_soc_imx_pcm snd_soc_fsl_asrc_cpu snd_soc_fsl_asrc_dma snd_soc_fsl_esai snd_soc_fsl_asrc mxc_asrc_core snd_soc_skeleton snd_soc_core regmap_spi snd_pcm regmap_i2c gpio_inc snd_timer snd_compress snd_page_alloc pwm_bl backlight cpu_run ipv6 autofs4 adv7182 mx6_vout videobuf2_core videobuf2_dma_contig videobuf2_memops imx6_v4l2_capture v4l2_int_device v4l2_common videodev mxc_vpu galcore imx_parallel_display imx_hdmi imx_ldb imx_ipuv3_plane imx_ipuv3_crtc imx_ipu_v3 imx_fbdev imxdrm drm_kms_helper fb drm
> [ 1902.873563] CPU: 0    Not tainted  (3.8.13.27-03391-g4e6f494 #1)
> [ 1902.879633] PC is at __blk_segment_map_sg+0xfc/0x140
> [ 1902.884654] LR is at blk_rq_map_sg+0xa0/0x1d8
> [ 1902.889069] pc : [<802240fc>]    lr : [<802241e0>]    psr: 60000013
> [ 1902.889069] sp : 85f1ddb8  ip : 85f1ddf0  fp : 85f1ddec
> [ 1902.900601] r10: 85f1de04  r9 : 00000000  r8 : 00000000
> [ 1902.905880] r7 : 85f1de00  r6 : 00001000  r5 : 85f1de04  r4 : ad141944
> [ 1902.912461] r3 : 00000000  r2 : 807757c0  r1 : 00000000  r0 : ac2872a0
> [ 1902.919044] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [ 1902.926408] Control: 10c5387d  Table: 3de5404a  DAC: 00000015
> [ 1902.932209] Process mmcqd/0 (pid: 1687, stack limit = 0x85f1c238)
> [ 1902.938356] Stack: (0x85f1ddb8 to 0x85f1e000)
> [ 1902.942768] dda0:                                                       9c61f238 00000000
> [ 1902.951004] ddc0: 00000000 ac2872a0 ad07f1b0 ad141900 00000001 00000000 00000000 85f1de04
> [ 1902.959240] dde0: 85f1de3c 85f1ddf0 802241e0 8022400c 85f1de04 85f1de08 85f1de0c 0000001c
> [ 1902.967477] de00: 00000000 00000000 00000000 00000001 85f1de54 835e0430 835e2400 ad07f1b0
> [ 1902.975713] de20: 00000008 835e0434 835e0408 835e0400 85f1de5c 85f1de40 8026b06c 8022414c
> [ 1902.983951] de40: 835e0430 835e2400 ad07f1b0 00000008 85f1de94 85f1de60 80268c14 8026b04c
> [ 1902.992188] de60: 803f90d8 00000000 85f1de8c 835e2400 ad07f1b0 835e0408 ac07f000 ad07f1b0
> [ 1903.000426] de80: 835e0400 835e0434 85f1dedc 85f1de98 802699a8 80268994 85f1deb4 00000000
> [ 1903.008665] dea0: 00000000 00000000 00100100 00200200 803f7f98 ad07f1b0 835e2400 835e0408
> [ 1903.016903] dec0: ac07f000 835e0400 85f1c000 835e0400 85f1df24 85f1dee0 8026a210 80269920
> [ 1903.025142] dee0: 00000000 ad07f1b0 85f1df0c 85f1def8 802204e0 120d0000 120d0000 835e0408
> [ 1903.033381] df00: ad07f1b0 835e0410 ac2872a0 85f1c028 85f1c000 00000001 85f1df5c 85f1df28
> [ 1903.041619] df20: 8026a89c 80269d4c 00000000 120d0000 8026a7bc ac099c28 00000000 835e0408
> [ 1903.049857] df40: 8026a7bc 00000000 00000000 00000000 85f1dfac 85f1df60 80042490 8026a7c8
> [ 1903.058094] df60: 803f9134 00000000 85f1df94 835e0408 00000000 00000000 85f1df78 85f1df78
> [ 1903.066330] df80: 00000000 00000000 85f1df88 85f1df88 ac099c28 800423dc 00000000 00000000
> [ 1903.074566] dfa0: 00000000 85f1dfb0 8000d9b8 800423e8 00000000 00000000 00000000 00000000
> [ 1903.082801] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [ 1903.091036] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 5ae06eda 0a6e879f
> [ 1903.099264] Backtrace:
> [ 1903.101793] [<80224000>] (__blk_segment_map_sg+0x0/0x140) from [<802241e0>] (blk_rq_map_sg+0xa0/0x1d8)
> [ 1903.111168] [<80224140>] (blk_rq_map_sg+0x0/0x1d8) from [<8026b06c>] (mmc_queue_map_sg+0x2c/0x94)
> [ 1903.120105] [<8026b040>] (mmc_queue_map_sg+0x0/0x94) from [<80268c14>] (mmc_blk_rw_rq_prep+0x28c/0x300)
> [ 1903.129549]  r7:00000008 r6:ad07f1b0 r5:835e2400 r4:835e0430
> [ 1903.135284] [<80268988>] (mmc_blk_rw_rq_prep+0x0/0x300) from [<802699a8>] (mmc_blk_issue_rw_rq+0x94/0x42c)
> [ 1903.145000] [<80269914>] (mmc_blk_issue_rw_rq+0x0/0x42c) from [<8026a210>] (mmc_blk_issue_rq+0x4d0/0x500)
> [ 1903.154630] [<80269d40>] (mmc_blk_issue_rq+0x0/0x500) from [<8026a89c>] (mmc_queue_thread+0xe0/0x17c)
> [ 1903.163918] [<8026a7bc>] (mmc_queue_thread+0x0/0x17c) from [<80042490>] (kthread+0xb4/0xc0)
> [ 1903.172334] [<800423dc>] (kthread+0x0/0xc0) from [<8000d9b8>] (ret_from_fork+0x14/0x3c)
> [ 1903.180391]  r7:00000000 r6:00000000 r5:800423dc r4:ac099c28
> [ 1903.186119] Code: e5850000 e5953000 e5942000 e5941008 (e5930000)
> [ 1903.223378] ---[ end trace e1837878f627d738 ]---
> [ 1903.249775] Kernel panic - not syncing: Fatal exception
> [ 1903.255074] Rebooting in 1 seconds..
>
> On analysis i found that error handling in mmc_init_queue during
> allocation of bounce buffers is incomplete. In the exception case the
> allocation of current bounce buffer fails and the previous bounce
> buffer allocation succeeds. This later leads to exception in,
> __blk_segment_map_sg while trying to access the bounce buffer.
>
> The attached patch improves the error handling during allocation of
> bounce buffers. The previous bounce buffer is allocated only if the
> allocation of current bounce buffer succeeds.

You  shouldn't send patches as attachments. We need to be able to
review them and we do that by replying to your email.

Please have a look at Documentation/SubmittingPatches.

Kind regards
Uffe
