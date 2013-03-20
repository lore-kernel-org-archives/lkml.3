Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3CTSAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:00:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1313 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3CTSAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:00:52 -0400
X-IronPort-AV: E=Sophos;i="4.84,880,1355126400"; 
   d="scan'208";a="31039871"
Message-ID: <5149F951.8050002@codeaurora.org>
Date: Wed, 20 Mar 2013 11:00:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCHv3 09/10] clocksource: time-armada-370-xp: Divorce from
 local timer API
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-10-git-send-email-sboyd@codeaurora.org> <5149ED53.5060002@free-electrons.com> <5149EFFA.1050408@codeaurora.org> <5149F13E.7060901@free-electrons.com> <5149F579.2080303@free-electrons.com>
In-Reply-To: <5149F579.2080303@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/13 10:44, Gregory CLEMENT wrote:
> On 03/20/2013 06:26 PM, Gregory CLEMENT wrote:
>> On 03/20/2013 06:20 PM, Stephen Boyd wrote:
>>> On 03/20/13 10:09, Gregory CLEMENT wrote:
>>>> On 03/13/2013 07:17 PM, Stephen Boyd wrote:
>>>>> Separate the armada 370xp local timers from the local timer API.
>>>>> This will allow us to remove ARM local timer support in the near
>>>>> future and makes this driver multi-architecture friendly.
>>>> At first view the code looks good, but when I applied your patch set on
>>>> linux-next, build it and run it on a Armada XP based board (AX3 with 2 cores),
>>>> it crashed:
>>> [...]
>>>> Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
>>>> Modules linked in:
>>>> CPU: 0    Not tainted  (3.9.0-rc3-next-20130319-00010-g728b448 #153)
>>>> PC is at 0xe92d45f0
>>>> LR is at armada_370_xp_timer_interrupt+0x3c/0x4c
>>>> pc : [<e92d45f0>]    lr : [<c023c2bc>]    psr: 600001d3
>>>> sp : c0635eb8  ip : 00000000  fp : c063c3f0
>>>> r10: 000003ff  r9 : 00000000  r8 : 00000010
>>>> r7 : c22b3c40  r6 : ef007c00  r5 : c0640fcc  r4 : c0053e30
>>>> r3 : e92d45f0  r2 : fffffffe  r1 : c22b3c40  r0 : c0053e30
>>>> Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
>>>> Control: 10c53c7d  Table: 0000406a  DAC: 00000015
>>>> Process swapper/0 (pid: 0, stack limit = 0xc0634238)
>>>> Stack: (0xc0635eb8 to 0xc0636000)
>>>> 5ea0:                                                       ef004c80 c0063224
>>>> 5ec0: 00000010 00000010 00000000 c0660ac0 c0635f18 c005fcb8 c0632b90 c000ed94
>>>> 5ee0: c0313c60 60000153 00000001 c00085a8 c0313c54 c0313c60 60000153 ffffffff
>>>> 5f00: c0635f4c 00000000 562f5842 c06360c0 00000000 c000db60 0000001a ffff8ad0
>>>> 5f20: ffff8ad0 c06360c0 00000000 00000000 c04379c0 c22ad780 00000000 562f5842
>>>> 5f40: c06360c0 00000000 60000153 c0635f60 c0313c54 c0313c60 60000153 ffffffff
>>>> 5f60: 00000021 00000000 00000003 00000004 0000006e c065fcc0 c067924c c063ceb8
>>>> 5f80: c063cc84 c006d8c0 00000005 c065fcc0 c067924c c0421764 c22ad780 c063c42c
>>>> 5fa0: 562f5842 c063cca8 c06605c0 c04379c0 c22ad780 00000000 562f5842 00000000
>>>> 5fc0: 00000000 c0417754 ffffffff ffffffff c04172dc 00000000 00000000 c04379c0
>>>> 5fe0: 10c53c7d c063c414 c04379bc c063febc 0000406a 00008074 00000000 00000000
>>>> [<c023c2bc>] (armada_370_xp_timer_interrupt+0x3c/0x4c) from [<c0063224>] (handle_percpu_devid_irq+0x64/0x80)
>>>> [<c0063224>] (handle_percpu_devid_irq+0x64/0x80) from [<c005fcb8>] (generic_handle_irq+0x20/0x30)
>>>> [<c005fcb8>] (generic_handle_irq+0x20/0x30) from [<c000ed94>] (handle_IRQ+0x38/0x90)
>>>> [<c000ed94>] (handle_IRQ+0x38/0x90) from [<c00085a8>] (armada_370_xp_handle_irq+0xa4/0xb0)
>>>> [<c00085a8>] (armada_370_xp_handle_irq+0xa4/0xb0) from [<c000db60>] (__irq_svc+0x40/0x50)
>>>> Exception stack(0xc0635f18 to 0xc0635f60)
>>>> 5f00:                                                       0000001a ffff8ad0
>>>> 5f20: ffff8ad0 c06360c0 00000000 00000000 c04379c0 c22ad780 00000000 562f5842
>>>> 5f40: c06360c0 00000000 60000153 c0635f60 c0313c54 c0313c60 60000153 ffffffff
>>>> [<c000db60>] (__irq_svc+0x40/0x50) from [<c0313c60>] (calibrate_delay+0x378/0x528)
>>>> [<c0313c60>] (calibrate_delay+0x378/0x528) from [<c0417754>] (start_kernel+0x250/0x2dc)
>>>> [<c0417754>] (start_kernel+0x250/0x2dc) from [<00008074>] (0x8074)
>>>> Code: 1fe7deb7 cd5772dd fff5692e ed55f79e (7ed5a5f7)
>>>>
>>>>
>>>>
>>>> I am trying to figure out what happened.
>>> Argh. Stupid casting again. Can you try this?
>> Our emails  must have crossed, your fix is also fine :)
>>
> I have also tested the patch set on a Armada 370 based board (Armada 370 DB),
> and it works well.
> So with this last chunk you can add my:
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> and also my
> tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>

Great. Thanks for testing.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

