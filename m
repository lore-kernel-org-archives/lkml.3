Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3GAIPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:15:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63300 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3GAIP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:15:28 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-66-51d13a9ed228
Date: Mon, 01 Jul 2013 10:15:16 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
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
Message-id: <20130701101516.7945e387@amdc308.digital.local>
In-reply-to: <20130628085457.05d64878@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
 <CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
 <20130627125819.5c90da30@amdc308.digital.local>
 <CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
 <20130627164204.370dc4a6@amdc308.digital.local>
 <CAKohpomrPP9Lzk+fMn+Ba+J+2N740LR5NurVMomx8zww3AWLww@mail.gmail.com>
 <20130628085457.05d64878@amdc308.digital.local>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAd15VhcDDSZ9F7b483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXRv+zo6wFJ/kqrh9bxNbAOI27i5GTQ0LAROLUvHMsELaYxIV769m6GLk4
	hAQWMUqc+3ieBcJpZ5KYtbiHsYuRg4NFQFViyZoAkAY2AT2Jz3efMoHYIgK+Ej3LDjGB1DML
	7GOR2NT1DywhLOAk8fXOL3YQm1fAWmLfzylgNqeAjcSuE11MEAtWsEh0b9vMDJLgF5CUaP/3
	gxniJDuJc582QDULSvyYfA/sVGYBLYnN25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIjq9n0jsYVzVYHGIU4GBU4uFdMP1CoBBrYllxZe4h
	RgkOZiUR3v8WFwOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJx
	cEo1MPZ6v1qksX0/n/D6iemSDK1xVrpuiRp/N/a/7tout8P457GErYd3FPYvPrPWaL7yqbij
	84RS9qRd+BV4MGhNhOjG6VFHPy5sKT/8gCHChnv9ya65IjMeLWIp2PjNyuH3vgj3N116hSfE
	vq0RiPFsNT0tGhBlbSg9Se/Il3aOTJbNj04sFKz4dVOJpTgj0VCLuag4EQBZXgs0qwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013 08:54:57 +0200, Lukasz Majewski wrote:
> > > So thermal or "other solution" [*] shall disable boost when
> > > overheated and enable it back when things cool down.  
> > 
> > yeah..  
> 
> For me thermal is a good candidate to enable boost again. I only need
> to find a proper place for it.

Unfortunately, after careful investigation it turned out, that thermal
is suited to disable boost when overheating is detected. (since it uses
thermal subsystem interrupt to take action).

The problem is with enabling boost again, since thermal (at least at my
board) only reacts on TMU (thermal) interrupt. Thermal thread may be
started, but I don't regard this as a good solution (to extra bloat
thermal).

> 
> >   
> > > [*] @ Viresh & Rafael do you have any idea about the "other
> > > solution" here?  
> > 
> > Not really sure :)  
> 
> Not any single one? Then I would like to propose thermal.
> 

Does anybody have any idea here? As written above, thermal is suitable
to disable boost.

I'd like to bring those three options under discussion:

1. boost attr is always exported -> do not enable boost automatically
   when disabled by thermal (as it was proposed at v4).

2. boost attr is always exported -> find a way to enable boost after
   emergency disablement when thermal detects overheating (newest
   proposition). 

3. boost attr only exported at x86 (when supported)
   boost attr NOT exported via sysfs for SW controlled boost (e.g.
   Exynos ARM).

   Then we only enable/disable boost at kernel and don't need to take
   care of the user space interaction. This scenario is my use case. I
   hadn't planned to expose boost to userspace and use it with LAB as a
   kernel API.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
