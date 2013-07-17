Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3GQHBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:01:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50585 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3GQHA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:00:59 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-80-51e641239430
Date: Wed, 17 Jul 2013 09:00:44 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130717090044.4392d86a@amdc308.digital.local>
In-reply-to: <CAKohpokni=zPob9yz2-ak_g_xhwFaLBhk6wNGV5EGSfxx-eGZA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-3-git-send-email-l.majewski@samsung.com>
 <CAKohpomfWKiRjznXeYsg32xAAWPTBQ4Gd0D_pftbA5=zMDiH4Q@mail.gmail.com>
 <20130716140632.70fb2838@amdc308.digital.local>
 <CAKohpokni=zPob9yz2-ak_g_xhwFaLBhk6wNGV5EGSfxx-eGZA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgK6y47NAg4UL5Sz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	royFfb3MBd84KlbdvMHWwNjN3sXIySEhYCIx6c5bZghbTOLCvfVsXYxcHEICixgllh//wg7h
	tDNJTFpzgw2kikVAVeL3v0dgNpuAnsTnu0+Zuhg5OEQEtCRe3kwFqWcW+MgscffgbRaQGmEB
	D4lFu++A1fAKWEt8nJsNEuYUCJbYOHsWM8T8v0wSE343gF3BLyAp0f7vB9RFdhLnPm0Au5RX
	QFDix+R7YDOZgXZt3tbECmHLS2xe85Z5AqPgLCRls5CUzUJStoCReRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcCQ9k97BuKrB4hCjAAejEg/vhLCngUKsiWXFlbmHGCU4mJVEeKs1ngUK
	8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYGz+Pf2KWvDD
	xxJF97bsZdstIWvXsuDt7qR1C0wmGU/iOR93lGHSVQnbQ0wlCff0rm+OvDFlz/yzT9cFbmH5
	N83HdY98wOqX/2QNvRiWuHIWmh+ZsW/H26APPz6HyR7gy3FdyHi4Tj+NXzdR+UntqlXbHnBn
	G894sPCXqt+KST3XPmtecDjGr2WqxFKckWioxVxUnAgACYFlHKACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 10:58:40 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 16 July 2013 17:36, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Tue, 16 Jul 2013 15:11:54 +0530 Viresh Kumar
> > viresh.kumar@linaro.org wrote,
> >> On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> > +void cpufreq_set_boost_enabled(int state)
> >           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> >
> >>
> >> Maybe cpufreq_block_boost? As suggested by Rafael.
> >
> > What do you mean by cpufreq_block_boost()? This name would reverse
> > the logic.
> >
> > Function [*] is used to change boost_enabled static flag (defined at
> > cpufreq.c file) state according to acpi-cpufreq.c boost support
> > status.
> 
> I misread it again :(
> 
> So, what about adding another field in struct cpufreq_driver:
> boost_enabled? And get rid of the global boost_enabled we have used?
> Similar to how boost_supported is used, then we don't need this
> routine.

Ok, I will implement this.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
