Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaBYMzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:55:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54235 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752922AbaBYMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:55:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
Date: Tue, 25 Feb 2014 14:10:23 +0100
Message-ID: <3894986.dK3STNSG71@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponr5b8nBaV9TFiiFkvyg8Qb6qz_0UXbYCaFRPG=XP28rA@mail.gmail.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <530C2FD7.4000105@linux.vnet.ibm.com> <CAKohponr5b8nBaV9TFiiFkvyg8Qb6qz_0UXbYCaFRPG=XP28rA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 11:38:14 AM Viresh Kumar wrote:
> On 25 February 2014 11:23, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > Hmm, that's a good point. However, lets first think about the simple scenario
> > that the driver _is_ able to detect the current frequency from the hardware
> > (a non-zero, sane value) say X KHz, and that frequency is different from what
> > the cpufreq subsystem thinks it is (Y KHz).
> >
> > In the current code, when we observe this, we send out a notification and try
> > to adjust to X KHz. Instead, what I'm suggesting is to invoke the driver to
> > set the frequency to Y KHz, since that's what the cpufreq subsystems wants the
> > frequency to be at.
> 
> Actually we don't know at this point what cpufreq wants :)
> Governor will decide what frequency to run CPU at and lets leave it to
> that point.
> As the transition that we might end up doing here would be simply overridden
> very soon. And to be honest this decision must be taken by governor and not
> core. We just want to make sure core is in sync with hardware.

Well, why exactly does the core need to operate "current frequency" at all?

Rafael

