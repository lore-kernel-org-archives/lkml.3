Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3F0JIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:08:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61481 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3F0JIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:08:24 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-33-51cc0106686b
Date: Thu, 27 Jun 2013 11:08:13 +0200
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
Subject: Re: [PATCH v4 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to
 support boost framework
Message-id: <20130627110813.6797b1fe@amdc308.digital.local>
In-reply-to: <CAKohpokf8TZkP5Nzpp+m5KaUK8zJ6mwiuiW-td7boHQ7NtB-DQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-5-git-send-email-l.majewski@samsung.com>
 <CAKohpokf8TZkP5Nzpp+m5KaUK8zJ6mwiuiW-td7boHQ7NtB-DQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAV02xjOBBlN6VSz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz6Djy
	jdli41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mtbsci94x1nx4uhpxgbGO+xdjJwcEgImEk/avjFC2GISF+6tZ+ti5OIQEljEKHHp
	/0qwhJBAO5PEhf1BIDaLgKrEhSl/WUFsNgE9ic93nzJ1MXJwiAhoSby8mQrSyyywnUXiUtMs
	NpAaYYEUiRsPj4LN4RWwljhw7CsLiM0pECzxo3ExI8SyFiaJK382gxXxC0hKtP/7wQxxkZ3E
	uU8b2CGaBSV+TL4H1swMtGzztiZWCFteYvOat8wTGAVnISmbhaRsFpKyBYzMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGCI+qZ9A7GVQ0WhxgFOBiVeHg/MJ4OFGJNLCuuzD3EKMHBrCTC
	e5HhTKAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGxpID
	YXuC9+f/UzFSvt3V/bardOP7lE+58z3qbVdmWx3KyWZOsZi/4/Ymq83yJgvUxerOn1WLOuh2
	cKverb+88s+O7Lx123z3goRsm31Jqw6/vR+a5Ou/9Yzk2R3yk5bdDJE3OWaftEQ5Y7d+8IE1
	P5O3apnZJzDYObhXNi5dZPnv6RybrHtRvUosxRmJhlrMRcWJAD6nw/6kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 14:28:11 +0530, Viresh Kumar wrote:

> On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > The struct cpufreq_driver has been extended to embrace the
> > information related to boost support.
> >
> > When "boost_mode" device tree attribute is defined for a platform,
> > the boost_supported flag is set. Moreover boost related attributes
> > were exported.
> >
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> >
> > Changes for v4:
> > - None
> >
> > Changes for v3:
> > - Remove low level boost code
> > - Move boost management code to cpufreq core code
> > - Use boost_supported flag to indicate if driver supports over
> > clocking
> >
> > Changes for v2:
> > - Removal of struct cpufreq_boost
> > - Removal of the CONFIG_CPU_FREQ_BOOST flag
> > - low_level_boost with valid address when boost is supported
> > ---
> >  drivers/cpufreq/exynos-cpufreq.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> 
> Yes, this looks fine..
> 
> I will Ack the whole series in the end, so no individual acks :)

Ok.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
