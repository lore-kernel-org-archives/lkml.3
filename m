Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3A2GnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:43:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37992 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3A2GnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:43:13 -0500
Message-ID: <51076FA2.9070002@ti.com>
Date: Tue, 29 Jan 2013 12:13:46 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Sealey <matt@genesi-usa.com>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben@simtec.co.uk>, Ingo Molnar <mingo@redhat.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <20130121232322.GK15361@atomide.com> <50FE307F.9000701@ti.com> <201301220931.24570.arnd@arndb.de> <50FE666B.10902@ti.com> <20130122145113.GK23505@n2100.arm.linux.org.uk> <50FEAABA.6050307@ti.com> <510615F8.7010203@ti.com> <5107114C.4070307@linaro.org>
In-Reply-To: <5107114C.4070307@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon,

On Tuesday 29 January 2013 05:31 AM, John Stultz wrote:
> On 01/27/2013 10:08 PM, Santosh Shilimkar wrote:
>> On Tuesday 22 January 2013 08:35 PM, Santosh Shilimkar wrote:
>>> On Tuesday 22 January 2013 08:21 PM, Russell King - ARM Linux wrote:
>>>> On Tue, Jan 22, 2013 at 03:44:03PM +0530, Santosh Shilimkar wrote:

[..]

>>> Thanks for expanding it. It is really helpful.
>>>
>>>> And I think further discussion is pointless until such research has
>>>> been
>>>> done (or someone who _really_ knows the time keeping/timer/sched code
>>>> inside out comments.)
>>>>
>>> Fully agree about experimentation to re-asses the drift.
>>>  From what I recollect from past, few OMAP customers did
>>> report the time drift issue and that is how the switch
>>> from 100 --> 128 happened.
>>>
>>> Anyway I have added the suggested task to my long todo list.
>>>
>> So I tried to see if any time drift with HZ = 100 on OMAP. I ran the
>> setup for 62 hours and 27 mins with time synced up once with NTP server.
>> I measure about ~174 millisecond drift which is almost noise considering
>> the observed duration was ~224820000 milliseconds.
>
> So 174ms drift doesn't sound great, as < 2ms (often much less - though
> that depends on how close the server is) can be expected with NTP.
> Although its not clear how you were measuring: Did you see a max 174ms
> offset while trying to sync with NTP? Was that offset shortly after
> starting NTP or after NTP converged down?
>
To avoid the server latency, we didn't do continuous sync. The time was 
synced in the beginning and after 62.5 hours (#ntpd -qg) and the drift
of about 174 ms was observed. As you said this could be because of
server sync time along with probably some addition from system calls
from #ntpd. As mentioned, the other run with HZ = 128 which started
15 hours 20 mins is already showing about 24 mS drift now. I will
let it run for couple of more days just to have similar duration run.

Regards,
santosh



