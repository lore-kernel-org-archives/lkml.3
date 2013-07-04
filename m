Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3GDMkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:40:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58233 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3GDMke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:40:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
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
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
Date: Thu, 04 Jul 2013 14:50:13 +0200
Message-ID: <2394846.9qggnDATev@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponiy3ebnt0_Cdaan5=DkAfA3U4g=m4NnYGLA-a+tPJJQg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <20130701101516.7945e387@amdc308.digital.local> <CAKohponiy3ebnt0_Cdaan5=DkAfA3U4g=m4NnYGLA-a+tPJJQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 04, 2013 10:36:53 AM Viresh Kumar wrote:
> Hi Lukasz,
> 
> Sorry for being late. Actually I didn't had an answer to your mail
> and wanted to go through it with some fresh mind. This is my
> first mail this morning, lets see if I can bring something good
> into the discussion.
> 
> On 1 July 2013 13:45, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Does anybody have any idea here? As written above, thermal is suitable
> > to disable boost.
> 
> See, one thing is very clear. User space applications aren't responsible
> for enabling boost again and again. There has to be a internal mechanism
> inside kernel for that.
> 
> > I'd like to bring those three options under discussion:
> >
> > 1. boost attr is always exported -> do not enable boost automatically
> >    when disabled by thermal (as it was proposed at v4).
> 
> So, that's a problem. I see one more solution to that.
> - Create another Macro in cpufreq.c which would contain the time
> after which we will autoenable boost.

Well, how can we tell what time is correct here?  It may depend on factors not
under our control or even variable, like the ambient temperature, so surely
it might not be a hard coded value.

> - So, suppose thermal disabled it due to high temperature (Lets not
> change value of sysfs variable boost_enable, but create another
> variable like: skip_boost: which means skip boost temporarily).

What about "block_boost"?  Other than that, this particular item is a good idea
I think.

> - Thermal would enable this variable skip_boost.
> - Then we will continue to get requests for next frequency and will
> check eveytime if we have exceeded time for autoenabling boost.
> - If yes, then we disable this variable and start boosting again..

I wonder if we could use thermal watermarks instead?  Such that a high
watermark would cause block_boost to be set and a low watermark would cause
it to be reset?  And the thermal layer would be in control of both watermarks?

> - Then thermal can disable it again later.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
