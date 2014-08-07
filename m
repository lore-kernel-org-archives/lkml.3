Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaHGB0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:26:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbaHGB0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:26:12 -0400
Date: Thu, 7 Aug 2014 09:27:09 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, catalin.marinas@arm.com,
        will.deacon@arm.com, matt.fleming@intel.com, ard.biesheuvel@linaro.org,
        msalter@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140807012708.GA20295@darkstar.nay.redhat.com>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806140155.GC15082@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/14 at 03:01pm, Matt Fleming wrote:
> On Wed, 06 Aug, at 02:29:41PM, Leif Lindholm wrote:
> > On Wed, Aug 06, 2014 at 02:20:21PM +0100, Matt Fleming wrote:
> > > > Since this is really turning an x86-specific feature into a generic
> > > > one, could it be moved to core code?
> > > > Maybe an efi.mask, reusing the efi_enabled defines, with an
> > > > efi_disabled macro?
> > >  
> > > Why the new efi_disabled() and efi.mask? This is all achievable with
> > > efi_enabled() and efi.flags, in fact, this kind of thing is exactly why
> > > they were invented.
> > 
> > Because this flag is indicating which facilities we should not try to
> > enable, rather than which facilities we have enabled.
> > 
> > The EFI_RUNTIME_SERVICES flag is set after successful call to
> > set_virtual_address_map. The apparent intent of "noefi" is to prevent
> > that call from being made in the first place.
> > 
> > Anyway, it was just a suggestion - main point was it would make sense
> > to share the code.
> 
> Definitely.
> 
> Dave, below is the kind of thing that I had in mind. Please Cc the Xen
> and SGI folks when you submit your next version because they're likely
> to be hit the hardest by any changes to EFI_RUNTIME_SERVICES and
> "noefi".
> 
> Obviously the addition of "efi=noruntime" is needed on top, but that's
> about 6 lines of code.

[snip]

Matt, will file a new version based on your code. I will also address the
failure case in enter virtual mode.

Currently in x86, there's cases such as efi_map_regions failure and efi call
set_virtual_address_map, in case those failures it should be better to
unset the EFI_RUNTIME_SERVICES in efi.flags instead of do noting or panic.

As for Xen and SGI people? I have not been following all the efi threads
so I'm not sure who exactly I should cc, could you tell me? 


Thanks
Dave
