Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936454AbaH1Jt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:49:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38870 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936348AbaH1Jt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:49:27 -0400
Message-ID: <53FEFB42.5060600@arm.com>
Date: Thu, 28 Aug 2014 10:49:54 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        "byungchul.park@lge.com" <byungchul.park@lge.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "arm64: use cpu_online_mask when using forced
 irq_set_affinity"
References: <1409131806-11276-1-git-send-email-byungchul.park@lge.com> <20140828093826.GC22580@arm.com>
In-Reply-To: <20140828093826.GC22580@arm.com>
X-OriginalArrivalTime: 28 Aug 2014 09:49:23.0288 (UTC) FILETIME=[58D68580:01CFC2A5]
X-MC-Unique: 114082810492507601
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/08/14 10:38, Will Deacon wrote:
> On Wed, Aug 27, 2014 at 10:30:06AM +0100, byungchul.park@lge.com wrote:
>> From: Byungchul Park <byungchul.park@lge.com>
>>
>> This reverts commit 601c942176d8ad8334118bddb747e3720bed24f8.
>>
>> This patch is designed to ensure that the cpu being offlined is not
>> present in the affinity mask. But it is a bad idea to overwrite the
>> affinity variable with cpu_online_mask, even in case that the current
>> affinity already includes onlined cpus.
>>
>> So revert this patch to replace it with another one doing exactly
>> what it intends.
>
> Sudeep: what's the right way forward for this? There seems to be general
> agreement that the existing code is broken, but a bunch of different
> `fixes'. Can we just take a straight port of what tglx proposed for ARM?
> (changing force to false)
>

Yes I agree but for that we need agreement from rmk and hence I asked to
wait till we hear from rmk. Main issue raised by rmk is if some other
interrupt controller implementation decide not to migrate away when
force is false(theoretically possible).

Regards,
Sudeep

