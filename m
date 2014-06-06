Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaFFOFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:05:42 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45484 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaFFOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:05:41 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: =?UTF-8?B?562U5aSNOg==?= [PATCH] ARM64:DMI: Add smbios/dmi
 support on arm64
To: liyi 00215672 <phoenix.liyi@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>, Yi Li <yi.li@linaro.org>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <D0F5605BA99F0B4594FB1EEC24E785CC37CA50D6@SZXEMA510-MBX.china.huawei.com>
References: <1401811033-16478-1-git-send-email-yi.li@linaro.org>
	<20140604133200.GA4329@leverpostej> <538F34D0.5090905@linaro.org>
	<20140605153353.GC31564@leverpostej>
	<D0F5605BA99F0B4594FB1EEC24E785CC37CA50D6@SZXEMA510-MBX.china.huawei.com>
Date: Fri, 06 Jun 2014 13:58:14 +0100
Message-Id: <20140606125814.C10A5C419C5@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 01:57:42 +0000, liyi 00215672 <phoenix.liyi@huawei.com> wrote:
> Please see below:
> 
> -----邮件原件-----
> 发件人: Mark Rutland [mailto:mark.rutland@arm.com] 
> 发送时间: 2014年6月5日 23:34
> 收件人: Yi Li
> 抄送: ard.biesheuvel@linaro.org; Catalin Marinas; Will Deacon; Sudeep Holla; steve.capper@linaro.org; Lorenzo Pieralisi; Liviu Dudau; grant.likely@linaro.org; liyi 00215672; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> 主题: Re: [PATCH] ARM64:DMI: Add smbios/dmi support on arm64
> 
> On Wed, Jun 04, 2014 at 04:01:36PM +0100, Yi Li wrote:
> > Hi Mark,
> > 
> >      Please see the comments below:
> > 
> > On Wednesday, June 04, 2014 09:32 PM, Mark Rutland wrote:
> > > On Tue, Jun 03, 2014 at 04:57:13PM +0100, Yi Li wrote:
> > >> Add smbios/dmi support on arm64 system, it depends on
> > >> EFI boot.
> > > And what exactly does this provide us with?
> > >
> > > What is exposed through SMBIOS/DMI, and why would I want to enable it?
> > Yi: SMBIOS/DMI is one basic spec/feature for server product(like x86 and 
> > IA64).
> >       Many OEMs/ODMs hope to use ARM64 as server's processor.
> >       So we need to support SMBIOS on ARM64.
> > 
> >      SMBIOS mainly describes some hardware and software information for 
> > the system, like BIOS information
> >      CPU information,  Memory information ,and so on. please refer to 
> > http://www.dmtf.org/standards/smbios
> 
> What information does it provide that is useful that we cannot get from
> elsewhere?
> Yi: As my previous mail, SMBIOS is one basic specification for all server production (x86 and IA64).
>   It can provide some SN or UUID of production/motherboard/memory, I think you can not get that from elsewhere.
> 
> What use case is enabled by having this support, other than being able
> to tick a box that we have a feature we might not even need?
> Yi: dmidecode/ lshw tools can be used as use case to test dmi driver is working well or not .
>   And SMBIOS is one MUST section in SBBR document, so it is needed. 

Hi Mark,

SMbios is important for the hardware vendors. It implements a spec for
providing descriptive information about the platform. Things like serial
numbers, physical layout of the ports, build configuration data, and the
like. It is a very important tool for vendors.

It is also a trivial thing to enable. smbios only provides management
data. It doesn't affect the driver model and it doesn't have side
effects into other subsystems. This patch should be accepted.

However...

Yi, can you write a better change log for the patch. It is important to
say why a patch is important, not just what the patch does.

g.


