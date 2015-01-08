Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbbAHOqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:46:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46149 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbbAHOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:46:27 -0500
Message-ID: <54AE9844.9030609@oracle.com>
Date: Thu, 08 Jan 2015 09:46:28 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ben Skeggs <bskeggs@redhat.com>, Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nouveau oops in pramin_fini
References: <20141217204322.GB27208@redhat.com> <391624261.583161.1418860360088.JavaMail.zimbra@redhat.com>
In-Reply-To: <391624261.583161.1418860360088.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 06:52 PM, Ben Skeggs wrote:
> ----- Original Message -----
>> From: "Dave Jones" <davej@redhat.com>
>> To: "Linux Kernel" <linux-kernel@vger.kernel.org>
>> Cc: bskeggs@redhat.com
>> Sent: Thursday, 18 December, 2014 6:43:22 AM
>> Subject: nouveau oops in pramin_fini
>>
>> Started seeing this during boot on one machine:
> Hey Dave,
>
> I've got a fix for that in my tree, I'll get it to Dave today.


Ben, Dave,


What is the status of the fix for this problem?

-boris


>
> Ben.
>
>>
>> [   17.371812] nouveau  [  DEVICE][0000:07:00.0] BOOT0  : 0x044500a2
>> [   17.371994] nouveau  [  DEVICE][0000:07:00.0] Chipset: NV44 (NV44)
>> [   17.372327] nouveau  [  DEVICE][0000:07:00.0] Family : NV40
>> [   17.390081] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>> [   17.390446] CPU: 0 PID: 398 Comm: systemd-udevd Tainted: G        W
>> 3.18.0+ #14
>> [   17.390673] task: ffff8802205dcc60 ti: ffff880223348000 task.ti:
>> ffff880223348000
>> [   17.390847] RIP: 0010:[<ffffffffc0507ca1>]  [<ffffffffc0507ca1>]
>> pramin_fini+0x11/0x40 [nouveau]
>> [   17.391053] RSP: 0018:ffff88022334b438  EFLAGS: 00010292
>> [   17.391053] RAX: 0000000000000004 RBX: 0000000000000000 RCX:
>> 0000000000000004
>> [   17.391053] RDX: ffffffffc0507c90 RSI: 000000000000cdff RDI:
>> 0000000000000000
>> [   17.391053] RBP: ffff88022334b448 R08: 0000000000000000 R09:
>> 0000000000000000
>> [   17.391053] R10: 0000000000000001 R11: 0000000000000001 R12:
>> ffff88022334b4d8
>> [   17.391053] R13: ffffffffc05bdbe0 R14: ffffffffc05ee580 R15:
>> ffff88022334b498
>> [   17.391053] FS:  00007f85291df880(0000) GS:ffff880225e00000(0000)
>> knlGS:0000000000000000
>> [   17.391053] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [   17.391053] CR2: 00007f44c895a778 CR3: 0000000223338000 CR4:
>> 00000000000007f0
>> [   17.391053] Stack:
>> [   17.391053]  ffffffffc05bdbe0 ffff8802213ef480 ffff88022334b478
>> ffffffffc0507473
>> [   17.391053]  ffff88022334b4d8 ffff88022334b498 0000000000000000
>> ffff8802213ef480
>> [   17.391053]  ffff88022334b6c8 ffffffffc05077ab ffff8802205dcc60
>> ffffffffa07203ce
>> [   17.391053] Call Trace:
>> [   17.391053]  [<ffffffffc0507473>] shadow_method+0x93/0x100 [nouveau]
>> [   17.391053]  [<ffffffffc05077ab>] nvbios_shadow+0x28b/0x3e0 [nouveau]
>> [   17.391053]  [<ffffffffa07203ce>] ? __slab_alloc+0x4d8/0x529
>> [   17.391053]  [<ffffffffc04f9f9d>] nouveau_bios_ctor+0x5d/0x400 [nouveau]
>> [   17.391053]  [<ffffffffa0041615>] ? __ioremap_caller+0x225/0x370
>> [   17.391053]  [<ffffffffc04f7942>] nouveau_object_ctor+0x32/0xc0 [nouveau]
>> [   17.391053]  [<ffffffffc0548153>] nouveau_devobj_ctor+0x283/0x870
>> [nouveau]
>> [   17.391053]  [<ffffffffc04f7942>] nouveau_object_ctor+0x32/0xc0 [nouveau]
>> [   17.391053]  [<ffffffffc04f6209>] nvkm_ioctl_new+0x229/0x310 [nouveau]
>> [   17.391053]  [<ffffffffc04f66f6>] nvkm_ioctl+0x2c6/0x3e0 [nouveau]
>> [   17.391053]  [<ffffffffc0595282>] nvkm_client_ioctl+0x12/0x20 [nouveau]
>> [   17.391053]  [<ffffffffc05862fa>] nvif_object_ioctl+0x9a/0xc0 [nouveau]
>> [   17.391053]  [<ffffffffc0586957>] nvif_object_init+0xf7/0x140 [nouveau]
>> [   17.391053]  [<ffffffffc0586d7b>] nvif_device_init+0x1b/0x50 [nouveau]
>> [   17.391053]  [<ffffffffc058906a>] nouveau_drm_load+0x26a/0x5b0 [nouveau]
>> [   17.391053]  [<ffffffffa00d064d>] ? trace_hardirqs_on+0xd/0x10
>> [   17.391053]  [<ffffffffc02179e5>] drm_dev_register+0xb5/0x110 [drm]
>> [   17.391053]  [<ffffffffc021aa5f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
>> [   17.391053]  [<ffffffffc0588aa2>] nouveau_drm_probe+0x212/0x2a0 [nouveau]
>> [   17.391053]  [<ffffffffa03d9415>] local_pci_probe+0x45/0xa0
>> [   17.391053]  [<ffffffffa03da0a5>] ? pci_match_device+0xe5/0x110
>> [   17.391053]  [<ffffffffa03da1e9>] pci_device_probe+0xd9/0x130
>> [   17.391053]  [<ffffffffa04aefa0>] driver_probe_device+0x90/0x3c0
>> [   17.391053]  [<ffffffffa04af3b3>] __driver_attach+0xa3/0xb0
>> [   17.391053]  [<ffffffffa04af310>] ? __device_attach+0x40/0x40
>> [   17.391053]  [<ffffffffa04ace6b>] bus_for_each_dev+0x6b/0xb0
>> [   17.391053]  [<ffffffffa04ae9fe>] driver_attach+0x1e/0x20
>> [   17.391053]  [<ffffffffa04ae5c8>] bus_add_driver+0x188/0x260
>> [   17.391053]  [<ffffffffa04b01f4>] driver_register+0x64/0xf0
>> [   17.391053]  [<ffffffffa03d8f84>] __pci_register_driver+0x64/0x70
>> [   17.391053]  [<ffffffffc021acba>] drm_pci_init+0xfa/0x130 [drm]
>> [   17.391053]  [<ffffffffc03ed000>] ? 0xffffffffc03ed000
>> [   17.391053]  [<ffffffffc03ed22c>] nouveau_drm_init+0x22c/0x1000 [nouveau]
>> [   17.391053]  [<ffffffffa00002fc>] do_one_initcall+0xbc/0x1f0
>> [   17.391053]  [<ffffffffa01111d1>] load_module+0x2111/0x2710
>> [   17.391053]  [<ffffffffa010c320>] ? store_uevent+0x40/0x40
>> [   17.391053]  [<ffffffffa0111966>] SyS_finit_module+0x86/0xb0
>> [   17.391053]  [<ffffffffa072bc92>] system_call_fastpath+0x12/0x17
>> [   17.391053] Code: 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 66 2e 0f
>> 1f 84 00 00 00 00 00 66 [   47.409343] ---[ end trace 2c9d5ebc1caa0748 ]--
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

