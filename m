Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3E0LwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:52:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52542 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab3E0LwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:52:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster governor - tests results
Date: Mon, 27 May 2013 14:00:58 +0200
Message-ID: <8856294.KaD55h4g0a@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=Kw4RsDJL8BdH1uE7Aj-X=K5A7af5NRqJXyjRUNvv5ag@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com> <20130524132036.7e7d5ffe@amdc308.digital.local> <CAKohpo=Kw4RsDJL8BdH1uE7Aj-X=K5A7af5NRqJXyjRUNvv5ag@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 27, 2013 11:03:38 AM Viresh Kumar wrote:
> On 24 May 2013 16:50, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >> On 24 May 2013 14:00, Lukasz Majewski <l.majewski@samsung.com> wrote:
> 
> > This is not safe IMHO to add permanently overclocked frequency to the
> > freq table. Since, for example, thermal framework also asks for
> > reference to this table.
> 
> Yes, its wrong. Even adding it permanently this way would be a problem
> if governor is changed to performance. :)
> 
> > The idea beneath overclocking is to add "dangerous" frequency to the
> > frequency table only when necessary (and remove it when not needed).
> 
> Hmm.. probably the idea beneath is to use dangerous frequency only
> when we are assured that we will not break system.. It doesn't have
> anything to do with cpufreq table entries :)
> 
> > In this way, the thermal framework (as it is done at our platform) will
> > decrease the frequency (according to thermal governor :-) ) to safe
> > level.
> >
> > Overclocking is disabled in 2 ways (at our setup):
> > - thermal framework is here to help us
> > - lab governor disables the overclocking when favorable conditions are
> >   gone.
> 
> I don't want to discuss OR think about LAB for now.. Want to get
> overclocking feature in first.
> 
> > One more remark - enabling tb_en_over_clk at sysfs (echo 1
> >> /sys/devices/system/cpu/cpu0/cpufreq/tb_en_over_clk)
> > adds overclock frequency to frequency table and updates policy.
> 
> What if it is enabled and governor is changed to performance
> without disabling it... Who will take care of disabling dangerous
> frequencies?
> 
> One thing I am certain about is to make overclocking a generic and
> core feature, rather than platform specific...
> 
> What about adding overdrive frequencies in freq table permanently
> but with .index field as: CPUFREQ_ENTRY_OVERDRIVE ??
> 
> This way we will use frequencies marked with
> CPUFREQ_ENTRY_OVERDRIVE only when we have overclocking
> enabled. And not at other times?

Well, this really looks like software turbo modes, so let's call them
"TURBO" instead of "OVERDRIVE" and I seem to remember having a switch for
disabling/enabling turbo modes already.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
