Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab3F0JzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab3F0JzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:55:00 -0400
Message-ID: <51CC0BC3.5090309@redhat.com>
Date: Thu, 27 Jun 2013 11:54:11 +0200
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
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com> <51CC0566.8010302@redhat.com> <20130627094307.GC8437@lukather>
In-Reply-To: <20130627094307.GC8437@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/27/2013 11:43 AM, Maxime Ripard wrote:
> On Thu, Jun 27, 2013 at 11:27:02AM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 06/26/2013 11:16 PM, Maxime Ripard wrote:
>>> Hi everyone,
>>>
>>
>> <snip>
>>
>>> It also finally adds a clocksource from the free running counter found in the
>>> A10/A13 SoCs.
>>
>> Hmm, have you benchmarked this? There have been reports from linux-sunxi kernel
>> users (xbmc project) that the waiting for the latch is quite slow. Note we
>> don't have anything better yet in the linux-sunxi kernel.
>
> No. I didn't.
>
> Do you have any pointers to these discussions?
>

The original discussion should be somewhere here:
https://groups.google.com/forum/#!forum/linux-sunxi

But I could not find it (it is probably hidden under
an unlogical subject).

Looking at my own notes (a small TODO file), I've
written down that the reporter reports:

  -current clocksource can cause us to run with interrupts disabled for 17%
   of the time, see "perf top" output

This is with a workload which does a lot of gettimeofday
calls.

I notice that unlike the sunxi-3.4 code you don't do any locking,
so how do you stop 2 clocksource calls from racing (and thus
getting a possible wrong value because of things not
being properly latched) ?

Regards,

Hans
