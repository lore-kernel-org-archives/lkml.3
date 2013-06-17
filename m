Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3FQJIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:08:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55283 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab3FQJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:08:37 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-d3-51bed2148867
Date: Mon, 17 Jun 2013 11:08:11 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
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
Message-id: <20130617110811.1e1805d2@amdc308.digital.local>
In-reply-to: <CAKohpo=nfuqwCoQJRczmNRNXCOTL5FSJQEzjKpVdXU+wu-KJ1g@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-2-git-send-email-l.majewski@samsung.com>
 <CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
 <20130617091549.398b865f@amdc308.digital.local>
 <CAKohpo=nfuqwCoQJRczmNRNXCOTL5FSJQEzjKpVdXU+wu-KJ1g@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgK7IpX2BBnvXS1s0XA2x+PN2OavF
	06Yf7BbzPstadJ59wmzRu+Aqm8WbR9wWl3fNYbP43HuE0eJ24wo2i/6FvUwWHUe+MVts/Orh
	wOtx59oeNo91094ye/RtWcXo8WhxC6PH501yAaxRXDYpqTmZZalF+nYJXBlbG5qYC+7bVew4
	MJOlgfGeXhcjJ4eEgInEo413mCBsMYkL99azdTFycQgJLGKU+PbhMhOE084ksW36JzaQKhYB
	VYkT/1sYQWw2AT2Jz3efAhVxcIgIaEm8vJkKEmYWmMkicfq3IogtLOAhce7INLByXgFribtf
	zjCD2JwCwRId7y4yQsz/yySxecZOdpAEv4CkRPu/H8wQF9lJnPu0gR2iWVDix+R7LBALtCQ2
	b2tihbDlJTavecs8gVFwFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OGaeSe1gXNlgcYhRgINRiYd3Q/W+QCHWxLLiytxDjBIczEoivLETgUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYUxV4lhV8znzTYCO//oDdnxthh349
	nvuDt2BqDNsZmdrPvQW926+vOrkzom6dv33i1vnOD5YudhOt7382v6XihsyOe8bfeHew/tO2
	/Nz+NW9V19/GtROT3j+73z/bpfT7/qTX8w6xcdQkW7ofFc1ZoBgYsP6t+xP9y0WNLxzEgz4I
	ZR7qujfntxJLcUaioRZzUXEiACBeTTCVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 09:43:27 +0200, Viresh Kumar wrote:
