Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3ITOEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3ITOEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:04:48 -0400
Date: Fri, 20 Sep 2013 22:04:18 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Message-ID: <20130920140418.GF21922@dhcp-16-126.nay.redhat.com>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920090544.GA9574@pd.tnic>
 <20130920122915.GB21381@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920122915.GB21381@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/13 at 01:29pm, Matt Fleming wrote:
> On Fri, 20 Sep, at 11:05:44AM, Borislav Petkov wrote:
> > On Fri, Sep 20, 2013 at 03:29:04PM +0800, Dave Young wrote:
> > > Just tested this series, for 1st kernel It boots ok in qemu+ovmf. But
> > > it immediately reboot on my Thinkpad T420. Unfortunately there's no
> > > way to debug this very early problem because there's no serial port
> > > also earlyprintk does not work for efi boot. No usb debug as well on
> > > this machine. I will test it when I go back to work after the china
> > > holiday.
> > 
> > Hmm, I'm booting with the efi boot stub, how do you do it?
> 
> Dave, could you try this patch?

Matt,

It works for me, thanks for the quick fix.

> 
> ---
> 
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 06e71c2..9bcc15c 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -207,6 +207,8 @@ ENTRY(startup_64)
>  	jmp	preferred_addr
>  
>  ENTRY(efi_pe_entry)
> +	movq	%cr3, %r15
> +	movq	%r15, efi_scratch+16(%rip)
>  	mov	%rcx, %rdi
>  	mov	%rdx, %rsi
>  	pushq	%rdi
> @@ -219,6 +221,8 @@ ENTRY(efi_pe_entry)
>  	popq	%rdi
>  
>  ENTRY(efi_stub_entry)
> +	movq	%cr3, %r15
> +	movq	%r15, efi_scratch+16(%rip)
>  	call	efi_main
>  	movq	%rax,%rsi
>  	cmpq	$0,%rax
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
