Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3JCT2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:28:06 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:49556 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab3JCT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:28:04 -0400
MIME-Version: 1.0
In-Reply-To: <20131003142721.GB2781@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
	<1380385403-31904-3-git-send-email-roy.franz@linaro.org>
	<20131003095224.GX21381@console-pimps.org>
	<1380807804.17503.9.camel@deneb.redhat.com>
	<20131003142721.GB2781@console-pimps.org>
Date: Thu, 3 Oct 2013 12:28:03 -0700
Message-ID: <CAFECyb-=2osh_j_9FCnWjAjLX-xbzanQeFjCLNTz4JKAk5d30w@mail.gmail.com>
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Mark Salter <msalter@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 7:27 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Thu, 03 Oct, at 09:43:24AM, Mark Salter wrote:
>> On Thu, 2013-10-03 at 10:52 +0100, Matt Fleming wrote:
>> > > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
>> > > +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>> > > +                            void *fdt, int new_fdt_size, char *cmdline_ptr,
>> > > +                            u64 initrd_addr, u64 initrd_size,
>> > > +                            efi_memory_desc_t *memory_map,
>> > > +                            unsigned long map_size, unsigned long desc_size,
>> > > +                            u32 desc_ver)
>> >
>> > Hmm... does this function really belong in efi-stub-helper.c? That file
>> > should be for architecture independent functionality only.
>> >
>>
>> It isn't really arm-specific although arm is the only user right now.
>> We're using the FDT to pass EFI boot info that is passed in the boot
>> params block on x86. So potentially other architectures could use the
>> same code.
>
> It's not EFI-specific either, apart from the fdt property names.
>
>> How about making it someting like:
>>
>> #ifdef ARCH_NEEDS_EFI_FDT
>> static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>> ...
>> #endif
>>
>> so the architecture can decide whether to include it or not.
>
> Is one implementation of this function going to fit all architectures?
> Can we be sure of that ahead of time?
>
> I'd prefer this to be kept in arch/ for now, and possibly moved into
> efi-stub-helper.c at a later date if indeed it turns out to be generally
> useful.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

   This  function is shared between ARM and ARM64, which are separate
architectures so to keep this in arch code would require it to be
duplicated for ARM/ARM64.  Would moving this function to a new
"efi-stub-fdt.c" file be satisfactory?  This file would just be used
the ARM and ARM64, so this would remove
the need for the top-level #ifdefs.

Thanks,
Roy
