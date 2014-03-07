Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaCGEVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:21:35 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33180 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaCGEVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:21:33 -0500
Message-ID: <5319494b.0ac5440a.6abf.60c9@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
Cc: "Russ Dill" <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Len Brown" <len.brown@intel.com>, "Nicolas Pitre" <nico@linaro.org>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "Jonathan Austin" <jonathan.austin@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        =?utf-8?q?=22Uwe_Kleine-K=C3=B6nig=22?= 
	<u.kleine-koenig@pengutronix.de>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Laura Abbott" <lauraa@codeaurora.org>, "Jiang Liu" <liuj97@gmail.com>,
        "Sricharan R" <r.sricharan@ti.com>,
        "Victor Kamensky" <victor.kamensky@linaro.org>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Ben Dooks" <ben.dooks@codethink.co.uk>,
        "Charles Baylis" <charles.baylis@linaro.org>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
 <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Date: Thu, 06 Mar 2014 20:21:23 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to those receiving repeated emails, I'm having an issue with some
of the special characters names.

Quoting Sebastian Capella (2014-03-05 02:50:05)
> From: Russ Dill <Russ.Dill@ti.com>
> Enable hibernation for ARM architectures and provide ARM
> architecture specific calls used during hibernation.
...
Quoting Stephen Boyd (2014-02-27 18:19:49)
> On 02/27/14 17:47, Russ Dill wrote:
> > On 02/27/2014 04:09 PM, Stephen Boyd wrote:
> >> On 02/27/14 15:57, Sebastian Capella wrote:
> >>> diff --git a/arch/arm/include/asm/memory.h
> >>> b/arch/arm/include/asm/memory.h index 8756e4b..1079ea8
> >>> 100644 ---
> >>> a/arch/arm/include/asm/memory.h +++
> >>> b/arch/arm/include/asm/memory.h @@ -291,6 +291,7 @@ static
> >>> inline
> >>> void *phys_to_virt(phys_addr_t x) */ #define __pa(x)
> >>> __virt_to_phys((unsigned long)(x)) #define __va(x)
> >>> ((void
> >>> *)__phys_to_virt((phys_addr_t)(x)))
> >>> +#define __pa_symbol(x)
> >>> __pa(RELOC_HIDE((unsigned long)(x), 0))
> >> Just curious, is there a reason for the RELOC_HIDE() here?
> >> Or
> >> __pa_symbol() for that matter? It looks like only x86 uses
> >> this on
> >> the __nosave_{begin,end} symbol. Maybe it's copy-pasta?
> > From my understanding this needs to stick around so long as
> > gcc 3.x is
> > supported (did it get dropped yet?) on ARM Linux since it
> > doesn't
> > support -fno-strict-overflow.
>
> I don't think it's been dropped yet but I wonder if anyone has
> tried
> recent kernels with such a compiler?

Hi Stephen,

I was wondering if you had any objections or additional comments on
the current patch.

I've basically dropped the RELOC_HIDE.  It hasn't proven to be an issue
with the current compiler, and I was unable to revert back to 3.x
compiler on the cortex-v7 platforms I'm using.

Since this is being used on Hibernation, we would not be breaking any
existing functionality in any event, and it sounds like this is unlikely
to be an issue.

I spoke informally to a friend who works on toolchains at Linaro and
he suggested this may be related to the the strict-aliasing feature
which appears to be disabled by default in the kernel
(-fno-strict-aliasing) and generally not well liked.

Unless someone objects, I'll plan to add this to Russell's patch system.

Thanks,

Sebastian

