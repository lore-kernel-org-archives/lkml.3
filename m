Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaFKAPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:15:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62147 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752183AbaFKAPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:15:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, dirk.j.brandewie@intel.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] cpufreq: intel_pstate: Remove duplicate CPU ID check
Date: Wed, 11 Jun 2014 02:32:41 +0200
Message-ID: <3882689.ERRzduavD8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53973CF5.4000201@intel.com>
References: <53962059.6070306@semaphore.gr> <CAKohpokABMSRr88Tf=+Kn4b4=r7ThE+mjdAZcU+dvo28b47Kcg@mail.gmail.com> <53973CF5.4000201@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 10, 2014 10:14:29 AM Dirk Brandewie wrote:
> On 06/09/2014 10:21 PM, Viresh Kumar wrote:
> > On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> >> We check the CPU ID during driver init. There is no need
> >> to do it again per logical CPU initialization.
> >>
> >> So, remove the duplicate check.
> >>
> >> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> >> ---
> >>   drivers/cpufreq/intel_pstate.c | 6 ------
> >>   1 file changed, 6 deletions(-)
> >>
> >> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> >> index aebd457..4e7f492 100644
> >> --- a/drivers/cpufreq/intel_pstate.c
> >> +++ b/drivers/cpufreq/intel_pstate.c
> >> @@ -691,14 +691,8 @@ MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
> >>
> >>   static int intel_pstate_init_cpu(unsigned int cpunum)
> >>   {
> >> -
> >> -       const struct x86_cpu_id *id;
> >>          struct cpudata *cpu;
> >>
> >> -       id = x86_match_cpu(intel_pstate_cpu_ids);
> >> -       if (!id)
> >> -               return -ENODEV;
> >> -
> >>          all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
> >>          if (!all_cpu_data[cpunum])
> >>                  return -ENOMEM;
> >
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> >
> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

[1/7] applied, please wait with the rest until after 3.16-rc1 is released.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
