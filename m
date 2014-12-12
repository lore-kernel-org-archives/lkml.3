Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967740AbaLLMaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:30:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41154 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967442AbaLLMav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:30:51 -0500
Date: Fri, 12 Dec 2014 13:30:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
Message-ID: <20141212123048.GA31711@amd>
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


> +config X86_INTEL_MPX
> +	prompt "Intel MPX (Memory Protection Extensions)"
> +	def_bool y

bool?

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

Should you explain what kind of CPUs support it? Basically "the kind
you don't have, yet"?

> +	  If unsure, say Y.

Disagreed here. Right now, N is right response to anyone but Intel.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
