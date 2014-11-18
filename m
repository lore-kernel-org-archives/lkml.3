Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaKRM3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:29:20 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35325 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaKRM3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:29:17 -0500
MIME-Version: 1.0
X-Originating-IP: [95.23.100.213]
In-Reply-To: <546B2508.8070409@samsung.com>
References: <1415264811.27478.4.camel@AMDC1943>
	<546B228E.6030500@samsung.com>
	<546B2508.8070409@samsung.com>
Date: Tue, 18 Nov 2014 13:29:16 +0100
Message-ID: <CABxcv=k9mTfezmU_a5SoaWuvY5em5QsdeJ01syKv-fScrLCPbg@mail.gmail.com>
Subject: Re: [BUG] blocked task after exynos_drm_init
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Inki Dae <inki.dae@samsung.com>, Kevin Hilman <khilman@linaro.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Kevin to cc list]

Hello Inki,

On Tue, Nov 18, 2014 at 11:52 AM, Inki Dae <inki.dae@samsung.com> wrote:
> On 2014년 11월 18일 19:42, Andrzej Hajda wrote:
>> On 11/06/2014 10:06 AM, Krzysztof Kozlowski wrote:
>>> Hi,
>>>
>>> On last next (next-20141104, next-20141105) booting locks after
>>> initializing Exynos DRM (Trats2 board):
>>>
>>> [    2.028283] [drm] Initialized drm 1.1.0 20060810
>>> [  240.505795] INFO: task swapper/0:1 blocked for more than 120 seconds.
>>> [  240.510825]       Not tainted 3.18.0-rc3-next-20141105 #794
>>> [  240.516418] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [  240.524173] swapper/0       D c052534c     0     1      0 0x00000000
>>> [  240.530527] [<c052534c>] (__schedule) from [<c0525b34>] (schedule_preempt_disabled+0x14/0x20)
>>> [  240.539030] [<c0525b34>] (schedule_preempt_disabled) from [<c0526d44>] (mutex_lock_nested+0x1c4/0x464)
>>> [  240.548320] [<c0526d44>] (mutex_lock_nested) from [<c02be908>] (__driver_attach+0x48/0x98)
>>> [  240.556562] [<c02be908>] (__driver_attach) from [<c02bcc00>] (bus_for_each_dev+0x54/0x88)
>>> [  240.564717] [<c02bcc00>] (bus_for_each_dev) from [<c02bdce0>] (bus_add_driver+0xe4/0x200)
>>> [  240.572876] [<c02bdce0>] (bus_add_driver) from [<c02bef94>] (driver_register+0x78/0xf4)
>>> [  240.580864] [<c02bef94>] (driver_register) from [<c029e99c>] (exynos_drm_platform_probe+0x34/0x234)
>>> [  240.589890] [<c029e99c>] (exynos_drm_platform_probe) from [<c02bfcf0>] (platform_drv_probe+0x48/0xa4)
>>> [  240.599090] [<c02bfcf0>] (platform_drv_probe) from [<c02be680>] (driver_probe_device+0x13c/0x37c)
>>> [  240.607940] [<c02be680>] (driver_probe_device) from [<c02be954>] (__driver_attach+0x94/0x98)
>>> [  240.616360] [<c02be954>] (__driver_attach) from [<c02bcc00>] (bus_for_each_dev+0x54/0x88)
>>> [  240.624517] [<c02bcc00>] (bus_for_each_dev) from [<c02bdce0>] (bus_add_driver+0xe4/0x200)
>>> [  240.632679] [<c02bdce0>] (bus_add_driver) from [<c02bef94>] (driver_register+0x78/0xf4)
>>> [  240.640667] [<c02bef94>] (driver_register) from [<c029e938>] (exynos_drm_init+0x70/0xa0)
>>> [  240.648739] [<c029e938>] (exynos_drm_init) from [<c00089b0>] (do_one_initcall+0xac/0x1f0)
>>> [  240.656914] [<c00089b0>] (do_one_initcall) from [<c074bd90>] (kernel_init_freeable+0x10c/0x1d8)
>>> [  240.665591] [<c074bd90>] (kernel_init_freeable) from [<c051eabc>] (kernel_init+0x8/0xec)
>>> [  240.673661] [<c051eabc>] (kernel_init) from [<c000f268>] (ret_from_fork+0x14/0x2c)
>>> [  240.681196] 3 locks held by swapper/0/1:
>>> [  240.685091]  #0:  (&dev->mutex){......}, at: [<c02be908>] __driver_attach+0x48/0x98
>>> [  240.692732]  #1:  (&dev->mutex){......}, at: [<c02be918>] __driver_attach+0x58/0x98
>>> [  240.700367]  #2:  (&dev->mutex){......}, at: [<c02be908>] __driver_attach+0x48/0x98
>>
>>
>> This is caused by patch moving platform devices to
>> /sys/devices/platform[1]. Since this patch registering platform
>> drivers/devices in probe of platform device causes deadlocks. I guess
>> now all driver registration should be moved to exynos_drm_init and it
>> seems better location for it IMHO.
>
> Thanks. It might be a chance that we could separate sub drivers of
> Exynos drm into independent modules so that they can be called
> independently because if we move them to exynos_drm_init then the
> deferred probe wouldn't work correctly.
>

I don't understand why registering the platform drivers in the
exynos_drm_init() will make deferred probing to not work correctly?
AFAICT it does not matter where the driver is registered since if the
driver probe function is called when the driver is attached and fails
with -EPROBE_DEFER, it will be added to the deferred list and the
probe function will be retried when other drivers are registered due
devices being added (e.g: by OF when matching a compatible string). Or
maybe I'm missing something here?

By the way, I tried moving the platform driver registration to
exynos_drm_init() as suggested by Andrzej and it fixed both the issue
reported in $subject (which is the same reported by Kevin) and the
infinite loop you were tried to fix with your "drm/exynos: fix
infinite loop issue incurred by no pair" patch.

I didn't have display working but that is expected since the machine
is a Peach Pit that has a eDP/LVDS bridge and needs out-of-tree
patches.

I also reverted a few patches on linux-next that said to be fixing
infinite loop issues,  these are:

7afbfcc drm/exynos: fix possible infinite loop issue (in fact I had to
revert this to move the registration from the probe function)
f7c2f36f drm/exynos: resolve infinite loop issue on non multi-platform
06a2f5c drm/exynos: resolve infinite loop issue on multi-platform

And I didn't have the infinite loop issue, so I wonder if those
patches are really necessary or were trying to fix the cause explained
by Andrzej.

Best regards,
Javier
