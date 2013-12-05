Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3LEP2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:28:15 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57336 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751826Ab3LEP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:28:14 -0500
Date: Thu, 5 Dec 2013 15:28:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Message-ID: <20131205152806.GC974@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-2-git-send-email-msalter@redhat.com>
 <20131205141853.GA974@darko.cambridge.arm.com>
 <1386254603.1861.120.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386254603.1861.120.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 02:43:23PM +0000, Mark Salter wrote:
> On Thu, 2013-12-05 at 14:18 +0000, Catalin Marinas wrote:
> > On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> > > This patch adds PE/COFF header fields to the start of the Image
> > > so that it appears as an EFI application to EFI firmware. An EFI
> > > stub is included to allow direct booting of the kernel Image. Due
> > > to EFI firmware limitations, only little endian kernels with 4K
> > > page sizes are supported at this time.
> > 
> > I don't fully understand the EFI firmware limitations but for big endian
> > we could have the EFI_STUB wrapper in little endian and get the kernel
> > to switch to big endian once booted. The image header should always be
> > little endian.
> 
> That would be fun. :) You'd also have to switch back and forth to make
> EFI runtime services calls.

OK, we'll have to live with this restriction.

> > And I have to dig further into the 4K limitation (or you could give a
> > quick summary ;)).
> 
> Just that the current UEFI spec mandates 4K pages for UEFI. So if UEFI
> maps two 4k pages with different attributes and those two pages are
> within the same 64k kernel page, there'd be a problem. I'd be better if
> UEFI used 64k pages, then the kernel could easily use 4k or 64k.

For server space, we may see some people asking for 64K pages. But I
don't know whether there are any UEFI plans here.

Thanks.

-- 
Catalin
