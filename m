Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3LQNwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:52:03 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:35418 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948Ab3LQNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:52:00 -0500
Date: Tue, 17 Dec 2013 13:51:56 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Message-ID: <20131217135156.GC3145@console-pimps.org>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
 <20131217121024.GB3145@console-pimps.org>
 <20131217134006.GC30592@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131217134006.GC30592@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec, at 02:40:06PM, Borislav Petkov wrote:
> On Tue, Dec 17, 2013 at 12:10:24PM +0000, Matt Fleming wrote:
> > You sunk my i386 battleship,
> > 
> > /home/build/git/efi/arch/x86/platform/efi/efi.c:824:24: error: ‘struct real_mode_header’ has no member named ‘trampoline_pgd’
> > make[4]: *** [arch/x86/platform/efi/efi.o] Error 1
> > make[3]: *** [arch/x86/platform/efi] Error 2
> 
> Right, this is a recurring issue with the trampoline_pgd. What do you
> prefer: an #ifdef CONFIG_X86_64 or a separate function in efi_$(BITS).c?

Couldn't we do the mapping in efi_setup_page_tables() if we pass
__pa(new_memmap) and 1 << new_memmap_shift as arguments?

-- 
Matt Fleming, Intel Open Source Technology Center
