Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3HLJMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:12:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39960 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3HLJMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:12:49 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-f7-5208a710c471
Date: Mon, 12 Aug 2013 11:12:21 +0200
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
Message-id: <20130812111221.0d15147a@amdc308.digital.local>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQV2B5RxBBq/bpCw2zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2uLxrDpvF594jjBa3G1ewWfQv7GWyePKw
	j81i41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4MqZNvcpYMFewYn3PPeYGxqm8XYwcHBICJhKtc4S7GDmBTDGJC/fWs3UxcnEICUxn
	lHix6BY7SEJIoJ1JYskfeRCbRUBVoun3OlYQm01AT+Lz3adMIHNEBLQkXt5MBellFljBIrH/
	z2RGkBphgUKJzStOMYPYvALWEnsXL2IBsTkFgiXW7/zFCrHsP5NEw9MFYEX8ApIS7f9+MENc
	ZCdx7tMGdohmQYkfk++BNTMDLdu8rYkVwpaX2LzmLfMERsFZSMpmISmbhaRsASPzKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzgiHomvYNxVYPFIUYBDkYlHl6PL+xBQqyJZcWVuYcYJTiY
	lUR41eZxBAnxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg
	VFumerpbbG9ywKf1bB8cPh21qGm4/sqgxvOrzL+l0632T6s3dZr4rlfk2uGgTfXxR1uPzonT
	V7n4evphv5ub/14Q2/vnda0rY9SyzMZzopePmu1Sze5+m3HWxsohcBqHQd+54tdJR72mPNQ+
	IfJ2X+f1mVNkfrVNDfby+/ml49bbl8lmB8rYM5VYijMSDbWYi4oTAV2AwM6kAgAA
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

Ok, I will delete the line at [*].

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

Have any problem with the above change came to your mind? 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
