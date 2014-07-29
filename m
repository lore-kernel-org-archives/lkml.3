Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaG2QQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:16:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51951 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaG2QQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:16:12 -0400
Message-ID: <53D7C8CC.1050201@wwwdotorg.org>
Date: Tue, 29 Jul 2014 10:16:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yufeng Shen <miletus@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>	<53CECAEC.8080905@wwwdotorg.org>	<53CFD50C.4040509@itdev.co.uk>	<53CFEF6E.2060905@wwwdotorg.org>	<53D10E78.4010908@itdev.co.uk>	<53D17845.4020507@wwwdotorg.org>	<53D26572.3030404@itdev.co.uk>	<53D2B8D0.5090000@wwwdotorg.org>	<CAPDwgkNrBRJRR6WtoPSfs8Yq=ui-Ptjju4mJ=9h=95YVFuxw7g@mail.gmail.com>	<53D6BF50.3070306@wwwdotorg.org>	<53D6DFE7.3040901@wwwdotorg.org> <CAPDwgkPL1utj3DFoFbOCcJsASpf+12nvKg1KcseV_MhEz66eiw@mail.gmail.com>
In-Reply-To: <CAPDwgkPL1utj3DFoFbOCcJsASpf+12nvKg1KcseV_MhEz66eiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 06:10 PM, Yufeng Shen wrote:
> On Mon, Jul 28, 2014 at 7:42 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 07/28/2014 03:23 PM, Stephen Warren wrote:
>>> On 07/28/2014 02:20 PM, Yufeng Shen wrote:
>>
>> ...
>>
>>>> Where did you get the configuration file ? It is possible that we rely
>>>> too much on mxt_start to turn on the T9.CTRL bit and have neglected
>>>> its setting in the config file.
>>>> If you can tell me where you get the config file I can do a check.
>>>
>>>
>>> It was already flashed into the touchpad when I received the board. I
>>> did try to track down the firmware/config files a few months ago, but
>>> didn't manage to; I was told since they were already flashed so I didn't
>>> need them. The board is Venice2.
>>
>> OK, I received the configuration and firmware file that's supposed to be in
>> the touchpad.
>>
>> I can see that the config file I was given has the "83" byte in the T9
>> configuration, and in fact /almost/ exactly matches the configuration I
>> have. I don't know why my T9 configuration was wrong before, but I suspect
>> it's not worth trying to track that down.
>>
>> Anyway, here's the diff between the two config files:
>>
>>> # diff -u mxt-save-after-t9-83-write.xml 224sl.raw
>>> --- mxt-save-after-t9-83-write.xml      2014-07-25 19:41:45.000000000
>>> +0000
>>> +++ 224sl.raw   2014-07-28 23:25:49.000000000 +0000
>>> @@ -1,8 +1,7 @@
>>>   OBP_RAW V1
>>>   82 01 10 AA 12 0C 16
>>>   F5AF33
>>> -000000
>>> -0025 0000 0082 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00 00 00 00 00 00 00 00
>>> +E21E65
>>>   0026 0000 0008 00 00 00 00 00 00 00 00
>>>   0007 0000 0004 20 10 32 00
>>>   0008 0000 000A 1E 00 28 28 00 00 00 00 00 00
>>
>>
>> It seems that the T25(?) entry is missing in the new/expected configuration
>> file. I figured I'd try out the new/expected configuration file, so did:
>
> T37 (0x25) is DEBUG_DIAGNOSTIC object which the host can read debugging info
> from. It is not useful to have a initial config for it so usually CrOS
> system would just don't include configuration for this object.

OK, that makes sense.

I also tested mxt-app --zero to clear the config, the dumped it with 
--save to verify it was cleared, then --load 224sl.raw and then --save 
to verify it was programmed back correctly. That seemed to all work fine.

I then tried updating the firmware. This didn't work at all.

First I tried via mxt-app:

> root@localhost:~# ./obp-utils/mxt-app -d i2c-dev:1-004b --flash 130.1_1.0.170.bin
> Version:1.16-65-g0a4c
> Opening firmware file 130.1_1.0.170.bin
> Registered i2c-dev adapter:1 address:0x4b
> Chip detected
> Current firmware version: 1.0.AA
> Skipping version check
> Resetting in bootloader mode
> Registered i2c-dev adapter:1 address:0x25
> Error Remote I/O error (121) reading from i2c
> Bootloader read failure
> Bootloader not found

Then I power-cycled and tried via the atmel_mxt_ts modules' sysfs files:

> root@localhost:~# echo 1 > /sys/devices/soc0/7000c400.i2c/i2c-1/1-004b/update_fw
> [   38.495420] atmel_mxt_ts 1-004b: mxt_bootloader_read: i2c recv failed (-121)
> [   38.506208] atmel_mxt_ts 1-004b: mxt_bootloader_read: i2c recv failed (-121)
> [   38.513836] atmel_mxt_ts 1-004b: The firmware update failed(-121)
> -bash: echo: write error: Remote I/O error

