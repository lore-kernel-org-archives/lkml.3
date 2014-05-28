Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaE1CIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbaE1CIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:08:23 -0400
Date: Wed, 28 May 2014 10:09:35 +0800
From: Dave Young <dyoung@redhat.com>
To: "Fleming, Matt" <matt.fleming@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        vgoyal@redhat.com
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140528020935.GB2820@darkstar.nay.redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 at 02:36pm, Fleming, Matt wrote:
> On 27 May 2014 04:00, Dave Young <dyoung@redhat.com> wrote:
> > On 05/26/14 at 04:39pm, Dave Young wrote:
> >>
> >> For efi=old_map and any old_map quirks like SGI UV in current
> >> tree kexec/kdump will fail because it depends on the new 1:1 mapping.
> >>
> >> Thus export the mapping method to sysfs so kexec tools can switch
> >> to original way to boot.
> >>
> >> Since we have efi.flags for all efi facilities so let's just export the
> >> efi.flags itself, it maybe useful for other arches and use cases.
> >
> > Rethink about this issue, export flags will expose the efi facility
> > macros to userspace, Matt, what's your opinion? It might be better to export
> > a file 'old_map' only which is '0|1'
> 
> Exporting efi.flags is a non-starter. Those flags are part of an
> internal interface and I'm not prepared to turn them into a userspace
> ABI that we can never, ever change without a massive amount of pain.

Agree that it's not good to move them to external ones.

> 
> I've only vaguely been following along with the other thread, so please
> summarise everything again in your patch. Particularly, I need answers
> to the following questions,
> 
>  - Are you trying to fix a kexec/kdump regression?

Somehow it is a regression.
Before the 1:1 mapping kexec/kdump works with 'noefi'
plus acpi_rsdp= kernel cmdline. kexec-tools does not fill efi_info in boot_params
so kexec kernel will simply boot like 'noefi'.

Now we have 1:1 mapping, kexec-tools will boot with efi enabled but SGI UV is
still using old maping thus it become a problem. 

So kexec-tools need to know whether it's old_map or nor so it can switch to the
right way in case efi boot.

>  - Does SGI UV work with kexec + UEFI at all?

It works previously without enabling efi in boot_params. 

> 
> The 1:1 mapping was required to make kexec + EFI work in the first
> instance. If a machine implements the EFI 1:1 mapping, kexec should
> work. If it doesn't implement the 1:1 mapping, then it's probably not
> going to work, right?
> 
> The crux of the question: are you trying to fix a regression?
> 
> If not, then we just need to get SGI UV working with the EFI 1:1
> mapping. No?

Ditto as before explanation...

Thanks
Dave

