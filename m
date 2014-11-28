Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaK1J5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:57:23 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:44877 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaK1J5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:57:19 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <d5a94696a79fa1c5132ed4feffe642b0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547846F7.3080708@rock-chips.com>
Date: Fri, 28 Nov 2014 17:57:11 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v13 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com> <1417018856.3177.6.camel@pengutronix.de>
In-Reply-To: <1417018856.3177.6.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:

On 2014年11月27日 00:20, Philipp Zabel wrote:
> Hi Andy,
>
> I have yet to look at this in more detail, but from a quick test
> starting with patch 3, the HDMI display stays black on Nitrogen6X,
> and starting with patch 8 I get the following error.
>
> imx-drm display-subsystem: [CONNECTOR:21:HDMI-A-1] drm_connector_register failed: -12
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:851 __clk_disable+0x6c/0x70()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc6+ #8377
> Backtrace:
> [<80012414>] (dump_backtrace) from [<80012754>] (show_stack+0x20/0x24)
>   r6:00000353 r5:00000000 r4:8083ea08 r3:00000000
> [<80012734>] (show_stack) from [<805ae670>] (dump_stack+0x8c/0x9c)
> [<805ae5e4>] (dump_stack) from [<80022744>] (warn_slowpath_common+0x80/0x9c)
>   r5:00000009 r4:00000000
> [<800226c4>] (warn_slowpath_common) from [<8002281c>] (warn_slowpath_null+0x2c/0x34)
>   r8:b721c610 r7:b72b0400 r6:b735504c r5:80000113 r4:b735504c
> [<800227f0>] (warn_slowpath_null) from [<80458088>] (__clk_disable+0x6c/0x70)
> [<8045801c>] (__clk_disable) from [<804581a8>] (clk_disable+0x34/0x40)
>   r4:b735504c r3:b700e000
> [<80458174>] (clk_disable) from [<803241f0>] (dw_hdmi_imx_unbind+0x30/0x60)
>   r5:b7355010 r4:b7219a10
> [<803241c0>] (dw_hdmi_imx_unbind) from [<8032fc84>] (component_unbind.isra.3+0x40/0x78)
>   r8:b72a1e40 r7:b725f158 r6:b72b0400 r5:b725f158 r4:b725f4c0 r3:803241c0
> [<8032fc44>] (component_unbind.isra.3) from [<8032fd44>] (component_unbind_all+0x88/0xb8)
>   r5:b725f4c0 r4:b725f140
> [<8032fcbc>] (component_unbind_all) from [<80321a3c>] (imx_drm_driver_load+0x100/0x13c)
>   r7:b72b05cc r6:fffffff4 r5:b7355010 r4:b72b0400
> [<8032193c>] (imx_drm_driver_load) from [<8030c260>] (drm_dev_register+0xb8/0x114)
>   r7:b686ad10 r6:00000000 r5:00000000 r4:b72b0400
> [<8030c1a8>] (drm_dev_register) from [<8030dd58>] (drm_platform_init+0x54/0xe8)
>   r6:80844bf4 r5:b721c600 r4:b72b0400 r3:00000000
> [<8030dd04>] (drm_platform_init) from [<803218e8>] (imx_drm_bind+0x20/0x28)
>   r6:b725f140 r5:0000000c r4:b686ad70
> [<803218c8>] (imx_drm_bind) from [<8032f9b0>] (try_to_bring_up_master.part.2+0xd8/0x118)
> [<8032f8d8>] (try_to_bring_up_master.part.2) from [<8032fbe4>] (component_add+0xa0/0x100)
>   r8:b72a1c40 r7:80602b6c r6:b72a1e40 r5:808451e8 r4:b725f140 r3:00000000
> [<8032fb44>] (component_add) from [<8032330c>] (ipu_drm_probe+0x7c/0x150)
>   r7:b682ba10 r6:b77b3cc0 r5:b682ba00 r4:b77b4868
> [<80323290>] (ipu_drm_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r9:00000000 r8:00000000 r7:80844e94 r6:80844e94 r5:fffffdfb r4:b682ba10
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80844e94 r6:00000000 r5:808bc064 r4:b682ba10
> [<80334780>] (driver_probe_device) from [<80334a2c>] (__device_attach+0x50/0x54)
>   r8:00000000 r7:b721c410 r6:803349dc r5:b682ba10 r4:80844e94 r3:80336838
> [<803349dc>] (__device_attach) from [<80332c34>] (bus_for_each_drv+0x68/0x9c)
>   r5:b682ba10 r4:00000000
> [<80332bcc>] (bus_for_each_drv) from [<8033473c>] (device_attach+0x84/0x98)
>   r6:808454e0 r5:b682ba44 r4:b682ba10
> [<803346b8>] (device_attach) from [<80333d14>] (bus_probe_device+0x94/0xb8)
>   r6:808454e0 r5:b682ba10 r4:b682ba18 r3:b7046800
> [<80333c80>] (bus_probe_device) from [<80331e58>] (device_add+0x450/0x530)
>   r6:b682ba10 r5:00000000 r4:b682ba18 r3:00000000
> [<80331a08>] (device_add) from [<803362c8>] (platform_device_add+0xc4/0x228)
>   r9:00000006 r8:b721c410 r7:b7079cc4 r6:b682ba10 r5:b682ba00 r4:00000000
> [<80336204>] (platform_device_add) from [<80336b60>] (platform_device_register_full+0xcc/0xf0)
>   r7:b7079cc4 r6:b7079ce0 r5:b682ba00 r4:b7079ce0
> [<80336a94>] (platform_device_register_full) from [<80328354>] (ipu_add_client_devices.isra.10+0x164/0x19c)
>   r5:00000000 r4:b7079ce0
> [<803281f0>] (ipu_add_client_devices.isra.10) from [<80328940>] (ipu_probe+0x5b4/0x740)
>   r10:808450d4 r9:00000001 r8:b7028180 r7:b72b0010 r6:808450d4 r5:00000000
>   r4:b721c410
> [<8032838c>] (ipu_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r10:00000000 r9:b725f580 r8:00000000 r7:80845078 r6:80845078 r5:fffffdfb
>   r4:b721c410
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80845078 r6:00000000 r5:808bc064 r4:b721c410
> [<80334780>] (driver_probe_device) from [<80334acc>] (__driver_attach+0x9c/0xa0)
>   r8:807ab5e8 r7:00000000 r6:b721c444 r5:80845078 r4:b721c410 r3:00000000
> [<80334a30>] (__driver_attach) from [<80332b6c>] (bus_for_each_dev+0x70/0xa4)
>   r6:80334a30 r5:80845078 r4:00000000 r3:b704685c
> [<80332afc>] (bus_for_each_dev) from [<80334334>] (driver_attach+0x2c/0x30)
>   r6:808454e0 r5:b728d000 r4:80845078
> [<80334308>] (driver_attach) from [<80333fac>] (bus_add_driver+0x15c/0x204)
> [<80333e50>] (bus_add_driver) from [<803352d4>] (driver_register+0x88/0x108)
>   r7:b7078000 r6:807d86c0 r5:8082be60 r4:80845078
> [<8033524c>] (driver_register) from [<8033656c>] (__platform_driver_register+0x64/0x6c)
>   r5:8082be60 r4:8082be60
> [<80336508>] (__platform_driver_register) from [<807d86dc>] (imx_ipu_driver_init+0x1c/0x20)
> [<807d86c0>] (imx_ipu_driver_init) from [<80008980>] (do_one_initcall+0x9c/0x1dc)
> [<800088e4>] (do_one_initcall) from [<807abe5c>] (kernel_init_freeable+0x144/0x1e8)
>   r10:000000aa r9:807f9320 r8:807ab5e8 r7:80868fc0 r6:80868fc0 r5:00000006
>   r4:8081aec0
> [<807abd18>] (kernel_init_freeable) from [<805a9b44>] (kernel_init+0x1c/0xf8)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:805a9b28
>   r4:00008fc0
> [<805a9b28>] (kernel_init) from [<8000eb38>] (ret_from_fork+0x14/0x20)
>   r4:00000000 r3:b7078000
> ---[ end trace 450768ad577083a9 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:760 __clk_unprepare+0x78/0x90()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.0-rc6+ #8377
> Backtrace:
> [<80012414>] (dump_backtrace) from [<80012754>] (show_stack+0x20/0x24)
>   r6:000002f8 r5:00000000 r4:8083ea08 r3:00000000
> [<80012734>] (show_stack) from [<805ae670>] (dump_stack+0x8c/0x9c)
> [<805ae5e4>] (dump_stack) from [<80022744>] (warn_slowpath_common+0x80/0x9c)
>   r5:00000009 r4:00000000
> [<800226c4>] (warn_slowpath_common) from [<8002281c>] (warn_slowpath_null+0x2c/0x34)
>   r8:b721c610 r7:b72b0400 r6:b735504c r5:b7355010 r4:b735504c
> [<800227f0>] (warn_slowpath_null) from [<80458bfc>] (__clk_unprepare+0x78/0x90)
> [<80458b84>] (__clk_unprepare) from [<80458c44>] (clk_unprepare+0x30/0x38)
>   r4:b735504c r3:0000004c
> [<80458c14>] (clk_unprepare) from [<803241f8>] (dw_hdmi_imx_unbind+0x38/0x60)
>   r4:b7219a10 r3:0000004c
> [<803241c0>] (dw_hdmi_imx_unbind) from [<8032fc84>] (component_unbind.isra.3+0x40/0x78)
>   r8:b72a1e40 r7:b725f158 r6:b72b0400 r5:b725f158 r4:b725f4c0 r3:803241c0
> [<8032fc44>] (component_unbind.isra.3) from [<8032fd44>] (component_unbind_all+0x88/0xb8)
>   r5:b725f4c0 r4:b725f140
> [<8032fcbc>] (component_unbind_all) from [<80321a3c>] (imx_drm_driver_load+0x100/0x13c)
>   r7:b72b05cc r6:fffffff4 r5:b7355010 r4:b72b0400
> [<8032193c>] (imx_drm_driver_load) from [<8030c260>] (drm_dev_register+0xb8/0x114)
>   r7:b686ad10 r6:00000000 r5:00000000 r4:b72b0400
> [<8030c1a8>] (drm_dev_register) from [<8030dd58>] (drm_platform_init+0x54/0xe8)
>   r6:80844bf4 r5:b721c600 r4:b72b0400 r3:00000000
> [<8030dd04>] (drm_platform_init) from [<803218e8>] (imx_drm_bind+0x20/0x28)
>   r6:b725f140 r5:0000000c r4:b686ad70
> [<803218c8>] (imx_drm_bind) from [<8032f9b0>] (try_to_bring_up_master.part.2+0xd8/0x118)
> [<8032f8d8>] (try_to_bring_up_master.part.2) from [<8032fbe4>] (component_add+0xa0/0x100)
>   r8:b72a1c40 r7:80602b6c r6:b72a1e40 r5:808451e8 r4:b725f140 r3:00000000
> [<8032fb44>] (component_add) from [<8032330c>] (ipu_drm_probe+0x7c/0x150)
>   r7:b682ba10 r6:b77b3cc0 r5:b682ba00 r4:b77b4868
> [<80323290>] (ipu_drm_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r9:00000000 r8:00000000 r7:80844e94 r6:80844e94 r5:fffffdfb r4:b682ba10
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80844e94 r6:00000000 r5:808bc064 r4:b682ba10
> [<80334780>] (driver_probe_device) from [<80334a2c>] (__device_attach+0x50/0x54)
>   r8:00000000 r7:b721c410 r6:803349dc r5:b682ba10 r4:80844e94 r3:80336838
> [<803349dc>] (__device_attach) from [<80332c34>] (bus_for_each_drv+0x68/0x9c)
>   r5:b682ba10 r4:00000000
> [<80332bcc>] (bus_for_each_drv) from [<8033473c>] (device_attach+0x84/0x98)
>   r6:808454e0 r5:b682ba44 r4:b682ba10
> [<803346b8>] (device_attach) from [<80333d14>] (bus_probe_device+0x94/0xb8)
>   r6:808454e0 r5:b682ba10 r4:b682ba18 r3:b7046800
> [<80333c80>] (bus_probe_device) from [<80331e58>] (device_add+0x450/0x530)
>   r6:b682ba10 r5:00000000 r4:b682ba18 r3:00000000
> [<80331a08>] (device_add) from [<803362c8>] (platform_device_add+0xc4/0x228)
>   r9:00000006 r8:b721c410 r7:b7079cc4 r6:b682ba10 r5:b682ba00 r4:00000000
> [<80336204>] (platform_device_add) from [<80336b60>] (platform_device_register_full+0xcc/0xf0)
>   r7:b7079cc4 r6:b7079ce0 r5:b682ba00 r4:b7079ce0
> [<80336a94>] (platform_device_register_full) from [<80328354>] (ipu_add_client_devices.isra.10+0x164/0x19c)
>   r5:00000000 r4:b7079ce0
> [<803281f0>] (ipu_add_client_devices.isra.10) from [<80328940>] (ipu_probe+0x5b4/0x740)
>   r10:808450d4 r9:00000001 r8:b7028180 r7:b72b0010 r6:808450d4 r5:00000000
>   r4:b721c410
> [<8032838c>] (ipu_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r10:00000000 r9:b725f580 r8:00000000 r7:80845078 r6:80845078 r5:fffffdfb
>   r4:b721c410
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80845078 r6:00000000 r5:808bc064 r4:b721c410
> [<80334780>] (driver_probe_device) from [<80334acc>] (__driver_attach+0x9c/0xa0)
>   r8:807ab5e8 r7:00000000 r6:b721c444 r5:80845078 r4:b721c410 r3:00000000
> [<80334a30>] (__driver_attach) from [<80332b6c>] (bus_for_each_dev+0x70/0xa4)
>   r6:80334a30 r5:80845078 r4:00000000 r3:b704685c
> [<80332afc>] (bus_for_each_dev) from [<80334334>] (driver_attach+0x2c/0x30)
>   r6:808454e0 r5:b728d000 r4:80845078
> [<80334308>] (driver_attach) from [<80333fac>] (bus_add_driver+0x15c/0x204)
> [<80333e50>] (bus_add_driver) from [<803352d4>] (driver_register+0x88/0x108)
>   r7:b7078000 r6:807d86c0 r5:8082be60 r4:80845078
> [<8033524c>] (driver_register) from [<8033656c>] (__platform_driver_register+0x64/0x6c)
>   r5:8082be60 r4:8082be60
> [<80336508>] (__platform_driver_register) from [<807d86dc>] (imx_ipu_driver_init+0x1c/0x20)
> [<807d86c0>] (imx_ipu_driver_init) from [<80008980>] (do_one_initcall+0x9c/0x1dc)
> [<800088e4>] (do_one_initcall) from [<807abe5c>] (kernel_init_freeable+0x144/0x1e8)
>   r10:000000aa r9:807f9320 r8:807ab5e8 r7:80868fc0 r6:80868fc0 r5:00000006
>   r4:8081aec0
> [<807abd18>] (kernel_init_freeable) from [<805a9b44>] (kernel_init+0x1c/0xf8)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:805a9b28
>   r4:00008fc0
> [<805a9b28>] (kernel_init) from [<8000eb38>] (ret_from_fork+0x14/0x20)
>   r4:00000000 r3:b7078000
> ---[ end trace 450768ad577083aa ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:851 __clk_disable+0x6c/0x70()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.0-rc6+ #8377
> Backtrace:
> [<80012414>] (dump_backtrace) from [<80012754>] (show_stack+0x20/0x24)
>   r6:00000353 r5:00000000 r4:8083ea08 r3:00000000
> [<80012734>] (show_stack) from [<805ae670>] (dump_stack+0x8c/0x9c)
> [<805ae5e4>] (dump_stack) from [<80022744>] (warn_slowpath_common+0x80/0x9c)
>   r5:00000009 r4:00000000
> [<800226c4>] (warn_slowpath_common) from [<8002281c>] (warn_slowpath_null+0x2c/0x34)
>   r8:b721c610 r7:b72b0400 r6:b735504c r5:80000113 r4:b735504c
> [<800227f0>] (warn_slowpath_null) from [<80458088>] (__clk_disable+0x6c/0x70)
> [<8045801c>] (__clk_disable) from [<804581a8>] (clk_disable+0x34/0x40)
>   r4:b735504c r3:b700e000
> [<80458174>] (clk_disable) from [<80324204>] (dw_hdmi_imx_unbind+0x44/0x60)
>   r5:b735504c r4:b7219a10
> [<803241c0>] (dw_hdmi_imx_unbind) from [<8032fc84>] (component_unbind.isra.3+0x40/0x78)
>   r8:b72a1e40 r7:b725f158 r6:b72b0400 r5:b725f158 r4:b725f4c0 r3:803241c0
> [<8032fc44>] (component_unbind.isra.3) from [<8032fd44>] (component_unbind_all+0x88/0xb8)
>   r5:b725f4c0 r4:b725f140
> [<8032fcbc>] (component_unbind_all) from [<80321a3c>] (imx_drm_driver_load+0x100/0x13c)
>   r7:b72b05cc r6:fffffff4 r5:b7355010 r4:b72b0400
> [<8032193c>] (imx_drm_driver_load) from [<8030c260>] (drm_dev_register+0xb8/0x114)
>   r7:b686ad10 r6:00000000 r5:00000000 r4:b72b0400
> [<8030c1a8>] (drm_dev_register) from [<8030dd58>] (drm_platform_init+0x54/0xe8)
>   r6:80844bf4 r5:b721c600 r4:b72b0400 r3:00000000
> [<8030dd04>] (drm_platform_init) from [<803218e8>] (imx_drm_bind+0x20/0x28)
>   r6:b725f140 r5:0000000c r4:b686ad70
> [<803218c8>] (imx_drm_bind) from [<8032f9b0>] (try_to_bring_up_master.part.2+0xd8/0x118)
> [<8032f8d8>] (try_to_bring_up_master.part.2) from [<8032fbe4>] (component_add+0xa0/0x100)
>   r8:b72a1c40 r7:80602b6c r6:b72a1e40 r5:808451e8 r4:b725f140 r3:00000000
> [<8032fb44>] (component_add) from [<8032330c>] (ipu_drm_probe+0x7c/0x150)
>   r7:b682ba10 r6:b77b3cc0 r5:b682ba00 r4:b77b4868
> [<80323290>] (ipu_drm_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r9:00000000 r8:00000000 r7:80844e94 r6:80844e94 r5:fffffdfb r4:b682ba10
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80844e94 r6:00000000 r5:808bc064 r4:b682ba10
> [<80334780>] (driver_probe_device) from [<80334a2c>] (__device_attach+0x50/0x54)
>   r8:00000000 r7:b721c410 r6:803349dc r5:b682ba10 r4:80844e94 r3:80336838
> [<803349dc>] (__device_attach) from [<80332c34>] (bus_for_each_drv+0x68/0x9c)
>   r5:b682ba10 r4:00000000
> [<80332bcc>] (bus_for_each_drv) from [<8033473c>] (device_attach+0x84/0x98)
>   r6:808454e0 r5:b682ba44 r4:b682ba10
> [<803346b8>] (device_attach) from [<80333d14>] (bus_probe_device+0x94/0xb8)
>   r6:808454e0 r5:b682ba10 r4:b682ba18 r3:b7046800
> [<80333c80>] (bus_probe_device) from [<80331e58>] (device_add+0x450/0x530)
>   r6:b682ba10 r5:00000000 r4:b682ba18 r3:00000000
> [<80331a08>] (device_add) from [<803362c8>] (platform_device_add+0xc4/0x228)
>   r9:00000006 r8:b721c410 r7:b7079cc4 r6:b682ba10 r5:b682ba00 r4:00000000
> [<80336204>] (platform_device_add) from [<80336b60>] (platform_device_register_full+0xcc/0xf0)
>   r7:b7079cc4 r6:b7079ce0 r5:b682ba00 r4:b7079ce0
> [<80336a94>] (platform_device_register_full) from [<80328354>] (ipu_add_client_devices.isra.10+0x164/0x19c)
>   r5:00000000 r4:b7079ce0
> [<803281f0>] (ipu_add_client_devices.isra.10) from [<80328940>] (ipu_probe+0x5b4/0x740)
>   r10:808450d4 r9:00000001 r8:b7028180 r7:b72b0010 r6:808450d4 r5:00000000
>   r4:b721c410
> [<8032838c>] (ipu_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r10:00000000 r9:b725f580 r8:00000000 r7:80845078 r6:80845078 r5:fffffdfb
>   r4:b721c410
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80845078 r6:00000000 r5:808bc064 r4:b721c410
> [<80334780>] (driver_probe_device) from [<80334acc>] (__driver_attach+0x9c/0xa0)
>   r8:807ab5e8 r7:00000000 r6:b721c444 r5:80845078 r4:b721c410 r3:00000000
> [<80334a30>] (__driver_attach) from [<80332b6c>] (bus_for_each_dev+0x70/0xa4)
>   r6:80334a30 r5:80845078 r4:00000000 r3:b704685c
> [<80332afc>] (bus_for_each_dev) from [<80334334>] (driver_attach+0x2c/0x30)
>   r6:808454e0 r5:b728d000 r4:80845078
> [<80334308>] (driver_attach) from [<80333fac>] (bus_add_driver+0x15c/0x204)
> [<80333e50>] (bus_add_driver) from [<803352d4>] (driver_register+0x88/0x108)
>   r7:b7078000 r6:807d86c0 r5:8082be60 r4:80845078
> [<8033524c>] (driver_register) from [<8033656c>] (__platform_driver_register+0x64/0x6c)
>   r5:8082be60 r4:8082be60
> [<80336508>] (__platform_driver_register) from [<807d86dc>] (imx_ipu_driver_init+0x1c/0x20)
> [<807d86c0>] (imx_ipu_driver_init) from [<80008980>] (do_one_initcall+0x9c/0x1dc)
> [<800088e4>] (do_one_initcall) from [<807abe5c>] (kernel_init_freeable+0x144/0x1e8)
>   r10:000000aa r9:807f9320 r8:807ab5e8 r7:80868fc0 r6:80868fc0 r5:00000006
>   r4:8081aec0
> [<807abd18>] (kernel_init_freeable) from [<805a9b44>] (kernel_init+0x1c/0xf8)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:805a9b28
>   r4:00008fc0
> [<805a9b28>] (kernel_init) from [<8000eb38>] (ret_from_fork+0x14/0x20)
>   r4:00000000 r3:b7078000
> ---[ end trace 450768ad577083ab ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:760 __clk_unprepare+0x78/0x90()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.0-rc6+ #8377
> Backtrace:
> [<80012414>] (dump_backtrace) from [<80012754>] (show_stack+0x20/0x24)
>   r6:000002f8 r5:00000000 r4:8083ea08 r3:00000000
> [<80012734>] (show_stack) from [<805ae670>] (dump_stack+0x8c/0x9c)
> [<805ae5e4>] (dump_stack) from [<80022744>] (warn_slowpath_common+0x80/0x9c)
>   r5:00000009 r4:00000000
> [<800226c4>] (warn_slowpath_common) from [<8002281c>] (warn_slowpath_null+0x2c/0x34)
>   r8:b721c610 r7:b72b0400 r6:b735504c r5:b735504c r4:b735504c
> [<800227f0>] (warn_slowpath_null) from [<80458bfc>] (__clk_unprepare+0x78/0x90)
> [<80458b84>] (__clk_unprepare) from [<80458c44>] (clk_unprepare+0x30/0x38)
>   r4:b735504c r3:000003b5
> [<80458c14>] (clk_unprepare) from [<8032420c>] (dw_hdmi_imx_unbind+0x4c/0x60)
>   r4:b7219a10 r3:000003b5
> [<803241c0>] (dw_hdmi_imx_unbind) from [<8032fc84>] (component_unbind.isra.3+0x40/0x78)
>   r8:b72a1e40 r7:b725f158 r6:b72b0400 r5:b725f158 r4:b725f4c0 r3:803241c0
> [<8032fc44>] (component_unbind.isra.3) from [<8032fd44>] (component_unbind_all+0x88/0xb8)
>   r5:b725f4c0 r4:b725f140
> [<8032fcbc>] (component_unbind_all) from [<80321a3c>] (imx_drm_driver_load+0x100/0x13c)
>   r7:b72b05cc r6:fffffff4 r5:b7355010 r4:b72b0400
> [<8032193c>] (imx_drm_driver_load) from [<8030c260>] (drm_dev_register+0xb8/0x114)
>   r7:b686ad10 r6:00000000 r5:00000000 r4:b72b0400
> [<8030c1a8>] (drm_dev_register) from [<8030dd58>] (drm_platform_init+0x54/0xe8)
>   r6:80844bf4 r5:b721c600 r4:b72b0400 r3:00000000
> [<8030dd04>] (drm_platform_init) from [<803218e8>] (imx_drm_bind+0x20/0x28)
>   r6:b725f140 r5:0000000c r4:b686ad70
> [<803218c8>] (imx_drm_bind) from [<8032f9b0>] (try_to_bring_up_master.part.2+0xd8/0x118)
> [<8032f8d8>] (try_to_bring_up_master.part.2) from [<8032fbe4>] (component_add+0xa0/0x100)
>   r8:b72a1c40 r7:80602b6c r6:b72a1e40 r5:808451e8 r4:b725f140 r3:00000000
> [<8032fb44>] (component_add) from [<8032330c>] (ipu_drm_probe+0x7c/0x150)
>   r7:b682ba10 r6:b77b3cc0 r5:b682ba00 r4:b77b4868
> [<80323290>] (ipu_drm_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r9:00000000 r8:00000000 r7:80844e94 r6:80844e94 r5:fffffdfb r4:b682ba10
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80844e94 r6:00000000 r5:808bc064 r4:b682ba10
> [<80334780>] (driver_probe_device) from [<80334a2c>] (__device_attach+0x50/0x54)
>   r8:00000000 r7:b721c410 r6:803349dc r5:b682ba10 r4:80844e94 r3:80336838
> [<803349dc>] (__device_attach) from [<80332c34>] (bus_for_each_drv+0x68/0x9c)
>   r5:b682ba10 r4:00000000
> [<80332bcc>] (bus_for_each_drv) from [<8033473c>] (device_attach+0x84/0x98)
>   r6:808454e0 r5:b682ba44 r4:b682ba10
> [<803346b8>] (device_attach) from [<80333d14>] (bus_probe_device+0x94/0xb8)
>   r6:808454e0 r5:b682ba10 r4:b682ba18 r3:b7046800
> [<80333c80>] (bus_probe_device) from [<80331e58>] (device_add+0x450/0x530)
>   r6:b682ba10 r5:00000000 r4:b682ba18 r3:00000000
> [<80331a08>] (device_add) from [<803362c8>] (platform_device_add+0xc4/0x228)
>   r9:00000006 r8:b721c410 r7:b7079cc4 r6:b682ba10 r5:b682ba00 r4:00000000
> [<80336204>] (platform_device_add) from [<80336b60>] (platform_device_register_full+0xcc/0xf0)
>   r7:b7079cc4 r6:b7079ce0 r5:b682ba00 r4:b7079ce0
> [<80336a94>] (platform_device_register_full) from [<80328354>] (ipu_add_client_devices.isra.10+0x164/0x19c)
>   r5:00000000 r4:b7079ce0
> [<803281f0>] (ipu_add_client_devices.isra.10) from [<80328940>] (ipu_probe+0x5b4/0x740)
>   r10:808450d4 r9:00000001 r8:b7028180 r7:b72b0010 r6:808450d4 r5:00000000
>   r4:b721c410
> [<8032838c>] (ipu_probe) from [<80336640>] (platform_drv_probe+0x54/0xb4)
>   r10:00000000 r9:b725f580 r8:00000000 r7:80845078 r6:80845078 r5:fffffdfb
>   r4:b721c410
> [<803365ec>] (platform_drv_probe) from [<803348a8>] (driver_probe_device+0x128/0x25c)
>   r7:80845078 r6:00000000 r5:808bc064 r4:b721c410
> [<80334780>] (driver_probe_device) from [<80334acc>] (__driver_attach+0x9c/0xa0)
>   r8:807ab5e8 r7:00000000 r6:b721c444 r5:80845078 r4:b721c410 r3:00000000
> [<80334a30>] (__driver_attach) from [<80332b6c>] (bus_for_each_dev+0x70/0xa4)
>   r6:80334a30 r5:80845078 r4:00000000 r3:b704685c
> [<80332afc>] (bus_for_each_dev) from [<80334334>] (driver_attach+0x2c/0x30)
>   r6:808454e0 r5:b728d000 r4:80845078
> [<80334308>] (driver_attach) from [<80333fac>] (bus_add_driver+0x15c/0x204)
> [<80333e50>] (bus_add_driver) from [<803352d4>] (driver_register+0x88/0x108)
>   r7:b7078000 r6:807d86c0 r5:8082be60 r4:80845078
> [<8033524c>] (driver_register) from [<8033656c>] (__platform_driver_register+0x64/0x6c)
>   r5:8082be60 r4:8082be60
> [<80336508>] (__platform_driver_register) from [<807d86dc>] (imx_ipu_driver_init+0x1c/0x20)
> [<807d86c0>] (imx_ipu_driver_init) from [<80008980>] (do_one_initcall+0x9c/0x1dc)
> [<800088e4>] (do_one_initcall) from [<807abe5c>] (kernel_init_freeable+0x144/0x1e8)
>   r10:000000aa r9:807f9320 r8:807ab5e8 r7:80868fc0 r6:80868fc0 r5:00000006
>   r4:8081aec0
> [<807abd18>] (kernel_init_freeable) from [<805a9b44>] (kernel_init+0x1c/0xf8)
>   r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:805a9b28
>   r4:00008fc0
> [<805a9b28>] (kernel_init) from [<8000eb38>] (ret_from_fork+0x14/0x20)
>   r4:00000000 r3:b7078000
> ---[ end trace 450768ad577083ac ]---
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.5 failed with error -12
>
> regards
> Philipp
>
>
>
>
   Very sorry about this trouble. Because I have no imx board, we do all 
the test on
RK3288 board.
    I had sent a mail with a debug patch to you directly yesterday, hope 
it will helpful.
If you have received the mail, would you please give me a reply?




