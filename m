Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaKOBHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:07:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56381 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaKOBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:07:23 -0500
Message-ID: <5466A754.7060904@wwwdotorg.org>
Date: Fri, 14 Nov 2014 18:07:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Mark Rutland <mark.rutland@arm.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code
 from ARM to kernel
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>	<20141110095325.GC12126@ulmo>	<CAOMFOmXpAm5iKCLFyorTW+n9YmgZMmrDGGe736tJX8C6BYQv-A@mail.gmail.com>	<alpine.DEB.2.11.1411132334400.3935@nanos> <CAOMFOmVziftM=pWGG-L9J-E6AHYAK7k9bmBcpS1adPboLciX9g@mail.gmail.com>
In-Reply-To: <CAOMFOmVziftM=pWGG-L9J-E6AHYAK7k9bmBcpS1adPboLciX9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 03:03 PM, Anatol Pomozov wrote:
> Hi
>
> On Thu, Nov 13, 2014 at 2:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Mon, 10 Nov 2014, Anatol Pomozov wrote:
>>> On Mon, Nov 10, 2014 at 1:53 AM, Thierry Reding
>>> <thierry.reding@gmail.com> wrote:
>>>> On Fri, Nov 07, 2014 at 11:34:15AM -0800, Anatol Pomozov wrote:
>>>>> ARM timekeeping functionality allows to register persistent/boot clock dynamically.
>>>>> This code is arch-independent and can be useful on other plaforms as well.
>>>>>
>>>>> As a byproduct of this change, tegra20_timer becomes ARM64 compatible.
>>>>>
>>>>> Tested: backported the change to chromeos-3.14 kernel ran on tegra 64bit
>>>>> board, made sure high-resolution clock works.
>>>>
>>>> Using this on an upstream kernel doesn't work, though, because 64-bit
>>>> ARM doesn't implement struct delay_timer which the driver needs since
>>>> v3.17.
>>>>
>>>> But I suppose the delay timer infrastructure could be moved into the
>>>> core similar to the persistent and boot clock as this patch does.
>>>
>>> Thanks. It makes sense, I will send it in a separate patch, once this
>>> one will be reviewed. On our kernel I haven't seen this issue as we
>>> still use 3.14.
>>
>> That's why you should test/compile your stuff on latest greatest and
>> not on a year old conglomorate of unknown provenance. :)
>
> Unfortunately it is not possible to test this patch with upstream.
> There is no ARM64 bit support for Tegra yet. I am trying to
> cleanup/upstream my ChromeOS patches and this clock patch in
> particular makes one small step towards this goal. Also Thierry
> mentioned that he works on full ARM64 Tegra support and it is really
> exciting!

What we usually do is send patches in the order the kernel boot process 
needs them. First modify the kernel to know about 64-bit Tegra, add 
earlyprintk support, make sure the early boot process spits out 
something on the UART, then add whatever next item is missing (e.g. 
clock driver, timers, ...). That way, every patch we apply can actually 
be tested in the mainline kernel, since the code actually reaches that 
point in execution.

If we were for example to send in a ton of driver patches for ARM64 
right now, we couldn't test them. Quite possibly those patches wouldn't 
fully work, and we'd just have churn fixing them up later once the base 
CPU/SoC support was added. It's better to only upstream patches that can 
actually be exercised in order to avoid that churn.
