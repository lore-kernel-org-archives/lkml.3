Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3E0MQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:16:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23080 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3E0MQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:16:49 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-8c-51a34eb00229
Date: Mon, 27 May 2013 14:16:35 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130527141635.14dcabb9@amdc308.digital.local>
In-reply-to: <8856294.KaD55h4g0a@vostro.rjw.lan>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130524132036.7e7d5ffe@amdc308.digital.local>
 <CAKohpo=Kw4RsDJL8BdH1uE7Aj-X=K5A7af5NRqJXyjRUNvv5ag@mail.gmail.com>
 <8856294.KaD55h4g0a@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd0NfosDDT4/5LR42vSD3WLeZ1mL
	zrNPmC3ePOK2uLxrDpvF594jjBa3G1ewWfQv7GWy6Djyjdli41cPBy6PO9f2sHmsm/aW2aNv
	yypGj0eLWxg9Pm+SC2CN4rJJSc3JLEst0rdL4MpY9S2woEW0YuXtfewNjBsFuhg5OSQETCQ+
	7TzPBmGLSVy4tx7I5uIQEljEKPFg6VUWCKedSeLC38XMIFUsAqoSh/ecBbPZBPQkPt99ygRi
	iwDFtzz5zw7SwCxwnUmib/N1dpCEsEC6xL9tXWBFvALWEo+u/GIEsTkFDCQOL/sHte45o8SM
	Le/BivgFJCXa//1ghrjJTuLcpw3sEM2CEj8m32MBsZkFtCQ2b2tihbDlJTavecs8gVFwFpKy
	WUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjODKeSe1gXNlgcYhRgINRiYf3
	x6xFgUKsiWXFlbmHGCU4mJVEeKXMFgcK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCe
	WJKanZpakFoEk2Xi4JRqYFROr51k1fnqIOPp81uOuF1v0Ok82M/e9+GOh1rGo/X1y3fkFW8z
	4w967Xtp3typ026djTMU9jv3v3r+xrKI79s7DF5MZsqeU3rh+MLTizj6Hy1/0ci16rvv+8oZ
	P06k3M+KaJ/O8m/BxavHKt7yC+xK0uL9fECt6K5wcG3xkwXHG0skN+79Z3dMiaU4I9FQi7mo
	OBEAQ58/oYgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> On Monday, May 27, 2013 11:03:38 AM Viresh Kumar wrote:
> > On 24 May 2013 16:50, Lukasz Majewski <l.majewski@samsung.com>
> > wrote:
> > >> On 24 May 2013 14:00, Lukasz Majewski <l.majewski@samsung.com>
> > >> wrote:
> > 
> > > This is not safe IMHO to add permanently overclocked frequency to
> > > the freq table. Since, for example, thermal framework also asks
> > > for reference to this table.
> > 
> > Yes, its wrong. Even adding it permanently this way would be a
> > problem if governor is changed to performance. :)
> > 
> > > The idea beneath overclocking is to add "dangerous" frequency to
> > > the frequency table only when necessary (and remove it when not
> > > needed).
> > 
> > Hmm.. probably the idea beneath is to use dangerous frequency only
> > when we are assured that we will not break system.. It doesn't have
> > anything to do with cpufreq table entries :)
> > 
> > > In this way, the thermal framework (as it is done at our
> > > platform) will decrease the frequency (according to thermal
> > > governor :-) ) to safe level.
> > >
> > > Overclocking is disabled in 2 ways (at our setup):
> > > - thermal framework is here to help us
> > > - lab governor disables the overclocking when favorable
> > > conditions are gone.
> > 
> > I don't want to discuss OR think about LAB for now.. Want to get
> > overclocking feature in first.
> > 
> > > One more remark - enabling tb_en_over_clk at sysfs (echo 1
> > >> /sys/devices/system/cpu/cpu0/cpufreq/tb_en_over_clk)
> > > adds overclock frequency to frequency table and updates policy.
> > 
> > What if it is enabled and governor is changed to performance
> > without disabling it... Who will take care of disabling dangerous
> > frequencies?
> > 
> > One thing I am certain about is to make overclocking a generic and
> > core feature, rather than platform specific...
> > 
> > What about adding overdrive frequencies in freq table permanently
> > but with .index field as: CPUFREQ_ENTRY_OVERDRIVE ??
> > 
> > This way we will use frequencies marked with
> > CPUFREQ_ENTRY_OVERDRIVE only when we have overclocking
> > enabled. And not at other times?
> 
> Well, this really looks like software turbo modes, so let's call them
> "TURBO" instead of "OVERDRIVE" and I seem to remember having a switch
> for disabling/enabling turbo modes already.

Indeed, overclocking is a software implemented TURBO mode. I can stick
to CPUFREQ_ENTRY_TURBO name.

I will check the disable/enable flag. Thanks for pointing out.

> 
> Thanks,
> Rafael
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
