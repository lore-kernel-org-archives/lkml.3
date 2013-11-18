Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab3KROpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:45:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51265 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3KROpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:45:17 -0500
Message-ID: <528A27F8.3070402@ti.com>
Date: Mon, 18 Nov 2013 08:45:12 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, Shawn Guo <shawn.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
References: <1384568535-26611-1-git-send-email-nm@ti.com>	<20131116134445.GI11014@S2101-09.ap.freescale.net> <CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>
In-Reply-To: <CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 10:02 PM, Viresh Kumar wrote:
> On 16 November 2013 19:14, Shawn Guo <shawn.guo@linaro.org> wrote:
>> No, it's not a kernel bug.
>>
>> OPP is not a definition that belongs to kernel.  Instead, it's
>> characteristics of hardware, and that's why we can naturally put the
>> definition into device tree.  Bear it in mind that device tree is a
>> hardware description and should be OS agnostic.  So it shouldn't be
>> treated as part of Linux kernel in any case, even though the device
>> tree source is currently maintained in kernel tree.
>>
>> Device tree is designed as a way for firmware/bootloader to describe
>> hardware to kernel.  That said, device tree is more part of bootloader
>> than kernel.  If bootloader runs at a frequency that does not match the
>> OPP in device tree, the one should be fixed is either bootloader or
>> device tree but never kernel.
> 
> I agree for all that..

I do not agree about this stance - device tree describes hardware
capabilities to kernel -> I agree with that statement. Kernel should
not care if that is provided by bootloader/firmware/fused into
flash/ROM etc.

If we agree with that statement, the moment kernel sees device
operating in a configuration that is not hardware capability, it is
our job to switch to the right configuration if it is possible for us
to do so (which in this case, we can). to give a comparison - if i2c
bus was configured for 3.4MHz and device tree describes the bus to
operate at 100KHz, do we ignore device tree recommended configuration?
No. we would switch to 100KHz. as far as kernel is concerned, it can
detect invalid configuration and switch back to a valid configuration
based on hardware description provided by device tree.



-- 
Regards,
Nishanth Menon
