Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967238AbaLLLrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:47:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53531 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966333AbaLLLrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:47:11 -0500
Message-ID: <548AD5B7.7070402@linux.vnet.ibm.com>
Date: Fri, 12 Dec 2014 17:17:03 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Santosh Shukla <santosh.shukla@linaro.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86 Ivybridge
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com> <54883DB6.10504@linux.vnet.ibm.com> <CAKohpokJxXe2RNc4Jqb20PJo2adr49nKBbzdXzYk9=H4kNjfRQ@mail.gmail.com> <54892111.3000102@linux.vnet.ibm.com> <CA+iXiiOR+dhXis5FMXnBw+rohgFe8gG3qk4=ChMTbG+Cdb1iwg@mail.gmail.com>
In-Reply-To: <CA+iXiiOR+dhXis5FMXnBw+rohgFe8gG3qk4=ChMTbG+Cdb1iwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121211-0005-0000-0000-00000716638B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 10:26 AM, Santosh Shukla wrote:
> On 11 December 2014 at 10:14, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> On 12/10/2014 06:22 PM, Viresh Kumar wrote:
>>> On 10 December 2014 at 18:03, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>>>
>>>> Right. We get an interrupt when nobody had asked for it to be delivered
>>>> or had asked for it to be delivered and later canceled the request. It
>>>> is most often in the latter situation, that there can be race
>>>> conditions. If these race conditions are not taken care of, they can
>>>> result in spurious interrupts.
>>>
>>> But the delta time will be very small then, right ?
>>
>> I was talking of the case where we get an interrupt from the clockevent
>> device but dont find the hrtimer to service and not really of an anomaly
>> in timekeeping.
>>    For instance one of the issues that we had seen earlier wherein we
>> cancel the tick-sched-timer before going tickless, but since we had
>> programmed the clock event device to fire, we get a spurious interrupt.
>>
> 
> I verified this case before reporting; In my case tick_sched_timer do
> get cancelled before expire duration but then  clk_evt_device get
> reprogrammed for next time node in list.  __remove_hrtimer() takes
> care of that.

Right. The scenario I described happens in the Low Resolution Mode. You
are right, this does not happen in the High Resolution Mode.

Regards
Preeti U Murthy