I also found that removing the module (even without attempting a FW 
update) yields:

After attempted FW update via sysfs:

> root@localhost:~# rmmod ./atmel_mxt_ts.ko
> [   81.995672] Unable to handle kernel NULL pointer dereference at virtual address 00000364
> [   82.003828] pgd = e8cd0000
> [   82.006548] [00000364] *pgd=00000000
> [   82.010221] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [   82.015537] Modules linked in: atmel_mxt_ts(-)
> [   82.020007] CPU: 0 PID: 836 Comm: rmmod Not tainted 3.16.0-rc7-next-20140729-00011-gead0778e710c-dirty #7
> [   82.029559] task: e98ba140 ti: e8cc8000 task.ti: e8cc8000
> [   82.034961] PC is at input_unregister_device+0x8/0x70
> [   82.040010] LR is at mxt_remove+0x28/0x44 [atmel_mxt_ts]
> [   82.045315] pc : [<c039de7c>]    lr : [<bf000410>]    psr: 60000113
> [   82.045315] sp : e8cc9f08  ip : e97c7900  fp : 00000800
> [   82.056774] r10: 00000000  r9 : e8cc8000  r8 : c000e924
> [   82.061990] r7 : 00000081  r6 : ea1a7a54  r5 : bf003660  r4 : 00000000
> [   82.068505] r3 : 0000000c  r2 : 0000000a  r1 : 00000000  r0 : 00000000
> [   82.075024] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   82.082146] Control: 10c5387d  Table: a8cd006a  DAC: 00000015
> [   82.087882] Process rmmod (pid: 836, stack limit = 0xe8cc8240)
> [   82.093704] Stack: (0xe8cc9f08 to 0xe8cca000)
> [   82.098055] 9f00:                   e9a4e040 bf000410 ea1a7a20 c03bbe24 c03bbde0 c02dc12c
> [   82.106221] 9f20: bf003660 ea1a7a20 bf003660 c02dc910 bf003660 bf003704 00000800 c02dbfbc
> [   82.114386] 9f40: 00000000 c0081cdc e9f29018 00000000 bf003704 00000800 e8cc9f4c 656d7461
> [   82.122550] 9f60: 786d5f6c 73745f74 00000000 e98ba63c 00000000 c08c0d74 00000800 c0039d60
> [   82.130716] 9f80: e8c964c0 e8cc8000 e8cc8000 e8cc8000 c000e924 00010ef0 b6f3dd08 00000002
> [   82.138881] 9fa0: 00000000 c000e7a0 b6f3dd08 00000002 b6f3dd38 00000800 0cadcf00 0cadcf00
> [   82.147046] 9fc0: b6f3dd08 00000002 00000000 00000081 b6f3dd08 b6f3d008 beeac848 00000800
> [   82.155211] 9fe0: b6e65070 beeac5c4 b6ee02e9 b6e6507c 80000010 b6f3dd38 00000000 00000000
> [   82.163392] [<c039de7c>] (input_unregister_device) from [<bf000410>] (mxt_remove+0x28/0x44 [atmel_mxt_ts])
> [   82.173042] [<bf000410>] (mxt_remove [atmel_mxt_ts]) from [<c03bbe24>] (i2c_device_remove+0x44/0x5c)
> [   82.182171] [<c03bbe24>] (i2c_device_remove) from [<c02dc12c>] (__device_release_driver+0x70/0xc4)
> [   82.191122] [<c02dc12c>] (__device_release_driver) from [<c02dc910>] (driver_detach+0xac/0xb0)
> [   82.199726] [<c02dc910>] (driver_detach) from [<c02dbfbc>] (bus_remove_driver+0x4c/0x90)
> [   82.207810] [<c02dbfbc>] (bus_remove_driver) from [<c0081cdc>] (SyS_delete_module+0x108/0x194)
> [   82.216417] [<c0081cdc>] (SyS_delete_module) from [<c000e7a0>] (ret_fast_syscall+0x0/0x30)
> [   82.224672] Code: c089ecf0 c0786790 e92d4010 e1a04000 (e5d03364)
> [   82.231059] ---[ end trace e485a1b642f0d1d1 ]---
> Segmentation fault

After nothing but insmod:

