Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaHGU0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:26:32 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:34026 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaHGU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:26:25 -0400
Date: Thu, 7 Aug 2014 21:26:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Message-ID: <20140807202620.GI15082@console-pimps.org>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
 <20140806130623.GI4179@bivouac.eciton.net>
 <20140806132021.GB15082@console-pimps.org>
 <20140806132941.GJ4179@bivouac.eciton.net>
 <20140806140155.GC15082@console-pimps.org>
 <CAKv+Gu8ey1iKu-_wS6yYaEXQaQMDXa+PF5Kiw+edA9a_OE1EAw@mail.gmail.com>
 <20140806141814.GD15082@console-pimps.org>
 <20140807061945.GE20295@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807061945.GE20295@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug, at 02:19:45PM, Dave Young wrote:
> 
> The current efi_runtime_init() enables the bit after getting the efi
> callback phyaddr of SetVirtualAddressMap.
> 
> Thinking more about it, since SetVirtualAddressMap() could fail
> somehow it seems better to set EFI_RUNTIME_SERIVCES bit only when
> enter virtual mode return EFI_SUCCESS.
> 
> Does it make sense to you, Matt?

If you're going ahead with the scheme I proposed yesterday you'd
actually want to *clear* the EFI_RUNTIME_SERVICES bit if
SetVirtualAddressMap() fails, since we would have set it by default for
EFI_BOOT.

However, I still think we want to panic() if SetVirtualAddressMap()
fails because we really never expect that function to return an error
under normal circumstances. Also, I'm not sure it's safe to make any
assumptions about the state of the system if SetVirtualAddressMap()
fails.

-- 
Matt Fleming, Intel Open Source Technology Center
