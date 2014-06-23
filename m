Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaFWWYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:24:48 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44864 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaFWWYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:24:46 -0400
Message-ID: <53A8A917.8090706@gmail.com>
Date: Tue, 24 Jun 2014 00:24:23 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>, Doug Anderson <dianders@chromium.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>	<7h8uosyc3k.fsf@paris.lan>	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>	<7hwqcbs166.fsf@paris.lan>	<CAD=FV=Uz9O0i2gmuk2+BHa-Tksvyxv0+MTi2UEjVREAMNCK7Ug@mail.gmail.com>	<7h7g4brx6w.fsf@paris.lan>	<CAD=FV=VmPMf6tCNmKJ1o5J7PyAXoU8fb6+s+Fkv18FH2WaQp7A@mail.gmail.com>	<53A4CADA.4030002@gmail.com>	<CAD=FV=VkxA01eEFiXSp+c+GDuVJi7TctAdnyrMggk1gRw6BStQ@mail.gmail.com> <7ha993p8v4.fsf@paris.lan>
In-Reply-To: <7ha993p8v4.fsf@paris.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.2014 00:19, Kevin Hilman wrote:
> Doug Anderson <dianders@chromium.org> writes:
> 
> [...]
> 
>> On Fri, Jun 20, 2014 at 4:59 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>>
>>> I'm not sure noirq is going to work correctly, at least not with current
>>> callbacks. I can see a call to clk_prepare_enable() there which needs to
>>> acquire a mutex.
>>
>> Nice catch, thanks!  :)
>>
>> OK, looking at that now.  Interestingly this doesn't seem to cause us
>> problems in our ChromeOS 3.8 tree.  I just tried enabling:
>>   CONFIG_DEBUG_ATOMIC_SLEEP=y
>>
>> ...and confirmed that I got it on right:
>>
>> # zgrep -i atomic /proc/config.gz
>> CONFIG_DEBUG_ATOMIC_SLEEP=y
>>
>> I can suspend/resume with no problems.  My bet is that it works fine because:
>>
>> * resume_noirq is not considered "atomic" in the sense enforced by
>> CONFIG_DEBUG_ATOMIC_SLEEP (at least not in 3.8--I haven't tried on
>> ToT)
> 
> The reason is because "noirq" in the suspend/resume path actually means
> no *device* IRQs for that specific device.
> 
> It's often assumed that the "noirq" callbacks are called with *all*
> interrupts disabled, but that's not the case.  Only the IRQs for that
> specific device are disabled when its noirq callbacks run.

Thanks for clarifying this. This means that we should be fine with the
noirq variant then.

Best regards,
Tomasz
