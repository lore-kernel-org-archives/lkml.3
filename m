Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbaGRAoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:44:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54980 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753245AbaGRAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:44:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nishanth Menon <nm@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Simon Horman <horms@verge.net.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Rob Herring <rob.herring@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
Date: Fri, 18 Jul 2014 03:02:49 +0200
Message-ID: <2399813.Puj1SZWhCh@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org> <20140717093518.486ac244@free-electrons.com> <CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 17, 2014 01:11:45 PM Viresh Kumar wrote:
> On 17 July 2014 13:05, Thomas Petazzoni
> <thomas.petazzoni@free-electrons.com> wrote:
> > Could you summarize what is the issue with the binding?
> >
> > At least for the case where we have one clock per CPU, the DT binding
> > is really dead simple: each CPU node can carry a "clocks" property, and
> > a "clock-latency" property. I really don't see why a long discussion is
> > needed to agree on such a binding.
> >
> > Now, if the DT binding problem is related to those cases where you have
> > siblings, i.e one clock controlling *some* of the CPUs, but not all
> > CPUs or just one CPU, then maybe we could leave this aside for now,
> 
> Yeah, we are stuck on that for now.
> 
> > only support the following cases:
> >
> >  * One clock for all CPUs
> >  * One clock for each CPU
> 
> Yeah, so I also proposed this yesterday that we stick to only these
> two implementations for now. And was looking at how would the
> cpufreq-generic driver come to know about this.
> 
> So, one way out now is to see if "clocks" property is defined in
> multiple cpu nodes, if yes don't compare them and consider separate
> clocks for each cpu. We don't have to try matching that to any other
> node, as that's a very bad idea. Mike was already very upset with that :)
> 
> @Stephen/Rafael: Does that sound any better? Ofcourse the final thing
> is to get bindings to figure out relations between CPUs..

Before I apply anything in this area, I need a clear statement from the ARM
people as a group on what the approach is going to be.

Rafael

