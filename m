Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3FFT3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:29:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39537 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab3FFT2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:28:53 -0400
Message-ID: <51B0E2D4.3040007@zytor.com>
Date: Thu, 06 Jun 2013 12:28:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
References: <1370177770-26661-1-git-send-email-bp@alien8.de> <1370177770-26661-5-git-send-email-bp@alien8.de> <20130606131439.GI30420@console-pimps.org> <20130606132908.GE20972@pd.tnic> <20130606155822.GH20972@pd.tnic>
In-Reply-To: <20130606155822.GH20972@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 08:58 AM, Borislav Petkov wrote:
> --
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 654be4ae3047..7a6129afdff1 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1021,6 +1021,9 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	/* Get the faulting address: */
>  	address = read_cr2();
>  
> +	if (read_cr3() == (unsigned long)real_mode_header->trampoline_pgd)
> +		pr_err("%s: #PF addr: 0x%lx\n", __func__, address);
> +
>  	/*
>  	 * Detect and handle instructions that would cause a page fault for
>  	 * both a tracked kernel page and a userspace page.
> 

Or we could materialize mappings for this specific PGD.  However, adding
a read of %cr3 in __do_page_fault sounds expensive.

	-hpa