> On 17 June 2013 12:45, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Mon, 17 Jun 2013 11:13:18 +0530, Viresh Kumar wrote:
> >> On 14 June 2013 13:08, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> > +int cpufreq_boost_trigger_state(int state) +{
> 
> >> > +       if (!cpufreq_driver->boost_supported)
> >> > +               return -ENODEV;
> >>
> >> This can't happen. sysfs directory is present only when we
> >> have boost supported.
> >
> > I know, that we shall not look into the future. But this method
> > will be used when somebody would like to enable boost from kernel.
> > Let's say new governor or such :-).
> 
> We don't know if that would be acceptable or not as of now.
> 
> > I can remove this and add it later, but I think, that it is safer to
> > add it straightaway.
> 
> Remove it for now.

Ok.

> 
> >>
> >> > +       if (cpufreq_boost_enabled != state) {
> >> > +               if (cpufreq_driver->set_boost_freq) {
> >> > +                       ret =
> >> > cpufreq_driver->set_boost_freq(state);
> >>
> >> I thought this routine was for setting boost frequency and not
> >> for enabling boost feature. If boost has to be enabled separately
> >> then this routine must take care of it while setting freq.
> >>
> >> So, in other words, this must not be called here.
> >
> > This function explicitly follows current logic of acpi-cpufreq.c.
> >
> > I would like to avoid modifying legacy/working code as much as
> > possible (especially when I hadn't yet received any feedback about
> > acpi-cpufreq.c file changes).
> 
> Hmm.. I saw that code now. You are talking about: boost_set_msrs ??
> 
> So, this function has nothing to do with set_boost_freq() but
> enable_boost(). Rename your function similarly and keep this code.

Ok.

> 
> >> > +                       if (ret) {
> >> > +                               pr_err("%s: BOOST cannot enable
> >> > (%d)\n",
> >> > +                                      __func__, ret);
> >> > +                               return ret;
> >> > +                       }
> >> > +               }
> >> > +
> >> > +               for_each_possible_cpu(cpu) {
> >> > +                       policy = cpufreq_cpu_get(cpu);
> >>
> >> In case this code is required, it would make more sense to keep
> >> list of all available policies, which we can iterate through.
> >
> > Maybe I don't get the big picture, but why we cannot iterate
> > through possible CPUs? At least one shall have valid policy and
> > freq_table combination.
> 
> Many cpus share same policy structure and so iterating over all of
> them isn't a very good idea. Either keep a mask of cpus already
> iterated, copy policy->cpus to it on each iteration. If a cpu is
> already done skip loop for it.

This is the situation, which I wanted to avoid. Policy has the
policy->cpus mask already implemented, but we don't know how/where to
hook to them (one solution would be to start from cpu0, but for some
reason I'm reluctant to do it in this way).

> 
> OR keep a list of policies. I would prefer the later (do it in a
> separate patch), as this can be used later too.

I will declare a boost_policy list at cpufreq.c. Then I will add policy
to it, when cpufreq_add_dev() is called.

> 
> > I've already proposed list of all policies (at v1), but we decided
> > to abandon this idea.
> 
> I don't remember why it was there but reason wasn't good enough to
> keep it.

:-). Lets try with list.

> 
> >> I am not sure if this is required at all. Or what complications
> >> can be there when we update max/min on the fly here.
> >
> > Correct me if I'm wrong, but I'm using scripts for tests which run
> > simultaneously and enables/disables boost feature. I don't recall if
> > there is a lock at sysfs, which would prevent from simultaneous
> > write to the "boost" sysfs attribute.
> >
> > I will doubble check that.
> 
> It isn't about a crash but how cpufreq subsystem works. I will think
> over it later too, for now you can keep it.

OK.

> 
> >> > +{
> >> > +       return cpufreq_boost_enabled;
> >>
> >> s/cpufreq_boost_enabled/boost_enabled
> 
> ??

I will change the name.

> 
> >> > @@ -318,6 +322,10 @@ __ATTR(_name, _perm, show_##_name, NULL)
> >> >  static struct freq_attr _name =                        \
> >> >  __ATTR(_name, 0644, show_##_name, store_##_name)
> >> >
> >> > +#define cpufreq_attr_available_freq(_name)       \
> >> > +struct freq_attr cpufreq_freq_attr_##_name##_freqs =     \
> >> > +__ATTR_RO(_name##_frequencies)
> >>
> >> What is this doing in cpufreq.h? It will only be used by
> >> freq_table.c file.
> >
> > I wanted to add those #defines to the place where other similar ones
> > are placed.
> 
> That's not how these or any other declaration should be placed. By
> adding these to cpufreq.h, you are inviting other parts of kernel to
> use them. Which we don't want.
> 
> > I can put it to freq_table.c.
> 
> Thanks.

Ok. I will keep the code local.

> 
> >> Again, I couldn't see how boost freqs are getting used? You have
> >> probably made them part of normal freq range here and so they
> >> might be used during normal operations. But we wanted it to be
> >> used only when we have few cpus on... etc.. Where is that logic?
> >
> > The logic is as follow:
> > - cpufreq_driver exports .attr field. When driver supports boost
> > then two attributes are exported (even when boost is not enabled,
> > but supported):
> >         - scaling_available_frequencies (only normal frequencies -
> > this attribute is unchanged)
> >         - scaling_boost_frequencies - list possible boost
> > frequencies.
> >
> > When boost is not supported - then only
> > scaling_available_frequencies is exported (as it is done now).
> 
> You are missing the whole point behind keeping this patchset. Its not
> about how to expose boost freqs to sysfs (that's what you are talking
> about) but to use these frequencies on the fly. 

Two separate things:

1. I think, that scaling_available_frequencies [*] attribute has to
   stay unchanged (this is how userspace sees the API). Linus would
   we very unhappy :-) if we had changed public API.

   x86 guys, please correct me, but I think that [*] will be not
   changed (expanded) when Intel's HW boost is enabled at acpi-cpufreq.c
   code.

   The scaling_boost_frequencies is only visible when driver (and
   probably soc maintainer) is ready to handle boosting. It shows over
   clocked frequencies.

2. How we would control boost?
   - To enable this you must mark IDs for some freqs as
     CPUFREQ_BOOST_FREQ.
   - The cpufreq_boost.boost_supported flag needs to be true (set at
     cpufreq driver code)
   - One needs to enable boosting by sysfs or call
     cpufreq_boost_trigger_state(1); The latter will not work when
     cpufreq_driver->boost_supported is not set.

I assume that when somebody takes those three above steps, then he is
aware that boost is working on his machine.

How one can control the boost? I'm now (on my setup) using thermal
subsystem. I set proper trip points and when one of them is met, then
boost is disabled. Moreover the thermal governor (stepwise) also
reduces frequency.

It works stable with v3.10 (with 3.8 there were some bugs - now they
are fixed).


The core acpi-cpufreq.c code hadn't been changed by me, so I assume
that it will work as before.

> Some part of kernel
> code would be setting these frequencies in real hardware. Who will
> set these frequencies? 

Those freqs are set by ->target() callback (when allowed)

> On what basis? How do we ensure we don't
> burn your chip?

Thermal subsystem is a good example here. Another may be a
governor, or even scheduler.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
