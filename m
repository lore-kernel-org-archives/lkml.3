Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3FLLlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:41:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20700 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3FLLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:41:18 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-ab-51b85e5d4bc1
Date: Wed, 12 Jun 2013 13:40:23 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v2 1/3] cpufreq:boost: CPU frequency boost code unification
 for software and hardware solutions
Message-id: <20130612134023.5f151a98@amdc308.digital.local>
In-reply-to: <2535901.EBhXeQ6J8O@vostro.rjw.lan>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
 <20130612093938.1cf73c9a@amdc308.digital.local>
 <2535901.EBhXeQ6J8O@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xoG5s3I5Ag62LOS3+vF3OavG06Qe7
	xbzPshadZ58wW/QuuMpm8eYRt8XlXXPYLD73HmG0uN24gs2if2Evk0XHkW/MFhu/ejjweNy5
	tofNY920t8wefVtWMXo8WtzC6PF5k1wAaxSXTUpqTmZZapG+XQJXxoH95xgLXkpWPH68irWB
	cZlwFyMnh4SAicTBN90sELaYxIV769m6GLk4hASmM0o8at/FAuG0M0n03HzODlLFIqAq0Xjy
	MjOIzSagJ/H57lMmEFsEKL7lyX92kAZmgdfMEh/f/ARrEBYolXgy8yWYzStgLfHh3DNWEJtT
	wEBixoH5TBAbnjBKfHpxjQ0kwS8gKdH+7wczxE12Euc+bYBqFpT4Mfke2K3MAloSm7c1sULY
	8hKb17xlnsAoOAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwvz6R2
	MK5ssDjEKMDBqMTDe8Bse6AQa2JZcWXuIUYJDmYlEd4q7R2BQrwpiZVVqUX58UWlOanFhxil
	OViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhiXHsk53uZXeYHj8Xs50UMTD5b+b69Vn/uW
	6cERNhXbhB9G0/5xz7pg9nOOemfIoh3mHMatB70MLz6amrzfTWlV91rBYw+EhVdemvb7im7D
	41Pr3684u2Nr8NvECzW9U3Jm1m6r+FGy827tcXWPvd414sz3I6/WF+RaJ+vzd6RnnFaYfyrr
	P+N1JZbijERDLeai4kQAiJ39WpMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013 13:23:20 +0200, Rafael J. Wysocki wrote:

Hi Rafael,

> On Wednesday, June 12, 2013 09:39:38 AM Lukasz Majewski wrote:
> > Hi Viresh,
> > 
> > > Hi,
> > > 
> > > Change subject to: "cpufreq: Add boost frequency support in core"
> > 
> > Ok.
> > 
> > > 
> > > On 11 June 2013 14:33, Lukasz Majewski <l.majewski@samsung.com>
> > > wrote:
> > > > This commit adds support for software based frequency boosting.
> > > 
> > > No. It adds support for both software and hardware boosting. So
> > > just write: This commit adds boost frequency support in cpufreq
> > > core (Hardware & Software).
> > 
> > Ok.
> > > 
> > > > Some SoC (like Exynos4 - e.g. 4x12) allow setting frequency
> > > > above its normal condition limits. Such a change shall be only
> > > > done for a short
> > > 
> > > s/condition/operation
> > > s/change/mode
> > > s/done/used
> > > 
> > 
> > Ok.
> > 
> > > > time.
> > > >
> > > > Overclocking (boost) support is essentially provided by platform
> > > > dependent cpufreq driver.
> > > >
> > > > This commit unifies support for SW and HW (Intel) over clocking
> > > > solutions in the core cpufreq driver. Previously the "boost"
> > > > sysfs attribute was defined at acpi driver code.
> > > > By default boost is disabled. One global attribute is available
> > > > at: /sys/devices/system/cpu/cpufreq/boost.
> > > 
> > > Enter a blank line here.
> > 
> > Ok
> > 
> > > 
> > > > It only shows up when cpufreq driver supports overclocking.
> > > > Under the hood frequencies dedicated for boosting are marked
> > > > with a special flag (CPUFREQ_BOOST_FREQ) at driver's frequency
> > > > table. It is the user's concern to enable/disable overclocking
> > > > with proper call to sysfs.
> > > 
> > > Good.
> > > 
> > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> > > >
> > > > --- 
> >     ^^^^
> > [*] this --- was added manually by me.
> > 
> > > > Changes for v2:
> > > > - Removal of cpufreq_boost structure and move its fields to
> > > > cpufreq_driver structure
> > > > - Flag to indicate if global boost attribute is already defined
> > > > - Extent the pr_{err|debbug} functions to show current function
> > > > names ---
> > > 
> > > You don't have to manually add "---" here. Just keep a blank line
> > > instead.
> > 
> > One "---" is added by git automatically. The [*] was added to
> > distinct the changelog from rest of the commit. At least older
> > versions of GIT required this to not include changelog to commit
> > messages.
> 
> Which doesn't matter anyway.  None of them will show up in git log,
> so don't worry. :-)

:-)

> 
> [...]
> 
> > 
> > > And so we must have used
> > > boost_en here.
> > 
> > boost_en has two meanings:
> > 0 - either boost disabled or not supported (when
> > low_level_boost=NULL). 1 - boost is enabled.
> 
> Gosh, please don't do that.  Use *two* flags, one meaning "supported"
> and the second meaning "enabled".

That was already pointed out by Viresh. I will stick to his
guidelines :-).

> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
