Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3FSRuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:50:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43917 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab3FSRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:50:13 -0400
Date: Wed, 19 Jun 2013 19:50:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619175005.GJ28300@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <51C1E996.9070209@zytor.com>
 <20130619173721.GI28300@pd.tnic>
 <51C1EC90.9030802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C1EC90.9030802@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 12:38:24PM -0500, H. Peter Anvin wrote:
> I thought that was the plan?

Well, currently if I'm booted with "efi=1:1_map" I'm creating only the
1:1 mapping in ->trampoline_pgd and switching the pagetable only then.
Otherwise, I'm using the high, ioremapped mappings - i.e., what we have
now.

I guess I can sync the kernel address space into ->trampoline_pgd after
having created the 1:1 mappings and always switch the pagetable later,
after we've done SetVirtualAddressMap.

Which should take care of the EFI boot stub issue too, as I can define
another set of efi_callX which switch the pagetable unconditionally.

Let me see how that pans out...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
