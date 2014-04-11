Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaDKSo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:44:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46949 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbaDKSoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:44:55 -0400
Date: Fri, 11 Apr 2014 19:44:33 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Clarify Kconfig help for EFI_MIXED
Message-ID: <20140411184433.GA15344@console-pimps.org>
References: <1397239154-30121-1-git-send-email-thomas@archlinux.org>
 <53482E61.8050606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53482E61.8050606@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr, at 11:03:13AM, H. Peter Anvin wrote:
> On 04/11/2014 10:59 AM, Thomas Bächler wrote:
> > EFI stub support is only missing for a 64 bit kernel on 32-bit firmware,
> > on 64-bit kernels, EFI stub works as usual.
> > ---
> > 
> > Matt, I don't know if this help was intentionally discouraging,
> > however, out of curiosity, I tested this with ovmf, and the
> > kernel boots fine on 64-bit firmware bit with EFI stub, and on
> > 32-bit firmware using efilinux.
> > 
> > Documenting this properly is important for distribution kernels.
> > We would want to support this on Arch, but not if it means
> > introducing a regression for EFI stub users.
> > 
> >  arch/x86/Kconfig | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 5b8ec0f..2bbbbb9 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1529,8 +1529,8 @@ config EFI_MIXED
> >  	   mode.
> >  
> >  	   Note that it is not possible to boot a mixed-mode enabled
> > -	   kernel via the EFI boot stub - a bootloader that supports
> > -	   the EFI handover protocol must be used.
> > +	   kernel via the EFI boot stub on 32-bit firmware - a bootloader
> > +	   that supports the EFI handover protocol must be used.
> >  
> >  	   If unsure, say N.
> >  
> 
> Right, it is really that it is not possible to boot a mixed-mode kernel
> on its non-native firmware using the stub, since the stub itself can
> only be one way or the other.

Yeah, my help text was a bit... unhelpful.

CONFIG_EFI_MIXED does not introduce a regression of any sort, you can
enable it without worrying about that.

All the boot configurations that used to work will continue to work.

What I meant to say was that it isn't possible to use the EFI mixed
*feature* (booting a 64-bit kernel with 32-bit firmware) with the EFI
boot stub - so you can build support into your kernel but there's no way
to make the CPU actually execute those code paths.

-- 
Matt Fleming, Intel Open Source Technology Center
