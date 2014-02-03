Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBCGzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:55:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13312 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaBCGzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:55:01 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-09-52ef3d4199c7
Message-id: <52EF3D3C.8050704@samsung.com>
Date: Mon, 03 Feb 2014 10:54:52 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: John Stultz <john.stultz@linaro.org>
Cc: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org>
In-reply-to: <52DEC6A3.9020600@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xa7qOtu+DDF6cMLOYe/c8i8Wc9WvY
	LA5u1bS4/uU5q8WZ37oWZ5vesFtc3jWHzWLzpqnMDhweE/o/MXrcubaHzePduXPsHidm/Gbx
	6NuyitHj8ya5ALYoLpuU1JzMstQifbsEroyJBzgLLopU3D/8ibGB8bZAFyMnh4SAiUT7sQ8s
	ELaYxIV769lAbCGBpYwSj47IdDFyAdmfgeymdnaQBK+AlsSmux+YQWwWAVWJ+S8nAdkcHGwC
	BhL77tmCmKICERJHl2tCVAtK/Jh8D2y8iICGxMIlV5lARjILXGWU+Pp7EitIQljAVeLE9vWs
	EHvTJZqffQJbxQm0auP97UwgNrOAtcTKSdsYIWx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUo
	mlqaXFCclJ5rpFecmFtcmpeul5yfu4kREvBfdzAuPWZ1iFGAg1GJh/fB/ndBQqyJZcWVuYcY
	JTiYlUR4uwXeBwnxpiRWVqUW5ccXleakFh9iZOLglGpg7A8KENu4fkbf+/I+hp7PobxtZZvl
	51vfYL7Y2h33wWPrjQnvkpfK2/lWRYZcEX5ns7dny4HZE1NeO8vyPMg/oPmeZVaX//HfkS2O
	aybMvX+yUnLrlDXr9ba9WnfNsj225tDbK152x6L/sVavcl7LdjvXT0rbROmO+Repskv6B1N0
	FtgsfyAgrcRSnJFoqMVcVJwIAONqN25WAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear John, hello

could we figure out without Thomas advice?
Maybe it worth to propose timerfd and posix timer flag unification patch?

On 01/21/2014 11:12 PM, John Stultz wrote:
> On 01/13/2014 02:43 AM, Alexey Perevalov wrote:
>> Hello dear community.
>>
>> This is reworked patch set of original Anton's Vorontsov
>> proposal regarding unified deferrable timers in the user space.
>> http://lwn.net/Articles/514707/
>>
>>
>> I decided to resubmit it due we found it usefull for us too.
>>
>> timerfd was modified since Anton's commit, Alarm support was added.
>> This isn't only rebase. Anton's previous version used deferrable timer
>> in couple with hrtimer. This version uses only deferrable timer. It
>> mean the behaviour of overrun number is different.
>> e.g. if you don't poll one second timer for a 10 seconds - you'll get
>> 10 overruns with hrtimer, but for deferrable timer it could be another value.
>>
> Sorry, last week was a little crazy and I didn't get a chance to closely
> review this. But looking at this my major conceptual objection with the
> previous patchset (introducing the new clockid) is gone.
>
> My remaining conceptual concern here is that the TIMER_DEFERRABLE flag
> is a timerfd only construct here, and I worry we should make sure we
> think this through well enough that the same functionality can be
> supported via other timer interfaces (like clock_nanosleep, etc), which
> may mean the functionality should be pushed more deeply into the hrtimer
> subsystem.
>
> So main suggestion here is to make sure you cc Thomas Gleixner on future
> iterations, so he can provide some thoughts on what the best approach
> might be here. I know he also has some plans that might collide with the
> jiffies_to_ktime work.
>
> Thomas: Any thought here? Should we be trying to unify the timerfd flags
> and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
> which is currently timerfd-only)?  Should a deferrable flag be added to
> the hrtimer core or left to the timer wheel?
>
> thanks
> -john
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


-- 
Best regards,
Alexey Perevalov,
Leading software engineer,
phone: +7 (495) 797 25 00 ext 3969
e-mail: a.perevalov@samsung.com <mailto:a.perevalov@samsumng.com>

Mobile group, Samsung R&D Institute Rus
12 Dvintsev street, building 1
127018, Moscow, Russian Federation
