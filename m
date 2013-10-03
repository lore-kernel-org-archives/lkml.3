Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3JCO12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:27:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36390 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab3JCO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:27:26 -0400
Date: Thu, 3 Oct 2013 15:27:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk,
        leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Message-ID: <20131003142721.GB2781@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
 <20131003095224.GX21381@console-pimps.org>
 <1380807804.17503.9.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380807804.17503.9.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct, at 09:43:24AM, Mark Salter wrote:
> On Thu, 2013-10-03 at 10:52 +0100, Matt Fleming wrote:
> > > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > > +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> > > +                            void *fdt, int new_fdt_size, char *cmdline_ptr,
> > > +                            u64 initrd_addr, u64 initrd_size,
> > > +                            efi_memory_desc_t *memory_map,
> > > +                            unsigned long map_size, unsigned long desc_size,
> > > +                            u32 desc_ver)
> > 
> > Hmm... does this function really belong in efi-stub-helper.c? That file
> > should be for architecture independent functionality only.
> > 
> 
> It isn't really arm-specific although arm is the only user right now.
> We're using the FDT to pass EFI boot info that is passed in the boot
> params block on x86. So potentially other architectures could use the
> same code.

It's not EFI-specific either, apart from the fdt property names.

> How about making it someting like:
> 
> #ifdef ARCH_NEEDS_EFI_FDT
> static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> ...
> #endif
> 
> so the architecture can decide whether to include it or not.

Is one implementation of this function going to fit all architectures?
Can we be sure of that ahead of time?

I'd prefer this to be kept in arch/ for now, and possibly moved into
efi-stub-helper.c at a later date if indeed it turns out to be generally
useful.

-- 
Matt Fleming, Intel Open Source Technology Center
