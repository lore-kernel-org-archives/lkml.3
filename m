Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3GZJog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:44:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13405 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3GZJod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:44:33 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-56-51f245000833
Date: Fri, 26 Jul 2013 11:44:14 +0200
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
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 3/8] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Message-id: <20130726114414.6bb7bd65@amdc308.digital.local>
In-reply-to: <CAKohpokjgpiCmynmecs5XtWazz23qJ8USPVtKY-6sk-=MN19Hw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-4-git-send-email-l.majewski@samsung.com>
 <CAKohpo=3+JP0ppru5DSo72yWiN3Qg9xjNJX+6KgCNiEupZEMjA@mail.gmail.com>
 <20130726100940.1974559e@amdc308.digital.local>
 <CAKohpokjgpiCmynmecs5XtWazz23qJ8USPVtKY-6sk-=MN19Hw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQV0G10+BBrP6BC02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2uLxrDpvF594jjBa3G1ewWfQv7GWyePKw
	j81i41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mk41ixcsFqp4vvM0UwNjK18XIyeHhICJxJ6XP5khbDGJC/fWs3UxcnEICUxnlLj0
	9DcjhNPOJDHj/SOwKhYBVYkXb/eD2WwCehKf7z5l6mLk4BAR0JJ4eTMVpJ5ZYAWLxP4/kxlB
	aoQFCiU2rzgFVs8rYC3xueE/G4jNKRAssX7nL1aIBf+ZJBqeLgAr4heQlGj/9wPqJDuJc582
	sEM0C0r8mHyPBcRmBlq2eVsTK4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwTH1TGoH48oGi0OMAhyMSjy8Ck4fA4VYE8uKK3MPMUpwMCuJ8K51
	/BQoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgZFlOWfT
	+scdUySU71SuiN/36rz4ps8HTM5UG31gMpq37rNal3HENS++1lUMFkwKv1f/usxlv7/bp/il
	rHzYP/l1kRyJ9/d25GwOzF+gIn64sICzeVey0eeg1IgtO+uj5nwp3+TwYJl3t8eNs/zTp2Xm
	7RV4vneOadhazWZhiVnsTEV3EhMC/iuxFGckGmoxFxUnAgDAjpIrpQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 14:54:07 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 July 2013 13:39, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Fri, 26 Jul 2013 12:58:02 +0530 Viresh Kumar wrote,
> >> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> >> > diff --git a/drivers/cpufreq/acpi-cpufreq.c
> >> > b/drivers/cpufreq/acpi-cpufreq.c
> >>
> >> >  static void __init acpi_cpufreq_boost_init(void)
> >> >  {
> >> > +       acpi_cpufreq_driver.boost_supported = false;
> >             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> >>
> >> Would be better if we do this in else of below if.
> >
> > We need to set boost_supported = false at [*] for the case when:
> > 1. msrs_alloc fails
> > or
> > 2. acpi_cpufreq is built as a module and can be inserted and removed
> > several times. Without [*] we could end up with wrong (not false)
> > initial state.
> 
> Hmm.. Now that I see the code again, we don't need to set it to false
> as it is a global variable and this field is already set to false..

Ok, so then I will remove this line [*].

> 
> >> >         if (boot_cpu_has(X86_FEATURE_CPB) ||
> >> > boot_cpu_has(X86_FEATURE_IDA)) { msrs = msrs_alloc();
> >>
> >>
> >> > @@ -1021,12 +995,11 @@ static int __init acpi_cpufreq_init(void)
> >> >                         *iter = &cpb;
> >> >         }
> >> >  #endif
> >> > +       acpi_cpufreq_boost_init();
> >             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [**]
> >>
> >> We are calling it before registering cpufreq driver. Will this have
> >> any complications?
> >
> > When we call [**] after the cpufreq_register_driver [***] we end up
> > with sysfs boost attribute not exported at x86.
> > The boost attribute is exported at [***] only when
> > acpi_cpufreq.boost_supported = true. However support for boost at
> > x86 is evaluated at acpi_cpufreq_boost_init().
> 
> I understand why you moved it above cpufreq driver register. I was
> thinking if there can be few side effects of this..

As fair as I've tested it, there weren't any side effects. 

Moreover the acpi_cpufreq_boost_init() mostly read state of the HW, so
IMHO can be done before cpufreg_register_driver(). 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
