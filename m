Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaA0KYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:24:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60669 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaA0KYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:24:03 -0500
Message-ID: <52E633C0.8010807@ti.com>
Date: Mon, 27 Jan 2014 12:24:00 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs: cannot create duplicate filename '/bus/platform/devices/twl4030-codec'
References: <CAAfyv35qa3MY10jMfEq5z9TrhrLdj7=bVLxRn8fDZJsqJ9CEbw@mail.gmail.com>
In-Reply-To: <CAAfyv35qa3MY10jMfEq5z9TrhrLdj7=bVLxRn8fDZJsqJ9CEbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/25/2014 05:35 PM, Belisko Marek wrote:
> Hello,
> 
> booting linux-next (not actual but older from 20.12 gives me following warning).
> I'm booting gta04 device via devicetree with added sound node (copied
> from beagleboard)

Not sure what goes wrong on your board. I just tested today's mainline and
linux-next (27.01.2014) on beagle-xm and I don't see anything suspicious
regarding to twl4030-audio.

> 
> [    1.962524] ------------[ cut here ]------------
> [    1.967498] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:52
> sysfs_warn_dup+0x70/0x90()
> [    1.975433] sysfs: cannot create duplicate filename
> '/bus/platform/devices/twl4030-codec'
> [    1.983947] Modules linked in:
> [    1.987182] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.13.0-rc4-next-20131220-00021-gb76a93c-dirty #7
> [    1.996948] [<c00150a0>] (unwind_backtrace) from [<c0011d08>]
> (show_stack+0x10/0x14)
> [    2.005096] [<c0011d08>] (show_stack) from [<c055d578>]
> (dump_stack+0x7c/0x94)
> [    2.012634] [<c055d578>] (dump_stack) from [<c003fa18>]
> (warn_slowpath_common+0x6c/0x90)
> [    2.021118] [<c003fa18>] (warn_slowpath_common) from [<c003fa6c>]
> (warn_slowpath_fmt+0x30/0x40)
> [    2.030212] [<c003fa6c>] (warn_slowpath_fmt) from [<c0176df8>]
> (sysfs_warn_dup+0x70/0x90)
> [    2.038787] [<c0176df8>] (sysfs_warn_dup) from [<c01770f0>]
> (sysfs_do_create_link_sd.isra.2+0xb0/0xb8)
> [    2.049407] [<c01770f0>] (sysfs_do_create_link_sd.isra.2) from
> [<c0370498>] (bus_add_device+0x108/0x194)
> [    2.059387] [<c0370498>] (bus_add_device) from [<c036ea88>]
> (device_add+0x3cc/0x520)
> [    2.067504] [<c036ea88>] (device_add) from [<c0372534>]
> (platform_device_add+0xac/0x210)
> [    2.075958] [<c0372534>] (platform_device_add) from [<c0390358>]
> (mfd_add_device+0x10c/0x31c)
> [    2.084899] [<c0390358>] (mfd_add_device) from [<c0390608>]
> (mfd_add_devices+0xa0/0x100)
> [    2.093322] [<c0390608>] (mfd_add_devices) from [<c038f268>]
> (twl4030_audio_probe+0x178/0x2ac)
> [    2.102325] [<c038f268>] (twl4030_audio_probe) from [<c03727c0>]
> (platform_drv_probe+0x18/0x48)
> [    2.111419] [<c03727c0>] (platform_drv_probe) from [<c0371048>]
> (driver_probe_device+0x110/0x22c)
> [    2.120697] [<c0371048>] (driver_probe_device) from [<c036f6f0>]
> (bus_for_each_drv+0x58/0x8c)
> [    2.129608] [<c036f6f0>] (bus_for_each_drv) from [<c0370f04>]
> (device_attach+0x74/0x8c)
> [    2.138000] [<c0370f04>] (device_attach) from [<c03705ac>]
> (bus_probe_device+0x88/0xb0)
> [    2.146392] [<c03705ac>] (bus_probe_device) from [<c036eadc>]
> (device_add+0x420/0x520)
> [    2.154663] [<c036eadc>] (device_add) from [<c0372534>]
> (platform_device_add+0xac/0x210)
> [    2.163085] [<c0372534>] (platform_device_add) from [<c0390358>]
> (mfd_add_device+0x10c/0x31c)
> [    2.171997] [<c0390358>] (mfd_add_device) from [<c0390608>]
> (mfd_add_devices+0xa0/0x100)
> [    2.180480] [<c0390608>] (mfd_add_devices) from [<c038f268>]
> (twl4030_audio_probe+0x178/0x2ac)
> [    2.189483] [<c038f268>] (twl4030_audio_probe) from [<c03727c0>]
> (platform_drv_probe+0x18/0x48)
> [    2.198577] [<c03727c0>] (platform_drv_probe) from [<c0371048>]
> (driver_probe_device+0x110/0x22c)
> [    2.207885] [<c0371048>] (driver_probe_device) from [<c037123c>]
> (__driver_attach+0x94/0x98)
> [    2.216705] [<c037123c>] (__driver_attach) from [<c036f650>]
> (bus_for_each_dev+0x60/0x94)
> [    2.225280] [<c036f650>] (bus_for_each_dev) from [<c0370824>]
> (bus_add_driver+0x144/0x1f0)
> [    2.233886] [<c0370824>] (bus_add_driver) from [<c037181c>]
> (driver_register+0x78/0xf8)
> [    2.242248] [<c037181c>] (driver_register) from [<c0008918>]
> (do_one_initcall+0xe8/0x14c)
> [    2.250823] [<c0008918>] (do_one_initcall) from [<c07c2c00>]
> (kernel_init_freeable+0x104/0x1c8)
> [    2.259948] [<c07c2c00>] (kernel_init_freeable) from [<c0558570>]
> (kernel_init+0x8/0x118)
> [    2.268493] [<c0558570>] (kernel_init) from [<c000e368>]
> (ret_from_fork+0x14/0x2c)
> [    2.276550] ---[ end trace 371733b66b0dc450 ]---
> [    2.283081] twl4030-audio: probe of twl4030-codec failed with error -17
> 
> I can see that probe function is called 3 times (not sure where it comes from).
> Any pointers?

Indeed it seams we have several probes. Do you have the audio built in or as
modules? Can you reverse it and see if that changes anything? FWIW I have
audio built in.

-- 
Péter
