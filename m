Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3FSQ7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:59:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41999 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab3FSQ7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:59:10 -0400
Date: Wed, 19 Jun 2013 18:59:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619165902.GH28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130619161827.GF28300@pd.tnic>
 <20130619162115.GA28119@srcf.ucam.org>
 <20130619163804.GG28300@pd.tnic>
 <20130619164822.GA28240@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130619164822.GA28240@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 05:48:22PM +0100, Matthew Garrett wrote:
> > Ok, so it sounds like we want to *always* create both mappings but,
> > depending on what we want, to shove down SetVirtualAddressMap a
> > different set. And the 1:1 map will be the optional one which we give
> > SetVirtualAddressMap only when user wants it, i.e. when booting with
> > "efi=1:1_map".
> 
> Yup, I think that sounds ideal.

Crap, I got completely sidetracked. The 1:1 mappings go in a different
pagetable (real_mode_header->trampoline_pgd) than the kernel one
(i.e. init_mm.pgd). However, the ->trampoline_pgd has all mappings
anyway, which means that if we want to do EFI runtime calls with the
high mappings but *also* have the 1:1 mappings established, we should
*always* switch to that pagetable when doing those calls.

hpa, MattF, agreed?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
