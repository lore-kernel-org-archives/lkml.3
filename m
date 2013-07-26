Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3GZK6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:58:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23494 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3GZK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:58:37 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-ee-51f2565a740c
Date: Fri, 26 Jul 2013 12:58:27 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 1/8] cpufreq: Store cpufreq policies in a list
Message-id: <20130726125827.72f9ef18@amdc308.digital.local>
In-reply-to: <CAKohpoktwZUvs2ap7wk1tudVsiKjbhFkoM5=+AaFZP=+73fEyg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-2-git-send-email-l.majewski@samsung.com>
 <CAKohpoktwZUvs2ap7wk1tudVsiKjbhFkoM5=+AaFZP=+73fEyg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoG5U2KdAg7YZmhYbZ6xntXja9IPd
	Yt5nWYu+n1eYLdbs/8lk0Xn2CbNF74KrbBZvHnFbXN41h83ic+8RRov+hb1MFk8e9rFZbPzq
	4cDrsXjPSyaPO9f2sHmsm/aW2aNvyypGj0eLWxg9jt/YzuTxeZNcAHsUl01Kak5mWWqRvl0C
	V8aKv8/ZCt5wVuw84tvA2MvRxcjJISFgItF2YwMrhC0mceHeerYuRi4OIYHpjBKfZq5nh3Da
	mSSmPPoIVMXBwSKgKvFuZzVIA5uAnsTnu0+ZQMIiAloSL2+mgpQzC/xlluh71MAGUiMs4Cqx
	tmstmM0rYC0xb1sfWD2nQLDEhWVFEOPbmCS6nm9jBqnhF5CUaP/3gxniIDuJc582sEP0Ckr8
	mHyPBcRmBtq1eVsTK4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnF
	pXnpesn5uZsYwVH0THoH46oGi0OMAhyMSjy8Ck4fA4VYE8uKK3MPMUpwMCuJ8F73/hQoxJuS
	WFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTFUM8eFJ7lwy2Lx
	Gu4Jwj3O6zQL9VZYtp8/L6G4Ip9F2HhR5+3W5WsMfDs/fc3UkNkR4n9i269I9oesXxbJGSsv
	un61/8DuySU9PhJ60fY7t099ETjv5PpLi61PPtd3Dqx4lPA+83RtzaY5LFuafq+//mv16vRb
	qxoWT9hRp33ZV/a53N8FZVlKLMUZiYZazEXFiQDe4G3fngIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:44:29 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Policies available in a cpufreq framework are now linked together.
> > They are accessible via cpufreq_policy_list defined at cpufreq core.
> >
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> 
> Looks good but would have been better if you could have moved
> existing code to use this infrastructure..
> 
> For example, this code in __cpufreq_add_dev()
> 
> #ifdef CONFIG_HOTPLUG_CPU
> 	/* Check if this cpu was hot-unplugged earlier and has
> siblings */ read_lock_irqsave(&cpufreq_driver_lock, flags);
> 	for_each_online_cpu(sibling) {
> 
>          ---
> 
> 	}
> 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> #endif

Do you mean to write something like:

#ifdef CONFIG_CPU_FREQ_BOOST_SW
	write_lock_irqsave(&cpufreq_driver_lock, flags);
	list_add(&policy->policy_list, &cpufreq_policy_list);
	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
#endif

Or Am I missing something?
-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
