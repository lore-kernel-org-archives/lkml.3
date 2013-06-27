Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3F0SOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab3F0SOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:14:36 -0400
Message-ID: <51CC80E4.8060801@redhat.com>
Date: Thu, 27 Jun 2013 20:13:56 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com> <51CC0566.8010302@redhat.com> <20130627094307.GC8437@lukather> <51CC0BC3.5090309@redhat.com> <20130627165436.GB4319@lukather>
In-Reply-To: <20130627165436.GB4319@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/27/2013 06:54 PM, Maxime Ripard wrote:
> On Thu, Jun 27, 2013 at 11:54:11AM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 06/27/2013 11:43 AM, Maxime Ripard wrote:
>>> On Thu, Jun 27, 2013 at 11:27:02AM +0200, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 06/26/2013 11:16 PM, Maxime Ripard wrote:
>>>>> Hi everyone,
>>>>>
>>>>
>>>> <snip>
>>>>
>>>>> It also finally adds a clocksource from the free running counter found in the
>>>>> A10/A13 SoCs.
>>>>
>>>> Hmm, have you benchmarked this? There have been reports from linux-sunxi kernel
>>>> users (xbmc project) that the waiting for the latch is quite slow. Note we
>>>> don't have anything better yet in the linux-sunxi kernel.
>>>
>>> No. I didn't.
>>>
>>> Do you have any pointers to these discussions?
>>>
>>
>> The original discussion should be somewhere here:
>> https://groups.google.com/forum/#!forum/linux-sunxi
>>
>> But I could not find it (it is probably hidden under
>> an unlogical subject).
>
> I searched a bit and it seems to be that discussion:
> https://groups.google.com/d/msg/linux-sunxi/gaTDngPT7Is/oeLtWb1N1wIJ
>
>> Looking at my own notes (a small TODO file), I've
>> written down that the reporter reports:
>>
>>   -current clocksource can cause us to run with interrupts disabled for 17%
>>    of the time, see "perf top" output
>>
>> This is with a workload which does a lot of gettimeofday
>> calls.
>
> Siarhei however notes that even higher-end SoCs like the exynos5 have
> similar performances with that regard. So I'm not sure we can do
> something about it, except what is suggested in the above mail, which
> looks rather unsafe.
>
> Anyway, like you said, we have no easy other solution, and we lacked
> such support until now.
>
> So why not merge this code for now, and try to optimise it later if we
> find it's needed.

That is fine with me, I just wanted to share that this has shown as
a bottleneck in some benchmarks in case anyone has a clever idea to
fix it ...

Regards,

Hans
