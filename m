Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaJHPLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:11:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbaJHPK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:10:59 -0400
Message-ID: <543553C7.9010906@zytor.com>
Date: Wed, 08 Oct 2014 08:09:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, ak@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, whissi@whissi.de,
        kumagai-atsushi@mxc.nes.nec.co.jp, stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
References: <1412060896-1902-1-git-send-email-bhe@redhat.com> <542B1EC1.8090502@zytor.com> <20141001135237.GA13689@redhat.com>
In-Reply-To: <20141001135237.GA13689@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 06:52 AM, Vivek Goyal wrote:
> 
> Hi Peter,
> 
> I think there is some confusion. I will try to clarify.
> 
> If we have 32bit signed overflow, we will not have a functional kernel.
> And that's the message we get when we try to kexec with
> CONFIG_RANDOMIZE_BASE=y.
> 

And how does that happen?

> **********************************************************************
> [  340.709078] kexec: Starting new kernel
> early console in decompress_kernel
> KASLR disabled by default...
> 
> Decompressing Linux... Parsing ELF...
> 
> Performing relocations...
> 32-bit relocation outside of kernel!
> 
> 
>  -- System halted
> *****************************************************************
> 
> We realized that kexec tries to load kernel at higher physical addresses
> and that can lead to problmes.
> 
> Currently for x86_64, handle_relocations() will perform relocations if
> kernel is not loaded at LOAD_PHYSICAL_ADDR. I think this does not work for
> all the cases and kerenl can not be loaded anywhere in the physical address
> space. And that's why we run into issues with kexec.
> 
> My understanding is that we introduce handle_relcoations() i386 style
> because of RANDOMIZE_BASE. If that's the case, one possible solution
> is that perform relocations only if ranodmize base logic has chosen
> a different load location for kernel than where boot loader loaded
> it. Otherwise don't do anything.
> 
> In case of kexec/kdump, we will pass "nokaslr" to second kernel forcing
> it to do nothing and let the kernel run where it was loaded by bootloader.
> And in that case handle_relocations() should not do any relocations and
> that should allow kernel to be loaded anywhere in physical memory on
> x86_64.
> 

Sorry... this makes no sense.

For x86-64, there is no direct connection between the physical and
virtual address spaces that the kernel runs in...

	-hpa


