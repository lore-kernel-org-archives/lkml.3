Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3KSRKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:10:33 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33124 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3KSRKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:10:30 -0500
MIME-Version: 1.0
In-Reply-To: <528B884C.7070908@ti.com>
References: <1384568535-26611-1-git-send-email-nm@ti.com>
	<20131116134445.GI11014@S2101-09.ap.freescale.net>
	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>
	<528A27F8.3070402@ti.com>
	<20131118155753.GU11014@S2101-09.ap.freescale.net>
	<528A4340.3020508@ti.com>
	<20131119022133.GB18434@S2101-09.ap.freescale.net>
	<CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>
	<528B72C1.5060006@ti.com>
	<CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>
	<528B7CE5.5040502@ti.com>
	<CAKohponO7M6rYoPt=ePNTZh=y+iU=BEbFWBqxr1JQPbVptvgXA@mail.gmail.com>
	<528B884C.7070908@ti.com>
Date: Tue, 19 Nov 2013 22:40:29 +0530
Message-ID: <CAKohpo=brpnLe68ExPRPg9h5ABMhg+GS85Ebn-+S5-vWaStrPQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2013 21:18, Nishanth Menon <nm@ti.com> wrote:
> is that true for userspace governor
> (CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)?
> /sys/devices/system/cpu/cpu0/cpufreq $ cat scaling_available_frequencies
> 500000 1000000 1500000
>
> /sys/devices/system/cpu/cpu0/cpufreq $ cat scaling_cur_freq
> 1100000

No, but userspace governor must take care of this stuff as it want's
to change freq from userspace..

> OMAP5-UEVM will remain at this frequency for a long period of time
> with AVS voltage(Adaptive Voltage Scaling technique used in OMAP to
> optimize operational voltage) that was meant for 1GHz! that is
> definitely not stable if there is no further transition to a valid
> frequency.

I understand that point, but will this stay for a long time at that freq?
Why aren't governors coming into picture here?

> An alternative might be to ensure CPUFREQ_GOV_LIMITS takes care of that?

Again, I don't see if we really really need to do this at all..
