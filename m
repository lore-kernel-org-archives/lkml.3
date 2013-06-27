Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3F0LHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:07:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3F0LHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:07:18 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-7d-51cc1ce5a1fa
Date: Thu, 27 Jun 2013 13:07:09 +0200
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
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130627130709.698dd18a@amdc308.digital.local>
In-reply-to: <CAKohpon8iRUiPHJqyLSweqGhAjaZBn2f6TQk+Ow0-DvHofHt1Q@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
 <CAKohpon7GLGvrkFQdWpco5f9P7S8L-2-ETMu2-3dFEDwOgL1RQ@mail.gmail.com>
 <20130626145412.1e9bfa63@amdc308.digital.local>
 <CAKohpo==702FnSwhrPi6L1VzLbxO5LT3VDQCru9cwKjgmbppxA@mail.gmail.com>
 <20130627114852.2889eea6@amdc308.digital.local>
 <CAKohpon8iRUiPHJqyLSweqGhAjaZBn2f6TQk+Ow0-DvHofHt1Q@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd2nMmcCDU784rL483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitri8aw6bxefeI4wWtxtXsFn0L+xlsnjysI/NYv2M
	1ywWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxuw5DWwF/VwVh190MjYwvmLvYuTkkBAwkTh4ejkLhC0mceHeerYuRi4O
	IYHpjBIfr0xihXDamSTuf34N1MHBwSKgKnGrRxqkgU1AT+Lz3adMIGERAS2JlzdTQcqZBU6z
	SOx4cA1sgbCAh8T2Xf2sIDavgLXEwSkNLCD1nALBEjvfFUCM/8Yscf7MIbB6fgFJifZ/P5gh
	DrKTOPdpAztEr6DEj8n3wA5lBtq1eVsTK4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwbH1TGoH48oGi0OMAhyMSjy8HiynA4VYE8uKK3MPMUpw
	MCuJ8M4UPhMoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1Oq
	gTFB6MO/yfGZlYbNzp/UlFq/756U05+1UOPi8a63Ey0OnvtyvPpj6okHX2dpeueaKJnw7Vuk
	fCbP7ruoy7XafSI8NYxveGVdr96//riucd+0zJKjx7RnXq6b1Wzae2z9SV8GrYJ9Id1nkt4o
	rNm9Yzmb6o6d8zouuP9Yz/t/Ykdv3HS3L9/m/PuuxFKckWioxVxUnAgAFgGwWqkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 15:55:26 +0530, Viresh Kumar wrote:
> On 27 June 2013 15:18, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Thu, 27 Jun 2013 14:32:57 +0530, Viresh Kumar wrote:
> 
> > I thought about this idea, but at cpufreq_boost_trigger_state_sw()
> > I iterate through all available policies and call
> > cpufreq_frequency_table_cpuinfo()[*] on them. In this routine [*] I
> > use cpufreq_boost_enabled() [**] route to search for maximal (boost)
> > frequency.
> > The [**] reads boost_enabled flag, which shall be updated before.
> > When this search fails, then I restore the old value of
> > boost_enabled.
> 
> Ok.

OK
> 
> >> >> > +               else
> >> >> > +                       ret =
> >> >> > cpufreq_boost_trigger_state_sw();
> >>
> >> then why not enable_boost_sw() here? that would be more
> >> relevant.
> >
> > Could you be more specific here?
> 
> I meant rename cpufreq_boost_trigger_state_sw() to
> enable_boost_sw() :)

No problem:
- For SW there will be 
	cpufreq_boost_trigger_state_sw() renamed to enable_boost_sw()

- For HW:
	cpufreq_driver->enable_boost(state) renamed to
		cpufreq_driver->enable_boost_hw(); 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
