Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaENJbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:31:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53518 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaENJbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:31:32 -0400
Message-ID: <537337F3.4080300@arm.com>
Date: Wed, 14 May 2014 10:31:31 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, Will Deacon <Will.Deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com> <20140422103642.GF7484@arm.com> <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com> <20140423170821.GJ5649@arm.com> <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com> <5360FB07.5030407@arm.com> <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com> <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com> <20140513184503.GF16388@arm.com> <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
X-OriginalArrivalTime: 14 May 2014 09:31:38.0613 (UTC) FILETIME=[4E748250:01CF6F57]
X-MC-Unique: 114051410313001801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/05/14 03:28, Neil Zhang wrote:
>> -----Original Message-----
>> From: Will Deacon [mailto:will.deacon@arm.com]
>> Sent: 2014年5月14日 2:45
>> To: Neil Zhang
>> Cc: Sudeep Holla; 'linux@arm.linux.org.uk';
>> 'linux-arm-kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org';
>> 'devicetree@vger.kernel.org'
>> Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
>>
>> On Mon, May 12, 2014 at 11:22:09AM +0100, Neil Zhang wrote:
>>>>> The device tree bindings for power domains is under discussion [1]
>>>>
>>>> Thanks for the information.
>>>> But it currently for device only, core related stuff are not supported.
>>>> And is it really good to register power provider for core and let
>>>> vfp / pmu etc to get it?
>>>>
>>>
>>> What's your suggestion about it?
>>> Is it OK that I add it under the PMU node?
>>
>> I don't really mind. I just want to avoid re-inventing the wheel in a
>> PMU-specific way and having to maintain that code forever because it ended
>> up in our DT description.
>>
>> Will
>
> I will prepare another patch to add DT description under PMU since there is
> no generic power domain support for pm notifier if no other concerns.
> We can change the manner if there is generic power domain support for pm notifier later.
> Thanks.

No, please don't add any DT bindings for power domains specific to PMU node.
We can't change the DT bindings once added.

As I pointed out the DT bindings for generic power domains are under discussion.
See if you can reuse it, if not help in extending it so that it can be used.

Regards,
Sudeep



