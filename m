Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab3DYKrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:47:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50345 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab3DYKrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:47:33 -0400
Date: Thu, 25 Apr 2013 12:47:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
Message-ID: <20130425104729.GB32607@pd.tnic>
References: <1366798154-1380-1-git-send-email-bp@alien8.de>
 <20130424105610.GA15815@gmail.com>
 <5177BF67.2040308@intel.com>
 <20130425065529.GD7806@gmail.com>
 <5178D8E9.7020102@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5178D8E9.7020102@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 08:19:05AM +0100, Matt Fleming wrote:
> Yeah, I'm not advocating using casts, I was just saying "Oh, x86-64
> avoids requiring the caller of efi_call_phys* to perform the cast
> by doing it in the definition of efi_call*. That's why this is only
> affecting 32-bit."
>
> Cleaning this up would be nice. I think at this point, I'll apply
> Borislav's patch, and fix all this casting after v3.9 is released,
> since instead of just changing query_variable_info, we might as well
> change everything in efi_runtime_service_t so that it's consistent.

I wonder - if efi_runtime_service_t contained only void * like
efi_boot_services_t then we could drop all the casts too, right? Even in
the efi_call* macro calls too...

If you want me, I can take care of it after the merge window :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
