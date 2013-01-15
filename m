Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3AOGkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:40:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39947 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3AOGkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:40:03 -0500
Message-ID: <50F4F9EB.3010405@ti.com>
Date: Tue, 15 Jan 2013 12:10:43 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast receiver
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com> <1357742770-15028-2-git-send-email-mark.rutland@arm.com> <alpine.LFD.2.02.1301141204421.7475@ionos> <20130114112951.GC7990@e106331-lin.cambridge.arm.com> <alpine.LFD.2.02.1301141247020.7475@ionos> <20130114121247.GD7990@e106331-lin.cambridge.arm.com> <alpine.LFD.2.02.1301141318460.7475@ionos> <20130114153612.GF7990@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130114153612.GF7990@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013 09:06 PM, Mark Rutland wrote:
> On Mon, Jan 14, 2013 at 02:17:26PM +0000, Thomas Gleixner wrote:
>> On Mon, 14 Jan 2013, Mark Rutland wrote:
>>> On Mon, Jan 14, 2013 at 11:50:55AM +0000, Thomas Gleixner wrote:
>>>> On Mon, 14 Jan 2013, Mark Rutland wrote:
>>>>
>>>>> On Mon, Jan 14, 2013 at 11:06:31AM +0000, Thomas Gleixner wrote:
>>>>>> On Wed, 9 Jan 2013, Mark Rutland wrote:
>>>>>>> +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
>>>>>>> +extern int tick_receive_broadcast(void);
>>>>>>> +#else
>>>>>>> +static inline int tick_receive_broadcast(void)
>>>>>>> +{
>>>>>>> +	return 0;
>>>>>>> +}
>>>>>>
>>>>>> What's the inline function for? If an arch does not have broadcasting
>>>>>> support it should not have a receive broadcast function call either.
>>>>>
>>>>> That was how this was originally structured [1], but Santosh suggested this
>>>>> would break the build for !GENERIC_CLOCKEVENTS_BROADCAST [1]. It means that the
>>>>> arch-specific receive path (i.e. IPI handler) doesn't have to be #ifdef'd,
>>>>> which makes it less ugly.
>>>>
>>>> Hmm. If you want to keep the IPI around unconditionally the inline
>>>> makes some sense, though the question is whether keeping an unused IPI
>>>> around makes sense in the first place. I'd rather see a warning that
>>>> an unexpected IPI happened than a silent inline function being called.
>>>
>>> How about I add a warning (e.g. "Impossible timer broadcast received.") and
>>> return -EOPNOTSUPP when !GENERIC_CLOCKEVENTS_BROADCAST?
>>
>> You still need to do something with the return value in the arch IPI
>> code, right?
>
> Good point. Having the stub when !CONFIG_GENERIC_CLOCKEVENTS_BROADCAST is
> clearly problematic.
>
> I'll go with your original suggestion, removing the tick_receive_broadcast stub
> for !CONFIG_GENERIC_CLOCKEVENTS_BROADCAST and I'll #idef the IPI_TIMER handler.
> That way it'll fall down to the standard warning for an unexpected/unknown IPI
> for arch/arm at least.
>
The alternative is fine by me.

Regards
santosh