> root@localhost:~# rmmod atmel_mxt_ts
> [   25.499625] Alignment trap: not handling instruction e1923f9f at [<c05ec6d8>]
> [   25.506763] Unhandled fault: alignment exception (0x001) at 0x6b6b6cc7
> [   25.513298] Internal error: : 1 [#1] PREEMPT SMP ARM
> [   25.518260] Modules linked in: atmel_mxt_ts(-)
> [   25.522724] CPU: 0 PID: 831 Comm: rmmod Not tainted 3.16.0-rc7-next-20140729-00011-gead0778e710c-dirty #7
> [   25.532277] task: ea205380 ti: e97d0000 task.ti: e97d0000
> [   25.537674] PC is at _raw_spin_lock_irqsave+0x2c/0x64
> [   25.542724] LR is at devres_remove+0x20/0x80
> [   25.546988] pc : [<c05ec6dc>]    lr : [<c02dec90>]    psr: 20000193
> [   25.546988] sp : e97d1ed0  ip : e9b5b5c0  fp : 00000800
> [   25.558446] r10: c039dee4  r9 : e97d0000  r8 : c039c278
> [   25.563662] r7 : e9a7d400  r6 : ea1a7a54  r5 : 6b6b6cc7  r4 : 6b6b6b6b
> [   25.570178] r3 : e97d0000  r2 : 6b6b6cc7  r1 : 00000001  r0 : 20000113
> [   25.576696] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   25.583905] Control: 10c5387d  Table: a996406a  DAC: 00000015
> [   25.589641] Process rmmod (pid: 831, stack limit = 0xe97d0240)
> [   25.595464] Stack: (0xe97d1ed0 to 0xe97d2000)
> [   25.599816] 1ec0:                                     e9a7d400 e9a7d400 00000000 ea1a7a54
> [   25.607983] 1ee0: 00000081 c000e924 00000000 c02df508 e9a7d400 c039de9c e8c16b80 bf0003a4
> [   25.616148] 1f00: 00000019 e8c16b80 bf003660 bf000418 ea1a7a20 c03bbe24 c03bbde0 c02dc12c
> [   25.624313] 1f20: bf003660 ea1a7a20 bf003660 c02dc910 bf003660 bf003704 00000800 c02dbfbc
> [   25.632478] 1f40: 00000000 c0081cdc e9fe0e78 00000000 bf003704 00000800 e97d1f4c 656d7461
> [   25.640644] 1f60: 786d5f6c 73745f74 00000000 ea20587c 00000000 c08c0d74 00000800 c0039d60
> [   25.648808] 1f80: e9b8d880 e97d0000 e97d0000 e97d0000 c000e924 00010ef0 b6fe7d08 00000002
> [   25.656973] 1fa0: 00000000 c000e7a0 b6fe7d08 00000002 b6fe7d38 00000800 7a392d00 7a392d00
> [   25.665138] 1fc0: b6fe7d08 00000002 00000000 00000081 b6fe7d08 b6fe7008 be857858 00000800
> [   25.673303] 1fe0: b6f0f070 be8575d4 b6f8a2e9 b6f0f07c 80000010 b6fe7d38 00000000 00000000
> [   25.681479] [<c05ec6dc>] (_raw_spin_lock_irqsave) from [<c02dec90>] (devres_remove+0x20/0x80)
> [   25.689999] [<c02dec90>] (devres_remove) from [<c02df508>] (devres_destroy+0x8/0x24)
> [   25.697738] [<c02df508>] (devres_destroy) from [<c039de9c>] (input_unregister_device+0x28/0x70)
> [   25.706435] [<c039de9c>] (input_unregister_device) from [<bf0003a4>] (mxt_free_object_table+0x14/0x58 [atmel_mxt_ts])
> [   25.717037] [<bf0003a4>] (mxt_free_object_table [atmel_mxt_ts]) from [<bf000418>] (mxt_remove+0x30/0x44 [atmel_mxt_ts])
> [   25.727813] [<bf000418>] (mxt_remove [atmel_mxt_ts]) from [<c03bbe24>] (i2c_device_remove+0x44/0x5c)
> [   25.736940] [<c03bbe24>] (i2c_device_remove) from [<c02dc12c>] (__device_release_driver+0x70/0xc4)
> [   25.745891] [<c02dc12c>] (__device_release_driver) from [<c02dc910>] (driver_detach+0xac/0xb0)
> [   25.754494] [<c02dc910>] (driver_detach) from [<c02dbfbc>] (bus_remove_driver+0x4c/0x90)
> [   25.762579] [<c02dbfbc>] (bus_remove_driver) from [<c0081cdc>] (SyS_delete_module+0x108/0x194)
> [   25.771184] [<c0081cdc>] (SyS_delete_module) from [<c000e7a0>] (ret_fast_syscall+0x0/0x30)
> [   25.779438] Code: e2811001 e5831004 f592f000 e1923f9f (e2831801)
> [   25.785524] ---[ end trace fd2f70b3c6f48889 ]---
> [   25.790136] note: rmmod[831] exited with preempt_count 1
> Segmentation fault

