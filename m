Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaJTJPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:15:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51619 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaJTJPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:15:35 -0400
Message-ID: <5444D2E0.9070205@arm.com>
Date: Mon, 20 Oct 2014 10:16:16 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, Will Deacon <Will.Deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
References: <20140423170821.GJ5649@arm.com> <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com> <5360FB07.5030407@arm.com> <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com> <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com> <20140513184503.GF16388@arm.com> <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com> <537337F3.4080300@arm.com> <9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com> <9034CBD80F070943B59700D7F8149ED90182308172@SC-VEXCH4.marvell.com> <20140703175706.GI17372@arm.com> <9034CBD80F070943B59700D7F8149ED9024EB81CD8@SC-VEXCH4.marvell.com>
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9024EB81CD8@SC-VEXCH4.marvell.com>
X-OriginalArrivalTime: 20 Oct 2014 09:15:33.0838 (UTC) FILETIME=[6715C6E0:01CFEC46]
X-MC-Unique: 114102010153327201
Content-Type: text/plain; charset=GBK; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 20/10/14 09:46, Neil Zhang wrote:
>
>
>> -----Original Message----- From: Will Deacon
>> [mailto:will.deacon@arm.com] Sent: 2014Äê7ÔÂ4ÈÕ 1:57 To: Neil Zhang
>> Cc: Sudeep Holla; 'linux@arm.linux.org.uk'; 'linux-arm-
>> kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org';
>> 'devicetree@vger.kernel.org' Subject: Re: [PATCH v4] ARM: perf:
>> save/restore pmu registers in pm notifier
>>
>> On Mon, Jun 30, 2014 at 11:39:15AM +0100, Neil Zhang wrote:
>>>>>> I will prepare another patch to add DT description under
>>>>>> PMU since there is no generic power domain support for pm
>>>>>> notifier if no other concerns. We can change the manner if
>>>>>> there is generic power domain support for pm notifier
>>>>>> later. Thanks.
>>>>>
>>>>> No, please don't add any DT bindings for power domains
>>>>> specific to PMU node. We can't change the DT bindings once
>>>>> added.
>>>>>
>>>>> As I pointed out the DT bindings for generic power domains
>>>>> are under discussion. See if you can reuse it, if not help in
>>>>> extending it so that it can be used.
>>>>>
>>>> Sorry for reply later. As I said before the under discussed
>>>> generic power domain is not suitable for CPU peripherals since
>>>>  they are all known belong to CPU or cluster power domain. If
>>>> we want to follow the way they are discussion, we need to
>>>> register core and cluster power provider, and need vfp/gic/pmu
>>>> etc to require them.
>>>> Is it really suitable?
>>>>
>>> Do you have any comments? If no, I would like to put it under PMU
>>> node.
>>
>> Sudeep is a better person to comment than me, but I'd still rather
>>  this was handled more generically as opposed to a PMU-specific
>> hack. I don't see a problem including GIC and VFP here, but only
>> when we actually need to save/restore them (i.e. what the hardware
>>  guys went crazy with the power domains).
>>
>
> Long time no follow up for this loop. Sorry that I will pick it
> again.
>
Yes, the generic PD got added in v3.18-rc1, it's better to check if we
can reuse it. I will also have a look at that and think about how we can
use it.

> Will, I prefer to check always-on field under PMU node to check
> whether we need Save/restore them.
>
But how do you handle it for different idle states. e.g. if CPU is in
retention, PMU's *might be* retained. Also I don't think PMUs will be
placed in "always-on" power domain like timers. So using "always-on"
sounds incorrect to me.

Regards,
Sudeep

