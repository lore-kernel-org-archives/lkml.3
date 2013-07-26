Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab3GZIKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:10:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13339 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3GZIK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:10:26 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-d3-51f22eefa47c
Date: Fri, 26 Jul 2013 10:09:40 +0200
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
Message-id: <20130726100940.1974559e@amdc308.digital.local>
In-reply-to: <CAKohpo=3+JP0ppru5DSo72yWiN3Qg9xjNJX+6KgCNiEupZEMjA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-4-git-send-email-l.majewski@samsung.com>
 <CAKohpo=3+JP0ppru5DSo72yWiN3Qg9xjNJX+6KgCNiEupZEMjA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd33ep8CDY6eMrPYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgylj0tIOl4D1vxenHu5kaGDdwdTFyckgImEisbnzHDmGLSVy4t56ti5GLQ0hgEaPE
	hV8/mSCcdiaJ07famECqWARUJaZf+MoIYrMJ6El8vvsUKM7BISKgJfHyZipIPbPAChaJ/X8m
	g9UICxRKbF5xihnE5hWwlng8dzIzSD2nQLDEkr/eEPPbmCRuPZ4PdgW/gKRE+78fzBAX2Umc
	+7SBHaJXUOLH5HssIDYz0K7N25pYIWx5ic1r3jJPYBSchaRsFpKyWUjKFjAyr2IUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIjqlnUjsYVzZYHGIU4GBU4uFVcPoYKMSaWFZcmXuIUYKDWUmE
	t+EYUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAMjf4Hd
	1inffXYVNR34vXPn8g1p/GcXLLOUjDe6xfhgQ01j94zlNd+ESteqJL5+qXEjbLP22lu3g6q6
	y91/bfi9QK9+lfCNbvtCafPOyW1/DRcYcxZtvhrwIviBa+PdwAYhLfYabea7Vya8Oz8t6vQ2
	b/2dCUWlbnb+lcrp8yTUzl3mDE7JZHyjxFKckWioxVxUnAgALt/rn6UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 12:58:02 +0530 Viresh Kumar wrote,
> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > diff --git a/drivers/cpufreq/acpi-cpufreq.c
> > b/drivers/cpufreq/acpi-cpufreq.c
> 
> >  static void __init acpi_cpufreq_boost_init(void)
> >  {
> > +       acpi_cpufreq_driver.boost_supported = false;
	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [*]
> 
> Would be better if we do this in else of below if.

We need to set boost_supported = false at [*] for the case when:
1. msrs_alloc fails 
or 
2. acpi_cpufreq is built as a module and can be inserted and removed
several times. Without [*] we could end up with wrong (not false)
initial state.

> 
> >         if (boot_cpu_has(X86_FEATURE_CPB) ||
> > boot_cpu_has(X86_FEATURE_IDA)) { msrs = msrs_alloc();
> 
> 
> > @@ -1021,12 +995,11 @@ static int __init acpi_cpufreq_init(void)
> >                         *iter = &cpb;
> >         }
> >  #endif
> > +       acpi_cpufreq_boost_init();
	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ [**]
> 
> We are calling it before registering cpufreq driver. Will this have
> any complications?

When we call [**] after the cpufreq_register_driver [***] we end up with
sysfs boost attribute not exported at x86.
The boost attribute is exported at [***] only when
acpi_cpufreq.boost_supported = true. However support for boost at x86
is evaluated at acpi_cpufreq_boost_init().


> 
> >         ret = cpufreq_register_driver(&acpi_cpufreq_driver);
> >         if (ret)
> >                 free_acpi_perf_data();
> > -       else
> > -               acpi_cpufreq_boost_init();
> >
> >         return ret;



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
