Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbbAVLHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:07:13 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:47544 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbbAVLHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:07:07 -0500
Message-ID: <54C0D9D7.4010903@ultimaker.com>
Date: Thu, 22 Jan 2015 12:07:03 +0100
From: Olliver Schinagl <o.schinagl@ultimaker.com>
Organization: Ultimaker B.V.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Olliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH] hrtimer: add hrtimer_start_now()
References: <1421907161-5744-1-git-send-email-o.schinagl@ultimaker.com> <alpine.DEB.2.11.1501221153320.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501221153320.5526@nanos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

On 22-01-15 12:01, Thomas Gleixner wrote:
> On Thu, 22 Jan 2015, Olliver Schinagl wrote:
>
>> From: Olliver Schinagl <oliver@schinagl.nl>
>>
>> When using a hrtimer for repeating periodic ticks, hrtimer_forward_now()
>> is often used. Quite possibly the timer loop is thus probably fully
>> controlled by hrtimer_forward_now() and we don't really care when the
>> timer is started. With hrtimer_start() we need to define exactly when a
>> event has to start. By introducing hrtimer_start_now() we do the same as
>> what hrtimer_forward_now() does, start as soon as possible and get into
>> the timer loop.
>   
>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
>> ---
>>   include/linux/hrtimer.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
>> index a036d05..080a5f5 100644
>> --- a/include/linux/hrtimer.h
>> +++ b/include/linux/hrtimer.h
>> @@ -353,6 +353,12 @@ static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
>>   /* Basic timer operations: */
>>   extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
>>   			 const enum hrtimer_mode mode);
>> +
>> +static inline int hrtimer_start_now(struct hrtimer *timer,
>> +				    const enum hrtimer_mode mode)
>> +{
>> +	return hrtimer_start(timer, timer->base->get_time(), mode);
>> +}
> What's the mode argument for? How is this supposed to do what you
> want:
>
>         hrtimer_start_now(timer, HRTIMER_MODE_REL);
Ah, of course, I guess we'd have to use a fixed default, my bad.
>
> Aside of that, what's wrong with doing:
>
>        static const ktime_t ktime_zero = { .tv64 = 0 };
>
>        hrtimer_start(timer, ktime_zero, HRTIMER_MODE_REL);
I guess the same could be said for hrtimer_forward_now I suppose. It was 
just intended as a little helper, with emphasis on helper.
Olliver
>
> Thanks,
>
> 	tglx

-- 
Met vriendelijke groeten, Kind regards, 与亲切的问候

Olliver Schinagl
Research & Development
Ultimaker B.V.
http://www.ultimaker.com

