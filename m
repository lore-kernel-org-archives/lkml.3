Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3F1Hbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:31:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17839 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3F1Hba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:31:30 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-62-51cd3bcb8426
Date: Fri, 28 Jun 2013 09:31:05 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130628093105.1fa62005@amdc308.digital.local>
In-reply-to: <CAKohpomKfHrzHpquN6adfb9r37Lf+FvDKnWBg_ebmuDcC-41Tw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
 <20130627175546.677d9f9b@amdc308.digital.local>
 <CAKohpomuGHQ53SohgN9UyF0ODJVq3TgiyTk6TaWFSotTEZm_9w@mail.gmail.com>
 <20130628084939.1921a717@amdc308.digital.local>
 <CAKohpomKfHrzHpquN6adfb9r37Lf+FvDKnWBg_ebmuDcC-41Tw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd3T1mcDDbZuk7f483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitri8aw6bxefeI4wWtxtXsFn0L+xlsnjysI/NouPI
	N2aLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgynj3agN7QTdnxYktq1kbGA+zdTFyckgImEhMWnCaGcIWk7hwbz1QnItDSGARo8TX
	tmksEE47k8TJJc1gHSwCqhIPFsxlArHZBPQkPt99CmRzcIgIaEm8vJkKUs8ssJ1F4lLTLLB6
	YQEPie27+llBbF4Ba4nf016BxTkFgiUerHkIte0bs8T6NXfBzuAXkJRo//cD6iQ7iXOfNrBD
	NAtK/Jh8jwXEZgZatnlbEyuELS+xec1b5gmMgrOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGMFR9Ux6B+OqBotDjAIcjEo8vA2JZwKFWBPLiitzDzFKcDArifDeWQAU
	4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwKj4d3G/vKSD
	dUne+r1fTip8Dbl+Oc08ffHjsuXvsxeqLJVL25zWwbvvyLvEFccvMoj7zHm7QzpbJdJ4TUAD
	0+1Hn+3c1z3+ecHiUtottxmHhVvmrZKK55PX3BlQUpVS5uMjckz/szwHvwlr5Qnh5EdMq6wn
	SBWdOK7N0LuPi/FApxGnyKzDxUosxRmJhlrMRcWJALX4jAymAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013 12:21:21 +0530, Viresh Kumar wrote:

> On 28 June 2013 12:19, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > No, I will use:
> >
> > if (boost_enabled != state) {
> >         write_lock_irqsave(&cpufreq_driver_lock, flags);
> >         boost_enabled = state;
> >
> >         ret = cpufreq_driver->enable_boost(state);
> >         ^^^^^^^^^^^^^^^^^^^^ only one callback call
> >         if (ret)
> >                 boost_enabled = 0;
> >
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> >         if (ret)
> >                 pr_err("%s: BOOST cannot enable (%d)\n",
> >                        __func__, ret);
> > }
> >
> > and @ cpufreq_register_driver() I will add following line:
> >
> > if (!cpufreq_driver->enable_boost)
> >         cpufreq_driver->enable_boost = &cpufreq_boost_enable_sw;
> >
> > When cpufreq driver doesn't define callback for enable_boost it
> > will be filled with default SW cpufreq_boost_enable_sw callback.
> 
> That's some smart  code. Good. :)

OK

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
