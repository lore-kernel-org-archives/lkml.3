Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3H3LRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:17:09 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:40155 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab3H3LRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:17:07 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 16/16] Add config EFI_STUB for ARM to Kconfig
To: Roy Franz <roy.franz@linaro.org>, Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
In-Reply-To: <CAFECyb8m=5kExhusmepcebyUyBN5R9f7Kjah8NzXJ26Pmo=MNA@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-17-git-send-email-roy.franz@linaro.org> <20130813131857.GE2823@localhost.localdomain> <CAFECyb8m=5kExhusmepcebyUyBN5R9f7Kjah8NzXJ26Pmo=MNA@mail.gmail.com>
Date: Fri, 30 Aug 2013 12:17:10 +0100
Message-Id: <20130830111710.911FC3E102A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 10:37:13 -0700, Roy Franz <roy.franz@linaro.org> wrote:
> On Tue, Aug 13, 2013 at 6:18 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> > On Fri, Aug 09, 2013 at 04:26:17PM -0700, Roy Franz wrote:
> >> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> >> ---
> >>  arch/arm/Kconfig |   11 +++++++++++
> >>  1 file changed, 11 insertions(+)
> >>
> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >> index 43594d5..8607d03 100644
> >> --- a/arch/arm/Kconfig
> >> +++ b/arch/arm/Kconfig
> >> @@ -1805,6 +1805,17 @@ config UACCESS_WITH_MEMCPY
> >>         However, if the CPU data cache is using a write-allocate mode,
> >>         this option is unlikely to provide any performance gain.
> >>
> >> +config EFI_STUB
> >> +     bool "EFI stub support"
> >> +     depends on EFI
> >
> > && !CPU_BIG_ENDIAN, in case you didn't get around to that.
> >
> > Sooner or later, someone may try to fix that, so there should be a
> > comment somewhere explaining what is broken for BE.
> >
> > Either in efi-stub.c or in the commit message accompanying this patch, I
> > guess.
> >
> EFI will be !CPU_BIG_ENDIAN, so we will get the dependency
> transitively through EFI.
> That said, I think it may be better to have both be explicitly
> !CPU_BIG_ENDIAN, as even
> though the underlying reasons are the same (EFI services calls being
> little endian), both
> the stub and runtime services would need to be fixed to enable the
> stub to run in BE mode.
> I'll make this explicit in the stub Kconfig, and add a comment by the
> PE/COFF magic number
> regarding the LE requirement.

Actually, not true! Steve McIntyre is currently doing some of the BE
porting work on TC2 running UEFI. Eventually he will need this.

g.

