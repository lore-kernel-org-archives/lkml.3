Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3KRQls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:41:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57688 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3KRQll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:41:41 -0500
Message-ID: <528A4340.3020508@ti.com>
Date: Mon, 18 Nov 2013 10:41:36 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
References: <1384568535-26611-1-git-send-email-nm@ti.com> <20131116134445.GI11014@S2101-09.ap.freescale.net> <CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com> <528A27F8.3070402@ti.com> <20131118155753.GU11014@S2101-09.ap.freescale.net>
In-Reply-To: <20131118155753.GU11014@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:57 AM, Shawn Guo wrote:
> On Mon, Nov 18, 2013 at 08:45:12AM -0600, Nishanth Menon wrote:
> <snip>
>> I do not agree about this stance - device tree describes hardware
>> capabilities to kernel -> I agree with that statement. Kernel should
>> not care if that is provided by bootloader/firmware/fused into
>> flash/ROM etc.
> 
> Yea, ideally kernel should just believe that the device tree is always
> the correct one.  But the following text in your commit log suggests
> that might not be always the case.
> 
> | a) older or default bootloader in development platform without latest
> | updates
> | b) SoC documentation update that may have occurred in kernel
> | c) kernel definitions are out of date Vs bootloader which is updated
> | etc..
> | 
> | In these cases, we should assume from a kernel perspective, the only
> | safe frequency that the system can be on is the ones available in the
> | OPP table. This may not handle case (c), but, that is a different
> | kernel bug of it's own.
> 
> It says that the device tree might be wrong as well.  That's why I
> think the best/safest thing that kernel can do when seeing a mismatch
> is to throw out an error message and fail out.

In the case of mismatch, to consider that device tree may be wrong in
driver is also to assume that hardware was always configured correctly
and we assume description is the flawed data. That is just plain
wrong. we need to assume device tree is the correct description of the
hardware and any mismatch must be assumed as bad configuration - and
this is what the patch does.

Now, if the description is wrong, that is a dts bug of it's own.

If the suggestion is to improve my commit message, I am more than
happy to do so - please suggest how I could improve the same.

> 
> Shawn
> 
>>
>> If we agree with that statement, the moment kernel sees device
>> operating in a configuration that is not hardware capability, it is
>> our job to switch to the right configuration if it is possible for us
>> to do so (which in this case, we can). to give a comparison - if i2c
>> bus was configured for 3.4MHz and device tree describes the bus to
>> operate at 100KHz, do we ignore device tree recommended configuration?
>> No. we would switch to 100KHz. as far as kernel is concerned, it can
>> detect invalid configuration and switch back to a valid configuration
>> based on hardware description provided by device tree.
>>
>>
>>
>> -- 
>> Regards,
>> Nishanth Menon
> 


-- 
Regards,
Nishanth Menon
