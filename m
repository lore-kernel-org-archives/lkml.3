Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3F1Gt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:49:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36680 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3F1Gty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:49:54 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-af-51cd320a2aa3
Date: Fri, 28 Jun 2013 08:49:39 +0200
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
Message-id: <20130628084939.1921a717@amdc308.digital.local>
In-reply-to: <CAKohpomuGHQ53SohgN9UyF0ODJVq3TgiyTk6TaWFSotTEZm_9w@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
 <20130627175546.677d9f9b@amdc308.digital.local>
 <CAKohpomuGHQ53SohgN9UyF0ODJVq3TgiyTk6TaWFSotTEZm_9w@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAV1uo7OBBv0nmSz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz6Djy
	jdli41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mg7de8BYMJGv4uKbZ6wNjA+4uhg5OSQETCQerVrACGGLSVy4t56ti5GLQ0hgEaPE
	gePzGSGcdiaJQxva2ECqWARUJY4/+cwMYrMJ6El8vvuUqYuRg0NEQEvi5c1UkHpmge0sEpea
	ZoHVCwt4SGzf1c8KYvMKWEvc+ruGCcTmFAiWOHRxJdS2v0wSW6Z/ARvKLyAp0f7vBzPESXYS
	5z5tYIdoFpT4MfkeC4jNDLRs87YmVghbXmLzmrfMExgFZyEpm4WkbBaSsgWMzKsYRVMLkguK
	k9JzjfSKE3OLS/PS9ZLzczcxgqPqmfQOxlUNFocYBTgYlXh4GxLPBAqxJpYVV+YeYpTgYFYS
	4b2zACjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBUZ8l
	7fOGdYJn17TsSpb5Ir1AK9vfYOqSggYHLR+hJpuXdW2lZnPNJeOPBYgadDId/ebBY1LdLZrw
	0phbJfOnD2/KFH+515PO71x8MfCZ0iZlczMevQIHbq1rAcKe89Zp/CxX8njF5d5qcsew/QjL
	R8W+C5MXXnkquFXKPbN5iQszp6m74wwlluKMREMt5qLiRAC5DAjfpgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013 09:10:53 +0530, Viresh Kumar wrote:
> On 27 June 2013 21:25, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Wed, 26 Jun 2013 16:24:32 +0530, Viresh Kumar wrote:
> >> > +       if (boost_enabled != state) {
> >> > +               write_lock_irqsave(&cpufreq_driver_lock, flags);
> >> > +               boost_enabled = state;
> >> > +               if (cpufreq_driver->enable_boost)
> >> > +                       ret =
> >> > cpufreq_driver->enable_boost(state);
> >> > +               else
> >> > +                       ret = cpufreq_boost_trigger_state_sw();
> >
> > I will use only one call to cpufreq_driver->enable_boost(state) [*]
> > with either cpufreq_boost_enable_sw() (function with SW boost
> > handling) or the one provided by cpufreq driver.
> >
> > Only when cpufreq driver doesn't provide [*], it will be filled with
> > "default" cpufreq_boost_enable_sw().
> 
> I didn't get it completely. You are saying you will send a function
> pointer now?

No, I will use:

if (boost_enabled != state) {
	write_lock_irqsave(&cpufreq_driver_lock, flags);
	boost_enabled = state;

	ret = cpufreq_driver->enable_boost(state);
	^^^^^^^^^^^^^^^^^^^^ only one callback call
	if (ret)
		boost_enabled = 0;

	write_unlock_irqrestore(&cpufreq_driver_lock, flags);

	if (ret)
		pr_err("%s: BOOST cannot enable (%d)\n",
		       __func__, ret);
}

and @ cpufreq_register_driver() I will add following line:

if (!cpufreq_driver->enable_boost)
	cpufreq_driver->enable_boost = &cpufreq_boost_enable_sw;

When cpufreq driver doesn't define callback for enable_boost it will be
filled with default SW cpufreq_boost_enable_sw callback.



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
