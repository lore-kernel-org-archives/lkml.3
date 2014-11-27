Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaK0Jq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:46:29 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:8154 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaK0Jq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:46:26 -0500
X-IronPort-AV: E=Sophos;i="5.07,468,1413270000"; 
   d="scan'208";a="51942318"
Message-ID: <5476F2DD.7070803@broadcom.com>
Date: Thu, 27 Nov 2014 10:46:05 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
        <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        <pgynther@google.com>, <marcel@holtmann.org>,
        <linux-bluetooth@vger.kernel.org>
Subject: Re: bluetooth related firmware loader spew on resume.
References: <20141111181228.GA27815@redhat.com>	<20141126165609.41ee0c24@mdontu-l.dsd.ro>	<s5hoaruvvje.wl-tiwai@suse.de>	<20141126172615.7b6e2cdb@mdontu-l.dsd.ro>	<s5hk32ivv6k.wl-tiwai@suse.de>	<54761116.5090700@broadcom.com>	<s5hwq6hj0dd.wl-tiwai@suse.de>	<5476E7E0.8050406@broadcom.com> <s5hvbm1uhnm.wl-tiwai@suse.de> <5476EEEA.7040001@broadcom.com>
In-Reply-To: <5476EEEA.7040001@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/14 10:29, Arend van Spriel wrote:
> On 11/27/14 10:17, Takashi Iwai wrote:
>> At Thu, 27 Nov 2014 09:59:12 +0100,
>> Arend van Spriel wrote:
>>>
>>> On 11/26/14 19:13, Takashi Iwai wrote:
>>>> At Wed, 26 Nov 2014 18:42:46 +0100,
>>>> Arend van Spriel wrote:
>>>>>
>>>>> On 11/26/14 16:27, Takashi Iwai wrote:
>>>>>> At Wed, 26 Nov 2014 17:26:15 +0200,
>>>>>> Mihai Donțu wrote:
>>>>>>>
>>>>>>> On Wed, 26 Nov 2014 16:19:49 +0100
>>>>>>> Takashi Iwai<tiwai@suse.de> wrote:
>>>>>>>
>>>>>>>> At Wed, 26 Nov 2014 16:56:09 +0200,
>>>>>>>> Mihai Donțu wrote:
>>>>>>>>>
>>>>>>>>> On Tue, 11 Nov 2014 13:12:28 -0500 Dave Jones wrote:
>>>>>>>>>> Since the addition of 10d4c6736ea "Bluetooth: btusb: Add
>>>>>>>>>> Broadcom patch
>>>>>>>>>> RAM support", I (and a number of other people[*]) have been
>>>>>>>>>> seeing
>>>>>>>>>> this trace on resume from suspend.
>>>>>>>>>>
>>>>>>>>>> WARNING: CPU: 1 PID: 8565 at
>>>>>>>>>> drivers/base/firmware_class.c:1127
>>>>>>>>>> _request_firmware+0x4c1/0x7c0()
>>>>>>>>>> CPU: 1 PID: 8565 Comm: kworker/u17:0 Not tainted
>>>>>>>>>> 3.17.2-200.fc20.x86_64 #1
>>>>>>>>>> Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 )
>>>>>>>>>> 04/30/2013
>>>>>>>>>> Workqueue: hci0 hci_power_on [bluetooth]
>>>>>>>>>> 0000000000000000 00000000f52a564b ffff8800a8c63be8
>>>>>>>>>> ffffffff817271cc
>>>>>>>>>> 0000000000000000 ffff8800a8c63c20 ffffffff81094ced
>>>>>>>>>> ffff8800a8c63d10
>>>>>>>>>> ffff8801365ddf00 ffff8801387b4b00 ffff8800a8c63d08
>>>>>>>>>> 00000000fffffff5
>>>>>>>>>> Call Trace:
>>>>>>>>>> [<ffffffff817271cc>] dump_stack+0x45/0x56
>>>>>>>>>> [<ffffffff81094ced>] warn_slowpath_common+0x7d/0xa0
>>>>>>>>>> [<ffffffff81094e1a>] warn_slowpath_null+0x1a/0x20
>>>>>>>>>> [<ffffffff814965c1>] _request_firmware+0x4c1/0x7c0
>>>>>>>>>> [<ffffffff8137b9b9>] ? snprintf+0x49/0x70
>>>>>>>>>> [<ffffffff814968f1>] request_firmware+0x31/0x50
>>>>>>>>>> [<ffffffffa0943bf3>] btusb_setup_bcm_patchram+0x83/0x550 [btusb]
>>>>>>>>>> [<ffffffff8148ecf6>] ? rpm_idle+0xd6/0x2b0
>>>>>>>>>> [<ffffffffa0649051>] hci_dev_do_open+0xe1/0xa60 [bluetooth]
>>>>>>>>>> ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: docking
>>>>>>>>>> Restarting tasks ...
>>>>>>>>>> [<ffffffff810bcb3d>] ? ttwu_do_activate.constprop.90+0x5d/0x70
>>>>>>>>>> [<ffffffffa064a1c0>] hci_power_on+0x40/0x1e0 [bluetooth]
>>>>>>>>>> [<ffffffff810f53fb>] ? lock_timer_base.isra.34+0x2b/0x50
>>>>>>>>>> [<ffffffff810acc39>] process_one_work+0x149/0x3d0
>>>>>>>>>> [<ffffffff810ad2bb>] worker_thread+0x11b/0x490
>>>>>>>>>> [<ffffffff810ad1a0>] ? rescuer_thread+0x2e0/0x2e0
>>>>>>>>>> [<ffffffff810b2318>] kthread+0xd8/0xf0
>>>>>>>>>> [<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
>>>>>>>>>> [<ffffffff8172e7bc>] ret_from_fork+0x7c/0xb0
>>>>>>>>>> [<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
>>>>>>>>>> ---[ end trace 75a0e9c7f33ebb4c ]---
>>>>>>>>>> bluetooth hci0: firmware: brcm/BCM20702A0-0a5c-21e6.hcd will
>>>>>>>>>> not be loaded
>>>>>>>>>> Bluetooth: hci0: BCM: patch brcm/BCM20702A0-0a5c-21e6.hcd not
>>>>>>>>>> found
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> At first I thought it was just over-reaction to the file being
>>>>>>>>>> missing, but
>>>>>>>>>> looking at the WARN_ON, it appears that we're trying to invoke
>>>>>>>>>> the firmware
>>>>>>>>>> loader before userspace is back up ?
>>>>>>>>>>
>>>>>>>>>> In this (and probably other related) kernel,
>>>>>>>>>> CONFIG_FW_LOADER_USER_HELPER is unset,
>>>>>>>>>> in case that matters at all.
>>>>>>>>>>
>>>>>>>>>> Dave
>>>>>>>>>>
>>>>>>>>>> [*] https://bugzilla.kernel.org/show_bug.cgi?id=81821
>>>>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1133378
>>>>>>>>>
>>>>>>>>> I have the following during normal boot:
>>>>>>>>>
>>>>>>>>> [ 5.620796] Bluetooth: hci0: read Intel version:
>>>>>>>>> 370710018002030d00
>>>>>>>>> [ 5.620822] bluetooth hci0: Direct firmware load for
>>>>>>>>> intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq failed with error -2
>>>>>>>>> [ 5.620827] Bluetooth: hci0 failed to open Intel firmware file:
>>>>>>>>> intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq(-2)
>>>>>>>>> [ 5.620920] bluetooth hci0: Direct firmware load for
>>>>>>>>> intel/ibt-hw-37.7.bseq failed with error -2
>>>>>>>>> [ 5.620922] Bluetooth: hci0 failed to open default Intel fw
>>>>>>>>> file: intel/ibt-hw-37.7.bseq
>>>>>>>>> [ 5.629910] EXT4-fs (sda2): mounted filesystem with ordered
>>>>>>>>> data mode. Opts: (null)
>>>>>>>>> [ 5.629916] VFS: Mounted root (ext4 filesystem) readonly on
>>>>>>>>> device 8:2.
>>>>>>>>>
>>>>>>>>> The driver is trying to load the firmware before root is
>>>>>>>>> mounted. Do I
>>>>>>>>> really need an initramfs?
>>>>>>>>
>>>>>>>> If btusb driver is loaded in initrd, you'd need the corresponding
>>>>>>>> firmware in initrd, too.
>>>>>>>
>>>>>>> The driver is built into the kernel and I don't use an initrd. I
>>>>>>> could
>>>>>>> probably create one, but it's a bit tricky with UEFI and a tad
>>>>>>> harder
>>>>>>> to maintain.
>>>>>>
>>>>>> Then you can build the firmware file into kernel, too.
>>>>>
>>>>> huh? The whole idea of the firmware API was to keep (often
>>>>> proprietary)
>>>>> firmware out of the kernel. Has that strategy been abandoned recently?
>>>>
>>>> See CONFIG_EXTRA_FIRMARE. It doesn't mean to include the binary blob
>>>> into the kernel source tree. It just allows to *build* into your
>>>> kernel.

So I looked at this Kconfig option and reading the help I came across 
this warning:

"""
WARNING: If you include additional firmware files into your binary 
kernel image that are not available under the terms of the GPL, 
then it may be a violation of the GPL to distribute the resulting 
image since it combines both GPL and non-GPL work. You should 
consult a lawyer of your own before distributing such an image.
"""

This is exactly what I meant, by "(often proprietary) firmware". So we 
should conclude that if a device needs proprietary firmware it can not 
be built-in the kernel if intended for distribution.

Regards,
Arend

>>> I see. Thanks for the info. I still do not understand the resume
>>> scenario. I though firmware api did some sort of caching of the firmware
>>> images.
>>
>> My theory is that this is triggered when the firmware file doesn't
>> exist. Then it's neither remembered nor cached, so it's retried in
>> the resume path. But the information is missing, so I cannot say
>> surely about it.
>
> Agree. So the same warning should have occurred upon system boot. Maybe
> Mihai can confirm that.
>
> Regards,
> Arend
>
>>
>> Takashi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

