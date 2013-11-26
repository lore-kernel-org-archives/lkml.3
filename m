Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3KZUIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:08:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51824 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755228Ab3KZUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:08:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Tue, 26 Nov 2013 21:21:23 +0100
Message-ID: <2309056.KUZA1Fnj0Y@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpon22PxGdTFcaOqzpLpVZd75OPP470Wyy95GjBhG2gViyQ@mail.gmail.com>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org> <2997050.eogEtPXZyL@vostro.rjw.lan> <CAKohpon22PxGdTFcaOqzpLpVZd75OPP470Wyy95GjBhG2gViyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 07:31:50 AM Viresh Kumar wrote:
> On 26 November 2013 02:43, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, November 25, 2013 09:43:59 AM Dirk Brandewie wrote:
> >> This is a platform specific bug fix AFAICT and belongs in a platform
> >> specific piece of code
> 
> In case we end up doing that, we will do lots of code redundancy in
> cpufreq drivers. And as Rafael said, some platforms might never
> know they have booted with an out of table frequency and so taking
> care of this at a single place is better, where we are sure that it
> will get fixed.
> 
> >> The core should not be working around bootloader bugs IMHO.  Silently
> >> fixing it is evil IMHO at a minimum the core should complain LOUDLY
> >> about this happening otherwise the bootloaders will have no incentive to
> >> get their act together.
> 
> That looks correct..
> 
> > Yes, we can add a WARN_ON() there.  Still, though, the core's responsibility
> > is to ensure that (a) either we can continue safely or (b) we can't, in which
> > case it should just fail the initialization.  Whether or not it should panic()
> > I'm not sure.
> 
> But is this that big crime, that we do a WARN on it? CPU was running on
> a workable frequency, it wasn't mentioned in the table, that's it.
> 
> Probably just throw an print message that CPU found to be running on
> out of table frequency, and that got fixed..

I was talking about the case when your

__cpufreq_driver_target(policy, policy->cur - 1, CPUFREQ_RELATION_L);

fails.  The other case is not really interesting.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
