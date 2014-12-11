Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaLKE4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:56:17 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50925 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaLKE4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:56:16 -0500
MIME-Version: 1.0
In-Reply-To: <54892111.3000102@linux.vnet.ibm.com>
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
	<54883DB6.10504@linux.vnet.ibm.com>
	<CAKohpokJxXe2RNc4Jqb20PJo2adr49nKBbzdXzYk9=H4kNjfRQ@mail.gmail.com>
	<54892111.3000102@linux.vnet.ibm.com>
Date: Thu, 11 Dec 2014 10:26:14 +0530
Message-ID: <CA+iXiiOR+dhXis5FMXnBw+rohgFe8gG3qk4=ChMTbG+Cdb1iwg@mail.gmail.com>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86 Ivybridge
From: Santosh Shukla <santosh.shukla@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 December 2014 at 10:14, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 12/10/2014 06:22 PM, Viresh Kumar wrote:
>> On 10 December 2014 at 18:03, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>>
>>> Right. We get an interrupt when nobody had asked for it to be delivered
>>> or had asked for it to be delivered and later canceled the request. It
>>> is most often in the latter situation, that there can be race
>>> conditions. If these race conditions are not taken care of, they can
>>> result in spurious interrupts.
>>
>> But the delta time will be very small then, right ?
>
> I was talking of the case where we get an interrupt from the clockevent
> device but dont find the hrtimer to service and not really of an anomaly
> in timekeeping.
>    For instance one of the issues that we had seen earlier wherein we
> cancel the tick-sched-timer before going tickless, but since we had
> programmed the clock event device to fire, we get a spurious interrupt.
>

I verified this case before reporting; In my case tick_sched_timer do
get cancelled before expire duration but then  clk_evt_device get
reprogrammed for next time node in list.  __remove_hrtimer() takes
care of that.

And in case there is no timer in list; We shut down the
clk_evt_device. Therefore no spurious interrupt in either of two
possible cases.
