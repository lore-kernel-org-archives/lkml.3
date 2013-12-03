Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3LCFsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:48:06 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61010 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3LCFsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:48:03 -0500
MIME-Version: 1.0
In-Reply-To: <2171422.pY15ZQme4E@vostro.rjw.lan>
References: <0875dc1b263f39081232c560fc72c15cd42dfc6f.1385734305.git.viresh.kumar@linaro.org>
	<529CA5D5.9010008@gmail.com>
	<2171422.pY15ZQme4E@vostro.rjw.lan>
Date: Tue, 3 Dec 2013 11:18:01 +0530
Message-ID: <CAKohpo=mqqCjjOpEAMHo385h=DVcw3Hn9GX9yGXFP_YHcyNBtw@mail.gmail.com>
Subject: Re: [PATCH V4 1/2] cpufreq: Mark x86 drivers with CPUFREQ_SKIP_INITIAL_FREQ_CHECK
 flag
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2013 04:03, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, December 02, 2013 07:23:01 AM Dirk Brandewie wrote:
>> Sorry for late response to these threads.  Holiday weekend in the US.

No issues.

>> NAK for intel_pstate.  The code that will use this flag also uses has_target()
>> which is false for intel_pstate.
>
> Is your point that intel_pstate doesn't need to have this flag set?

Probably yes as intel_pstate would never share freq-table. Will fix this.

>> I still believe that this bug should be dealt with in platform specific code
>> since this is working around a bootloader bug.  Are there platforms in the wild
>> that even need this code or is this to support early platform bringup?
>
> All it takes to introduce it is to use a buggy bootloader, so I guess
> there's a number of potentially affected platforms out there.

Yeah. This was first reported for OMAP SoC's though.

> This really isn't about which individual platforms have the problem, but about
> which platforms have the property that the clock *can* be set to a wrong
> frequency initially.  These are the ones we need to worry about regardless,
> because we can't control boot loaders and duplicating the same code in
> a number of drivers doesn't sound like a good approach.
>
> So the only reasonable way forward I can see is to flag either the platforms
> that we need to worry about, or the platforms that we don't need to worry
> about and use that to decide whether or not to do the check.

To be honest Rafael suggested exactly this initially, i.e. set flag for all the
drivers which want this to be done and I thought the number of drivers that
don't want it would be lesser and so it would be easier to set this flag there.

But looking at the logic Dirk gave, it makes sense to do this for drivers which
want this feature to be enabled. Moreover we really can't say for how long
these drivers will continue keeping this flag as I don't really think its a bug.
Kernel can't expect bootloaders to set core to a frequency which should be
exactly same as what cpufreq table has. And so this flag may stay until
cpufreq is around :)

I will send updated patches soon..

--
viresh
