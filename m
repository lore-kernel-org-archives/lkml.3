Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3FRNpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:45:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45585 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab3FRNpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:45:06 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-96-51c0645fd703
Date: Tue, 18 Jun 2013 15:44:56 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Message-id: <20130618154456.56d99e18@amdc308.digital.local>
In-reply-to: <3258927.Qds4G9CTyG@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <20130617155156.4c729b5a@amdc308.digital.local>
 <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
 <3258927.Qds4G9CTyG@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgG58yoFAg50PVS0aroZY/Hm7nNXi
	adMPdot5n2UtOs8+YbboXXCVzeLNI26Ly7vmsFl87j3CaHG7cQWbRf/CXiaLjiPfmC02fvVw
	4PW4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj8ya5ANYoLpuU1JzMstQifbsErowzk/+xFyzRqdj6
	TrqBsU2pi5GTQ0LAROLYny2MELaYxIV769lAbCGBRYwS3z95dTFyAdntTBIzdnxjBUmwCKhK
	NF6/xw5iswnoSXy++5QJxBYBim958p8dpIFZYB6LxMS2A2BThQU8JM4dmQZm8wpYS1xY85sF
	xOYUMJDY+X81M8SGJ4wS384fA0vwC0hKtP/7wQxxkp3EuU8b2CGaBSV+TL4HVsMsoCWxeVsT
	K4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTHz
	THoH46oGi0OMAhyMSjy8CWL7A4VYE8uKK3MPMUpwMCuJ8CokHggU4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwCjNLra4xeuDt94Ml7fzDzEwRN5cmnk6
	6Wb6mtqFmjsCU2oyGcxXNKYtir26SMcpM/qr0rbzLjwHl15fcsaVp2NjStSVbY4Tmle2Ttoi
	uWVxZUDZS73sC8LrnEO5jhZukt7x6E6x7ctlKQsnfevPFus+8MZMWlOX7eQJy9SCGwzMm49w
	VtoV/FViKc5INNRiLipOBACz/MsilQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 15:26:16 +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 18, 2013 12:12:13 PM Viresh Kumar wrote:
> > On 17 June 2013 19:21, Lukasz Majewski <l.majewski@samsung.com>
> > wrote:
> > > On Mon, 17 Jun 2013 18:40:50 +0530, Viresh Kumar wrote:
> > >> >> > The core acpi-cpufreq.c code hadn't been changed by me, so I
> > >> >> > assume that it will work as before.
> > >> >>
> > >> >> That should adapt your patch in your patchset.
> > >
> > > Could you explain what do you mean?
> > 
> > Update acpi-cpufreq to use your infrastructure.
> > 
> > >> >> From sysfs?? I thought we are going to have some automatic
> > >> >> control of this stuff from inside kernel.
> > >> >
> > >> > From sysfs I just enable the boost. I do not order from
> > >> > userpace the cpufreq to run with a particular (boosted)
> > >> > frequency.
> > >> >
> > >> > When I enable boost - I ask (politely) the cpufreq core to
> > >> > reevaluate policies and when applicable increase policy->max.
> > >> >
> > >> > Then governor can use this new frequencies for normal
> > >> > operation.
> > >>
> > >> So, with your current patchset in, ondemand or conservative
> > >> governors will start using boost frequencies. Which might burn
> > >> your chip.
> > >
> > > Two scenarios:
> > > 1. Thermal framework is compiled in and enabled (for exynos/other
> > > SoC) -> trip point is reached -> boost is disabled -> frequency
> > > is reduced -> SoC is cooled down.
> > >
> > > I think, that thermal framework is a good "safe valve" here.
> > 
> > Even in this case boost shouldn't have been enabled by default.
> > Its not only about burning the chip but more than that.
> > 
> > According to my understanding, boost was important for power
> > saving. In case a high load can be managed by a single cpu with
> > boost freqs, then its better to use boost freqs rather than bringing
> > another cpu up.
> 
> Do you mean the 'boost' sysfs attribute or the 'turbo frequencies'
> concept?
> 
> > Normally boost freqs are not so useful if we talk about powersaving,
> > as their energy consumption is much higher with not so great impact
> > on performance.
> 
> Er, er, please be careful here.  The impact on performance may be
> sufficient for deep C-states to become relevant in some cases.
> 
> > That's why when this thread started we talked about boost only when
> > one cpu is operational. But with your patch all cores can use boost
> > freq and thermal will come into picture just to save the chip.
> 
> Well, that's why on x86 turbo is controlled by hardware that takes
> care of keeping things within the chip's thermal limits.

And this is the reason why I don't want to overly change acpi-cpufreq.c
code. :-)

> 
> > That's wrong. This isn't why we invented boost here. Otherwise you
> > just don't need boost feature at all for your SoC. Just make these
> > freqs as available freqs and let thermal control policy->max/min
> > to save your chip.
> 
> The 'boost' attribute added by acpi-cpufreq means "let the hardware
> use turbo frequencies".

This is HW managed. We only enable the switch and then simply forget
about it.

> 
> I'd recommend you both to read Documentation/cpu-freq/boost.txt
> now. :-)


According to the documentation:
"Reading the file is always supported, even if the processor does not
support boosting. In this case the file will be read-only and always
reads as "0""

Hmm, in the proposed patch set, the "boost" attribute is only exported
when cpufreq driver sets boost_supported flag. 



> 
> I think we can extend the meaning to "let turbo frequencies be used",
> but if we need software to play the role of the hardware's thermal
> control, we need to be very careful.
> 
> > > 2. Thermal framework is disabled and user has enabled boost and
> > > used ondemand / conservative governor.
> > > Then execute gzip < /dev/urandom > /dev/null & (on all cores).
> > >
> > > Then yes, chip will hang/burn due to crossing operating point (or
> > > burn).
> > >
> > >
> > > What other means of control (despite of thermal) would you
> > > consider applicable?
> > >
> > > What comes to my mind is modifying governor logic to count how
> > > long the CPU run with boost enabled and then disable it.
> > 
> > Its not about how long.. One cpu type can work longer with boost
> > freq compared to other.
> > 
> > What we probably need is:
> > - Enabled boost from sysfs if required (now below steps will come
> > into picture)
> 
> This has to be compatible with the existing stuff.
> 
> > - See how many cpus are running, if only one then start using boost
> > freqs
> > - Now thermal should be come into picture to save chip in case a
> > single cpu running at boost can burn it out.
> 
> I'd say there needs to be a separate controller/monitor for that that
> will know what the chip's thermal limit is and how that relates to
> how fast the CPU core(s) may run and for how much time.  I'm not sure
> it is sufficient to "wait for thermal to kick in" here, because you
> may need to slow down things in advance (i.e. before thermal sensors
> tell you there's too much heat, because that may be too late already).

I think that thermal subsystem shall be the second option to disable SW
boosting.

The main control shall be done inside the cpufreq core. The idea to
disable boost when more than one core is active is rational.

I'm going to implement this concept at v4.

> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
