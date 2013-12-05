Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3LEXKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:10:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3LEXKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:10:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu possible/present maps and map logical cpu id to APIC id
Date: Fri, 6 Dec 2013 00:09:54 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Linaro Patches <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org> <1386088753-2850-3-git-send-email-hanjun.guo@linaro.org> <CAL_JsqKF-_GCRR1d5Hs0F6pCMfLxUYkXAAp9hY7Ywuu1C+aZ0A@mail.gmail.com>
In-Reply-To: <CAL_JsqKF-_GCRR1d5Hs0F6pCMfLxUYkXAAp9hY7Ywuu1C+aZ0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312060009.54801.arnd@arndb.de>
X-Provags-ID: V02:K0:5tNKaesdR5TuqxBvQDzKGvoKjO1WBxy6KvHtxkO8QAa
 drIbisyaVrDjAa2aOKaeYiXeVtGvxWBp+/s6QKHhJp3PnZih1Q
 iF/IgHAaeC39bBaA4OIy6iofYQgnZ7fdOztR9P+g0VnqYLXTLS
 JGyOOurpMDmui1hoWdzkqdFrs8MMI/k6tZM6MSV+360rZZeo0X
 BcajoowDxaWAgWXz6FlbuwsS63mHwLzPElhajCHgkbqMxtTKOx
 cWADBDivH4N7gMLC+nNCg9JGxRBlNw0Am6pFpJi1TCQc1D+UHa
 mmakHaAVwZYXoztwIPA01EAAjtXa+71narHxS9LBH5QU0IgQB8
 wKDSuK1Z2nHg970sv7LE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013, Rob Herring wrote:
> > index a0c2ca6..1428024 100644
> > --- a/arch/arm64/kernel/smp.c
> > +++ b/arch/arm64/kernel/smp.c
> > @@ -420,7 +420,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> >                 if (err)
> >                         continue;
> >
> > +#ifndef CONFIG_ACPI
> >                 set_cpu_present(cpu, true);
> > +#endif
> 
> Should this be moved to DT cpu topology related code?

More importantly, the #ifndef is certainly wrong here: It is important that you can
turn CONFIG_ACPI on or off without impacting the run-time code path for non-ACPI
systems. The snippet above breaks this because we no longer set the
cpu mask when ACPI is turned on but not used.

	Arnd
