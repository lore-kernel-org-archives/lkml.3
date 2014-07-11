Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaGKJM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:12:29 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1915 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaGKJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:12:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Jul 2014 02:01:26 -0700
Date: Fri, 11 Jul 2014 12:12:07 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
Message-ID: <20140711091207.GY23218@tbergstrom-lnx.Nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
 <1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com>
 <CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpom9ORXFiUU4=V+CxgN0ZOFLMEhEjHiU8HsYUYDybNXgHQ@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:35:56AM +0200, Viresh Kumar wrote:
> Hi Tuomas,
> 
> On 11 July 2014 03:12, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> > Add a new cpufreq driver for Tegra124. Instead of using the PLLX as
> > the CPU clocksource, switch immediately to the DFLL. It allows the use
> > of higher clock rates, and will automatically scale the CPU voltage as
> > well. We also rely on the DFLL driver to determine the CPU clock
> > frequencies that the chip supports, so that we can directly build a
> > cpufreq table with the OPP library helper dev_pm_opp_init_cpufreq_table.
> >
> > This driver is a completely independent of the old cpufreq driver
> > (tegra-cpufreq), which is only used on Tegra20.
> >
> > Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> 
> Please reuse cpufreq-cpu0 instead of adding a new driver. Similar
> is being adopted by all platforms now: krait, mvebu, etc..

I don't think that's going to work? The voltage scaling is handled in hw.
cpufreq-cpu0 seems to assume explicit sw control of the vdd_cpu regulator?

Cheers,

Peter.
