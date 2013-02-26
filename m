Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3BZNFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:05:08 -0500
Received: from mail1.sysgo.com ([176.9.26.183]:58761 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3BZNFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:05:07 -0500
Message-ID: <512CB301.8020208@sysgo.com>
Date: Tue, 26 Feb 2013 14:05:05 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: timekeeping_adjust may set mult to 0
References: <511912BB.2060602@sysgo.com> <CANcMJZAuKo9yQkErDZYtBx-Bm92hMAG3SDK-DJRPn=m=T9hcag@mail.gmail.com>
In-Reply-To: <CANcMJZAuKo9yQkErDZYtBx-Bm92hMAG3SDK-DJRPn=m=T9hcag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.02.2013 23:34, schrieb John Stultz:
> On Mon, Feb 11, 2013 at 7:48 AM, David Engraf <david.engraf@sysgo.com> wrote:
>> I have encountered a problem when a linux system uses a clocksource with
>> mult = 1 and shift = 0 (clocksource cycle = nanoseconds). It may happen that
>> the function timekeeping_adjust reduces the value of mult to 0 when error is
>> lower than the interval [1].
>> As soon as timekeeper.mult is 0, ktime_get will no longer work because it
>> uses timekeeping_get_ns which converts the cycle to nanoseconds with mult as
>> 0 and the system clocksource returns always 0.
>
> So you *don't* want to use shift=0, since that kills the ability for
> the frequency adjustment code to do anything, as you've found.

The problem is not shift=0 it's mult=1. The frequency adjustment code 
may increase/decrease mult and mult=0 will not work.

> Instead of calculating the clocksource mult/shift pair yourself,
> please use clocksource_register_hz/khz().

Thanks, I will try it.

Best regards
- David

> I'm hoping to kill off the open clocksource_register() call soon, to
> avoid this sort of confusion. Sorry for the trouble.
>
> thanks
> -john
>

