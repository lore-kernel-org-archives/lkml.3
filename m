Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LBO5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:57:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3LBO5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:57:02 -0500
Message-ID: <1385996185.1861.28.camel@deneb.redhat.com>
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk,
        leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        patches@linaro.org
Date: Mon, 02 Dec 2013 09:56:25 -0500
In-Reply-To: <20131129113008.GB11775@console-pimps.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
	 <1385595115-21488-3-git-send-email-roy.franz@linaro.org>
	 <20131129113008.GB11775@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-29 at 11:30 +0000, Matt Fleming wrote:
> >       /*
> >        * Add an additional efi_memory_desc_t because we're doing an
> >        * allocation which may be in a new descriptor region.
> > +      * We allocate as EFI_RUNTIME_SERVICES_DATA since this is what
> > +      * we want for when we pass the memory map to the kernel.  This
> > +      * function is also used to get the memory map for other uses,
> > +      * but is always freed by the stub so the allocation type
> > +      * doesn't matter.
> >        */
> >       *map_size += sizeof(*m);
> >       status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
> > -                             EFI_LOADER_DATA, *map_size, (void **)&m);
> > +                             EFI_RUNTIME_SERVICES_DATA, *map_size,
> > +                             (void **)&m);
> >       if (status != EFI_SUCCESS)
> >               goto fail;
>   
> 
> OK, this needs a stronger justification. Presumably the reason for this
> change is that you want the allocation to hang around once the kernel is
> running? We have this problem on x86 and it's solved by reserving the
> memory early in the kernel, e.g. memblock_reserve().
> EFI_RUNTIME_SERVICES_DATA is for firmware use, not for kernel data.
> 

Yeah, arm64 reserves it and is okay with it being EFI_LOADER_DATA.

--Mark


