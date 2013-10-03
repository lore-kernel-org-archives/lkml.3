Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3JCO6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab3JCO6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:58:15 -0400
Message-ID: <1380812255.17503.19.camel@deneb.redhat.com>
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk,
        leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com
Date: Thu, 03 Oct 2013 10:57:35 -0400
In-Reply-To: <20131003142721.GB2781@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
	 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
	 <20131003095224.GX21381@console-pimps.org>
	 <1380807804.17503.9.camel@deneb.redhat.com>
	 <20131003142721.GB2781@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 15:27 +0100, Matt Fleming wrote:
> On Thu, 03 Oct, at 09:43:24AM, Mark Salter wrote:
> > On Thu, 2013-10-03 at 10:52 +0100, Matt Fleming wrote:
> > > > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > > > +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> > > > +                            void *fdt, int new_fdt_size, char *cmdline_ptr,
> > > > +                            u64 initrd_addr, u64 initrd_size,
> > > > +                            efi_memory_desc_t *memory_map,
> > > > +                            unsigned long map_size, unsigned long desc_size,
> > > > +                            u32 desc_ver)
> > > 
> > > Hmm... does this function really belong in efi-stub-helper.c? That file
> > > should be for architecture independent functionality only.
> > > 
> > 
> > It isn't really arm-specific although arm is the only user right now.
> > We're using the FDT to pass EFI boot info that is passed in the boot
> > params block on x86. So potentially other architectures could use the
> > same code.
> 
> It's not EFI-specific either, apart from the fdt property names.

Not EFI-specific in the sense that it uses the EFI services, but it is
EFI-specific in its function.

> 
> > How about making it someting like:
> > 
> > #ifdef ARCH_NEEDS_EFI_FDT
> > static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> > ...
> > #endif
> > 
> > so the architecture can decide whether to include it or not.
> 
> Is one implementation of this function going to fit all architectures?
> Can we be sure of that ahead of time?
> 
> I'd prefer this to be kept in arch/ for now, and possibly moved into
> efi-stub-helper.c at a later date if indeed it turns out to be generally
> useful.

Fair enough. I don't have a strong opinion about it either way. Just a
natural instinct to share the code if possible, but it is easy enough
to change later if others want to use it.

--Mark


