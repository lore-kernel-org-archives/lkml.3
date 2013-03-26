Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3CZCTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:19:52 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:60634 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3CZCTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:19:50 -0400
Message-ID: <515105C2.9060002@gmail.com>
Date: Mon, 25 Mar 2013 21:19:46 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <20130325172633.GP30923@n2100.arm.linux.org.uk> <5150C16A.3040208@gmail.com> <201303252236.23270.arnd@arndb.de> <5150D54D.1070004@linaro.org>
In-Reply-To: <5150D54D.1070004@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 05:53 PM, John Stultz wrote:
> On 03/25/2013 03:36 PM, Arnd Bergmann wrote:
>> On Monday 25 March 2013, Rob Herring wrote:
>>> I count integrator-cp, realview, versatile and non-DT VExpress that do
>>> this (not surprisingly) and 25 platforms or timer implementations plus
>>> arm64 that do sched_clock setup in time_init. What's broken by not
>>> moving these earlier?
>> timekeeping_init() will leave the persistent_clock_exist variable as
>> "false",
>> which is read in rtc_suspend() and timekeeping_inject_sleeptime().
> 
> Are you mixing up the persistent_clock and sched_clock here? From a
> generic stand-point they have different requirements.

Yes. We're talking about sched_clock here. What would be the benefit of
having it setup before sched_init vs. later in time_init?

Rob

