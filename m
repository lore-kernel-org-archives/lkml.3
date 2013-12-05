Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3LEOny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:43:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab3LEOnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:43:51 -0500
Message-ID: <1386254603.1861.120.camel@deneb.redhat.com>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
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
Date: Thu, 05 Dec 2013 09:43:23 -0500
In-Reply-To: <20131205141853.GA974@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-2-git-send-email-msalter@redhat.com>
	 <20131205141853.GA974@darko.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 14:18 +0000, Catalin Marinas wrote:
> On Fri, Nov 29, 2013 at 10:05:10PM +0000, Mark Salter wrote:
> > This patch adds PE/COFF header fields to the start of the Image
> > so that it appears as an EFI application to EFI firmware. An EFI
> > stub is included to allow direct booting of the kernel Image. Due
> > to EFI firmware limitations, only little endian kernels with 4K
> > page sizes are supported at this time.
> 
> I don't fully understand the EFI firmware limitations but for big endian
> we could have the EFI_STUB wrapper in little endian and get the kernel
> to switch to big endian once booted. The image header should always be
> little endian.

That would be fun. :) You'd also have to switch back and forth to make
EFI runtime services calls.

> 
> And I have to dig further into the 4K limitation (or you could give a
> quick summary ;)).

Just that the current UEFI spec mandates 4K pages for UEFI. So if UEFI
maps two 4k pages with different attributes and those two pages are
within the same 64k kernel page, there'd be a problem. I'd be better if
UEFI used 64k pages, then the kernel could easily use 4k or 64k.

--Mark


