Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3F1GzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 02:55:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37818 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3F1GzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 02:55:07 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-ec-51cd3349ea9b
Date: Fri, 28 Jun 2013 08:54:57 +0200
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
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
Message-id: <20130628085457.05d64878@amdc308.digital.local>
In-reply-to: <CAKohpomrPP9Lzk+fMn+Ba+J+2N740LR5NurVMomx8zww3AWLww@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
 <CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
 <20130627125819.5c90da30@amdc308.digital.local>
 <CAKohpo=JKg17YWjTrOh25hHW=sXn8-TW=D8rhrovonwZBDarBg@mail.gmail.com>
 <20130627164204.370dc4a6@amdc308.digital.local>
 <CAKohpomrPP9Lzk+fMn+Ba+J+2N740LR5NurVMomx8zww3AWLww@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQV1P47OBBpd/CFn8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW1zeNYfN4nPvEUaL240r2Cz6F/YyWTx52Mdm0XHk
	G7PFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZTxZ281csFK04tnexawNjLsEuhg5OCQETCTmbLbtYuQEMsUkLtxbz9bFyMUhJDCd
	UWLpxB9MEE47k8T+u72MIFUsAqoS/f8gbDYBPYnPd58ygQwSEdCSeHkzFaSeWWA7i8Slplls
	IDXCAk4SX+/8YgexeQWsJX7tX8gEYnMKBEu07etlgVjwjVli/f3ZzCAJfgFJifZ/P5ghTrKT
	OPdpA1SzoMSPyfdYQGxmoGWbtzWxQtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHFPPpHcwrmqwOMQowMGoxMPbkHgmUIg1say4MvcQowQHs5II
	750FQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MQex+
	J/6kv3Z1qX/RlJCxQ/tnn9+6f2//X3/y8XPo/klR7ZV73qR2Gpjm5H9dbqzqn8U20/TRAt4H
	N5dHTO7oPcVzx8ZnTdLKkIVq4ZcSOGr3xngVpCx+Y2V0r+5CQMnMFTkM1Q0zL8s5vT0gvLn5
	H2P848V1x47Or0hkD/3/NoqvOLuz1pNBiaU4I9FQi7moOBEA0RO5a6UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013 09:20:40 +0530, Viresh Kumar wrote:
> On 27 June 2013 20:12, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Thu, 27 Jun 2013 16:46:44 +0530, Viresh Kumar wrote:
> >> @Rafael: We need you to jump into this discussion now, I don't
> >> have a good idea about what we should do :)
> >>
> >> On 27 June 2013 16:28, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> >> > Do you have any idea of how to precisely set the load threshold?
> >>
> >> I thought we are talking about cpu being in idle state.
> >
> > If we _drop_ the idea with thermal subsystem to disable the boost,
> > the logic as far as I've understood shall here be as follow:
> >
> > Only enable BOOST when one CPU load > THRESHOLD_MAX and other CPUs <
> > THRESHOLD_MIN
> 
> Again, I thought that we are talking about cpus being completely idle.
> i.e. in WFI (wait for interrupt) or deeper states.
> 
> > THRESHOLD_MIN & THRESHOLD_MAX are SoC specific.
> >
> > In my opinion the above constrain imposes policy to the cpufreq
> > driver.
> 
> Hmm.
> 
> > So thermal or "other solution" [*] shall disable boost when
> > overheated and enable it back when things cool down.
> 
> yeah..

For me thermal is a good candidate to enable boost again. I only need
to find a proper place for it.

> 
> > [*] @ Viresh & Rafael do you have any idea about the "other
> > solution" here?
> 
> Not really sure :)

Not any single one? Then I would like to propose thermal.

> 
> >> There might be platforms where overheating isn't a issue with
> >> boost, if it is only enabled while only one cpu is in use.
> >
> > Could you elaborate more on this?
> 
> I meant platforms where chip doesn't heat up much when only one core
> is in use and is using boost frequency. So, they may not require
> support for thermal layer at all.. But I am not aware of what the
> ground reality is. If such systems can be possible or not.

Ok.

> 
> > This would prevent situation when somebody made a mistake and
> > had enabled boost, but for some reason had forgotten to
> > configure/enable thermal subsystem.
> >
> > Moreover Kconfig's CONFIG_CPUFREQ_BOOST flag would indicate that
> > user enabled boost for some reason and he/she (presumably) knows
> > what is doing.
> 
> Yeah.. And drivers like ACPI cpufreq and exynos can simply do a select
> from their Kconfig entries so that user isn't required to select them.

Automatic select is not a good option. My goal would be here to define
BOOST as NO by default (at lease for SW managed ones). And allow user
to enable it explicitly.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
