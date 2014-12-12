Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965982AbaLLIbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:31:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62866 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894AbaLLIbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:31:39 -0500
Date: Fri, 12 Dec 2014 09:31:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
Message-ID: <20141212083134.GA32182@gmail.com>
References: <alpine.DEB.2.11.1412091504490.16275@nanos>
 <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
 <5488A203.7000600@linux.intel.com>
 <CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>
 <5488AF8D.5070702@linux.intel.com>
 <20141211061935.GA5059@gmail.com>
 <548A147E.1020507@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548A147E.1020507@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave.hansen@linux.intel.com> wrote:

> +config X86_INTEL_MPX
> +	prompt "Intel MPX (Memory Protection Extensions)"
> +	def_bool y
> +	depends on CPU_SUP_INTEL
> +	---help---
> +	  MPX provides hardware features that can be used in
> +	  conjunction with compiler-instrumented code to check
> +	  memory references.  It is designed to detect buffer
> +	  overflow or underflow bugs.
> +
> +	  This option enables running applications which are
> +	  instrumented or otherwise use MPX.  It does not use MPX
> +	  itself inside the kernel or to protect the kernel
> +	  against bad memory references.
> +
> +	  Enabling this option will make the kernel larger:
> +	  ~8k of kernel text and 36 bytes of data on a 64-bit
> +	  defconfig.  It adds a long to the 'mm_struct' which
> +	  will increase the kernel memory overhead of each
> +	  process and adds some branches to paths used during
> +	  exec() and munmap().
> +
> +	  If unsure, say Y.

That description looks pretty good to me.

Linus, what's your take on the default-y? To me it seems there's 
arguments both ways: usually we allow unprivileged ABIs to be 
disabled only under EXPERT and make them default-y (to help 
adaption and to define what the default ABI of 'Linux' is - we 
did a default-y for SECCOMP for example) - OTOH this is a new 
ABI, the processors aren't even out yet, and there's costs to the 
MM code even in the non-MPX case, so it's not as clear-cut as in 
the SECCOMP case which had essentially zero runtime cost.

Thanks,

	Ingo
