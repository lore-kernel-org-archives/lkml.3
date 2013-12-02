Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3LBXJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:09:28 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:43906 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3LBXJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:09:26 -0500
MIME-Version: 1.0
In-Reply-To: <1385996185.1861.28.camel@deneb.redhat.com>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
	<1385595115-21488-3-git-send-email-roy.franz@linaro.org>
	<20131129113008.GB11775@console-pimps.org>
	<1385996185.1861.28.camel@deneb.redhat.com>
Date: Mon, 2 Dec 2013 15:09:26 -0800
Message-ID: <CAFECyb8nE8e_aqZe5VYJ6+2FzJVQEdCsuqR-fNyRSDapt3NVdg@mail.gmail.com>
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
From: Roy Franz <roy.franz@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <dave.martin@arm.com>, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 6:56 AM, Mark Salter <msalter@redhat.com> wrote:
> On Fri, 2013-11-29 at 11:30 +0000, Matt Fleming wrote:
>> >       /*
>> >        * Add an additional efi_memory_desc_t because we're doing an
>> >        * allocation which may be in a new descriptor region.
>> > +      * We allocate as EFI_RUNTIME_SERVICES_DATA since this is what
>> > +      * we want for when we pass the memory map to the kernel.  This
>> > +      * function is also used to get the memory map for other uses,
>> > +      * but is always freed by the stub so the allocation type
>> > +      * doesn't matter.
>> >        */
>> >       *map_size += sizeof(*m);
>> >       status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>> > -                             EFI_LOADER_DATA, *map_size, (void **)&m);
>> > +                             EFI_RUNTIME_SERVICES_DATA, *map_size,
>> > +                             (void **)&m);
>> >       if (status != EFI_SUCCESS)
>> >               goto fail;
>>
>>
>> OK, this needs a stronger justification. Presumably the reason for this
>> change is that you want the allocation to hang around once the kernel is
>> running? We have this problem on x86 and it's solved by reserving the
>> memory early in the kernel, e.g. memblock_reserve().
>> EFI_RUNTIME_SERVICES_DATA is for firmware use, not for kernel data.
>>
>
> Yeah, arm64 reserves it and is okay with it being EFI_LOADER_DATA.
>
> --Mark

I have discussed this with Leif and will change this back to
EFI_LOADER_DATA, and Leif will update
his runtime services patch to reserve this as done in your arm64 implementation.

Thanks,
Roy