> > 
> > >
> > >> Signed-off-by: Yi Li <yi.li@linaro.org>
> > >> ---
> > >>
> > >> Changes since v1:
> > >>    -Followed Ard Biesheuvel's suggestion to rebase the patch on
> > >>     Matt Fleming's arm64-efi branch.
> > >>
> > >>   arch/arm64/Kconfig           |   10 ++++++++++
> > >>   arch/arm64/include/asm/dmi.h |   28 ++++++++++++++++++++++++++++
> > >>   arch/arm64/kernel/setup.c    |    2 ++
> > >>   3 files changed, 40 insertions(+)
> > >>   create mode 100644 arch/arm64/include/asm/dmi.h
> > >>
> > >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > >> index 6c71f12..13ee261 100644
> > >> --- a/arch/arm64/Kconfig
> > >> +++ b/arch/arm64/Kconfig
> > >> @@ -294,6 +294,16 @@ config EFI
> > >>   	  allow the kernel to be booted as an EFI application. This
> > >>   	  is only useful on systems that have UEFI firmware.
> > >>   
> > >> +config DMI
> > >> +	bool "Enable support for SMBIOS (DMI) tables"
> > >> +	depends on EFI
> > >> +	default y
> > >> +	help
> > >> +	  This enables SMBIOS/DMI feature for systems.
> > >> +
> > >> +	  This option is only useful on systems that have UEFI firmware.
> > >> +	  However, even with this option, the resultant kernel should
> > >> +	  continue to boot on existing non-UEFI platforms.
> > >>   endmenu
> > >>   
> > >>   menu "Userspace binary formats"
> > >> diff --git a/arch/arm64/include/asm/dmi.h b/arch/arm64/include/asm/dmi.h
> > >> new file mode 100644
> > >> index 0000000..f2198bf
> > >> --- /dev/null
> > >> +++ b/arch/arm64/include/asm/dmi.h
> > >> @@ -0,0 +1,28 @@
> > >> +/*
> > >> + * arch/arm64/include/asm/dmi.h
> > >> + *
> > >> + * Copyright (C) 2013 Linaro Limited.
> > >> + * Written by: Yi Li (yi.li@linaro.org)
> > >> + *
> > >> + * based on arch/ia64/include/asm/dmi.h
> > >> + *
> > >> + * This file is subject to the terms and conditions of the GNU General Public
> > >> + * License.  See the file "COPYING" in the main directory of this archive
> > >> + * for more details.
> > >> + */
> > >> +
> > >> +
> > >> +#ifndef _ASM_DMI_H
> > >> +#define _ASM_DMI_H 1
> > >> +
> > >> +#include <linux/slab.h>
> > >> +#include <asm/io.h>
> > > Shouldn't that be linux/efi.h?
> > >
> > > Why do we need asm/io.h?
> >      Yi: porting it from IA64 , so the io.h is not needed exactly!
> >           but slab.h is must included ,not efi.h (tested by compiling)
> 
> Below you refer to efi_lookup_mapped_addr, which (as far as I can tell)
> is defined in efi.h. You might be getting lucky with users of
> dmi_early_remap and dmi_remap having already incldued efi.h, but you
> shouldn't rely on it.
> 
> If you make use of something, you should include the header that defines
> it.
> 
> Yi: yes, correct. It is luck that dmi_scan.c has included efi.h , I will add efi.h in dmi.h later.
> 
> Cheers,
> Mark.
> 
> > >> +
> > >> +/* Use efi mappings for DMI */
> > >> +#define dmi_early_remap(x, l)	efi_lookup_mapped_addr(x)
> > >> +#define dmi_early_unmap(x, l)
> > >> +#define dmi_remap(x, l)			efi_lookup_mapped_addr(x)
> > >> +#define dmi_unmap(x)
> > >> +#define dmi_alloc(l)			kzalloc(l, GFP_ATOMIC)
> > >> +
> > >> +#endif
> > > None of these seem to use anything from io.h directly.
> >      Yi: You are right , io.h doesn't need.
> > > Cheers,
> > > Mark.
> > 
> > 

