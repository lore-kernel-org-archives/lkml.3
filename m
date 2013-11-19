Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3KSOQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:16:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51589 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3KSOQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:16:38 -0500
Message-ID: <528B72C1.5060006@ti.com>
Date: Tue, 19 Nov 2013 08:16:33 -0600
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
References: <1384568535-26611-1-git-send-email-nm@ti.com>	<20131116134445.GI11014@S2101-09.ap.freescale.net>	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>	<528A27F8.3070402@ti.com>	<20131118155753.GU11014@S2101-09.ap.freescale.net>	<528A4340.3020508@ti.com>	<20131119022133.GB18434@S2101-09.ap.freescale.net> <CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>
In-Reply-To: <CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:46 PM, Viresh Kumar wrote:
> On 19 November 2013 07:51, Shawn Guo <shawn.guo@linaro.org> wrote:
>> No, I did not say that.  IMO, when cpufreq-cpu0 sees a mismatch, it has
>> no way to know or assume which one is correct and which is incorrect.
>> The best thing it can do is to fail out without changing anything about
>> running frequency and voltage.
> 
> Not specifically on this patch, but this is what I feel about this issue:
> 
> - As we are discussing on the other thread, there is scope of adding
> "unknown" field in tables so that people would know that they were
> running out of table freq at some point..

Consider something like userspace governor selection -> the device at
boot will probably remain in an unknown/"invalid" configuration till
the very first transition attempt. I am less worried about the stats
than not following what the hardware description is (as stated by
device tree/other forms).

I staunchly disagree that at a point of mismatch detection, we just
refuse to load up cpufreq governor -even though we know from device
tree/other alternative entries what the hardware behavior is supposed
to be. To refuse to loadup to a known configuration is considering the
"valid configuration" data provided to the driver is wrong - an
equivalent(considering the i2c example) is that if i2c driver sees bus
configured for 3.4MHz and was asked to use 100KHz, it just refuses to
load up!

> - This is a common problem for all drivers/platforms and not only
> cpufreq-cpu0, so the solution has to be generic and not driver
> specific.. So, atleast I don't want to get this patch in at any cost,
> unless there is a generic solution present..
> - There are non-dt drivers as well, and so freq table is present
> with the kernel and we can't support all frequencies that bootloader
> may end up with..
The above two are fair comments -> but that implies that policy->cur
population should no longer be the responsibility of cpufreq drivers
and be the responsibility of cpufreq core. are we stating we want to
move that to cpufreq core?

-- 
Regards,
Nishanth Menon
