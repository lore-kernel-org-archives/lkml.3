Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3GQLV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:21:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46754 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab3GQLVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:21:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@majess.pl>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Date: Wed, 17 Jul 2013 13:31:45 +0200
Message-ID: <2509113.ybUsa2l9tg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokw-bSWEgKvx0jd2QZ0RCz5dORHM9z+VYbTdKoCmKFvsg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <6633375.dICiDrHJgK@vostro.rjw.lan> <CAKohpokw-bSWEgKvx0jd2QZ0RCz5dORHM9z+VYbTdKoCmKFvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 17, 2013 01:28:29 PM Viresh Kumar wrote:
> On 20 June 2013 03:55, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, June 19, 2013 10:31:02 PM Lukasz Majewski wrote:
> >> On Wed, 19 Jun 2013 10:48:53 -0700
> >> Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> >>
> >> > On 06/19/2013 10:12 AM, Lukasz Majewski wrote:
> 
> >> > > @@ -1936,6 +2019,16 @@ int cpufreq_register_driver(struct
> >> > > + if (!cpufreq_driver->boost_supported)
> >> > > +         boost.attr.mode = 0444;
> >> > > +
> >> > > + ret = cpufreq_sysfs_create_file(&(boost.attr));
> >> > > + if (ret) {
> >> > > +         pr_err("%s: cannot register global boost sysfs
> >> > > file\n",
> >> > > +                __func__);
> >> > > +         goto err_null_driver;
> >> > > + }
> >> > > +
> >> >
> >> > I do not think the boost sysfs should be created at all if boost is
> >> > not supported.
> >>
> >> This was my first thought. But unfortunately this "boost" attribute is
> >> always exported at acpi-cpufreq.c and in my opinion is part of a
> >> legacy API.
> >>
> >> I totally agree with the idea of exporting boost only when supported,
> >> but I would like to know the community opinion about this (especially
> >> Viresh and Rafael shall speak up).
> >
> > Simple: Export it only when supported.
> 
> Guys,
> 
> I got confused here. We originally decided to keep this feature as is
> for acpi-cpufreq.
> 
> So, For acpi-cpufreq:
> - when boost isn't supported: create sysfs boost with ro permissions
> - when boost is supported: create sysfs boost with rw permissions
> 
> So, For others:
> - create sysfs boost with rw permissions only when boost is supported
> 
> .
> 
> Do you want something else? or do you want to change behavior of
> acpi-cpufreq driver? I don't why it was designed this way and what
> applications use it.

First off, I'm not sure how many applications actually use it and I think,
if any, they should be able cope with the attribute not being present.

Of course, if it turns out that yes, there are applications using it and no,
they cannot cope with the missing attribute, we'll need to address this.
That said such applications wouldn't work with earlier kernels in which that
attribute wasn't present at all, so I suppose this is really unlikely.

So, do whichever makes more sense to you: Design things to preserve the old
behavior (which is sightly confusing) or design them to expose the attribute
if the feature is actually supported and be prepared to address the (unlikely)
case when some hypothetical applications break because of that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
