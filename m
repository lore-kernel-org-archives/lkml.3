Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbaLKGTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:19:41 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48155 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaLKGTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:19:39 -0500
Date: Thu, 11 Dec 2014 07:19:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
Message-ID: <20141211061935.GA5059@gmail.com>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
 <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
 <5488A203.7000600@linux.intel.com>
 <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
 <5488AF8D.5070702@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5488AF8D.5070702@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave.hansen@linux.intel.com> wrote:

> @@ -1575,6 +1571,27 @@ config X86_SMAP
>  
>  	  If unsure, say Y.
>  
> +config X86_INTEL_MPX
> +	prompt "Intel MPX (Memory Protection Extensions)" if EXPERT

I think the 'if EXPERT' needs to be dropped.

> +	def_bool y
> +	depends on CPU_SUP_INTEL

On the one hand, the 'def_bool y' might be acceptable, if we 
think of MPX as X32 or SECCOMP: ABI extensions that are only 
really useful if all distros enable it.

On the other hand, unlike x32 and seccomp, MPX increases data 
structure size and adds a few instructions to common, non-MPX 
code paths, so the cost isn't just kernel image size.

Linus, what's your preference?

> +	  Enabling this option will make the kernel larger and
> +	  slightly increase the size of some kernel data
> +	  structures.

And will add a few branches to critical code paths, right?

It would be nice to give some numeric data in such cases, by what 
percentage does MPX support increase the x86_64 defconfig kernel 
for example? By how much does it increase data structure size? 
Make costs and benefits transparent and most people will chose 
wisely, or at least well informed.

Thanks,

	Ingo
