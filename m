Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935280Ab3FSWQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:16:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43341 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935070Ab3FSWQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:16:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lukasz Majewski <l.majewski@majess.pl>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
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
Date: Thu, 20 Jun 2013 00:25:38 +0200
Message-ID: <6633375.dICiDrHJgK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130619223102.70c2e359@jawa>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <51C1EF05.90402@gmail.com> <20130619223102.70c2e359@jawa>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 10:31:02 PM Lukasz Majewski wrote:
> On Wed, 19 Jun 2013 10:48:53 -0700
> Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> 
> > On 06/19/2013 10:12 AM, Lukasz Majewski wrote:
> > > This commit adds boost frequency support in cpufreq core (Hardware &
> > 
> > > +/*********************************************************************
> > >    *               REGISTER / UNREGISTER CPUFREQ
> > > DRIVER                *
> > > *********************************************************************/
> > >
> > > @@ -1936,6 +2019,16 @@ int cpufreq_register_driver(struct
> > > cpufreq_driver *driver_data) cpufreq_driver = driver_data;
> > >   	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > >
> > > +	if (!cpufreq_driver->boost_supported)
> > > +		boost.attr.mode = 0444;
> > > +
> > > +	ret = cpufreq_sysfs_create_file(&(boost.attr));
> > > +	if (ret) {
> > > +		pr_err("%s: cannot register global boost sysfs
> > > file\n",
> > > +		       __func__);
> > > +		goto err_null_driver;
> > > +	}
> > > +
> > 
> > I do not think the boost sysfs should be created at all if boost is
> > not supported.
> 
> This was my first thought. But unfortunately this "boost" attribute is
> always exported at acpi-cpufreq.c and in my opinion is part of a
> legacy API.
> 
> I totally agree with the idea of exporting boost only when supported,
> but I would like to know the community opinion about this (especially
> Viresh and Rafael shall speak up).

Simple: Export it only when supported.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
