Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3JPIY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab3JPIY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:24:26 -0400
Date: Wed, 16 Oct 2013 16:24:03 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: matt@console-pimps.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86 efi: efi reverve boot service fix
Message-ID: <20131016082402.GA27678@dhcp-16-126.nay.redhat.com>
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com>
 <20131016071122.GB18241@dhcp-16-126.nay.redhat.com>
 <525E4076.2070107@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525E4076.2070107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/13 at 12:29am, H. Peter Anvin wrote:
> On 10/16/2013 12:11 AM, Dave Young wrote:
> >>
> >> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> >> +++ linux-2.6/arch/x86/platform/efi/efi.c
> >> @@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
> >>  		 * - Not within any part of the kernel
> >>  		 * - Not the bios reserved area
> >>  		*/
> >> -		if ((start+size >= __pa_symbol(_text)
> >> +		if ((start + size - 1 >= __pa_symbol(_text)
> >>  				&& start <= __pa_symbol(_end)) ||
> >>  			!e820_all_mapped(start, start+size, E820_RAM) ||
> >>  			memblock_is_region_reserved(start, size)) {
> 
> It would be better to change >= to >.

Both are fine to me, will resend with '>'
