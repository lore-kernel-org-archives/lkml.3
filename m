Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaIXPzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:55:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40347 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIXPze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:55:34 -0400
Message-ID: <5422E974.3090506@arm.com>
Date: Wed, 24 Sep 2014 16:55:32 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] clocksource: arm_arch_timer: discard unavailable timers
 correctly
References: <1410911445-19067-1-git-send-email-sudeep.holla@arm.com> <1410982774-4724-1-git-send-email-sudeep.holla@arm.com> <5422E05F.4070405@arm.com> <20140924154802.GK5729@leverpostej>
In-Reply-To: <20140924154802.GK5729@leverpostej>
X-OriginalArrivalTime: 24 Sep 2014 15:55:32.0554 (UTC) FILETIME=[F8B1BAA0:01CFD80F]
X-MC-Unique: 114092416553206501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/09/14 16:48, Mark Rutland wrote:
> On Wed, Sep 24, 2014 at 04:16:47PM +0100, Sudeep Holla wrote:
>> Hi Mark,
>>
>> On 17/09/14 20:39, Sudeep Holla wrote:
>>> Currently we wait until both cp15 and mem timers are probed if we
>>> have both timer device nodes present in the device tree without
>>> checking if the device is actually available. If one of the timer
>>> device node present is disabled, the system locks up on the boot
>>> as no timer gets registered.
>>>
>>> This patch adds the check for the availablity of the timer device
>>> so that we unavailable timers are discarded correctly. It also adds
>>> the missing of_node_put.
>>>
>>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>
>> If your are fine with this, can I ask Daniel you pick this up ?
>
> While I'd prefer to see the cp15 and mmio timer driver pulled apart,
> that's not going to happen at any point soon. For the moment, this is

Agreed :)

> far better than the current state of affairs. So:
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
>

Thanks

Regards,
Sudeep

