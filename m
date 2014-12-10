Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbaLJTl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:41:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:29296 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaLJTl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:41:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="427466627"
Message-ID: <5488A203.7000600@linux.intel.com>
Date: Wed, 10 Dec 2014 11:41:55 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos> <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
In-Reply-To: <CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 11:05 AM, Linus Torvalds wrote:
> Why would I want to enable this in my kernel when there are no actual
> CPU's out yet that support it? And even when there are, why would I do
> it if the CPU I have doesn't support it?

For folks that build their own kernels and know what CPU they have,
you'd never want to enable it other than compile testing (or maybe some
basic runtime testing to make sure we didn't mess up the #BR code on
CPUs without the feature).

But, this is the kind of option that we want to be *sure* is enabled
unless folks know exactly what they are doing, so we should probably
hide it behind CONFIG_EXPERT as well, just as SMEP is.

We might be getting to the point where we need to bury all these
Intel-specific options somewhere, but that's a patch for another day.

Patch is attached to convert it over to this:

config X86_INTEL_MPX
        prompt "Intel MPX (Memory Protection Extensions)" if EXPERT
        def_bool y
        depends on CPU_SUP_INTEL
        ---help---
          MPX provides hardware features that can be used in
          conjunction with compiler-instrumented code to check
          memory references.  It is designed to detect buffer
          overflow or underflow bugs.

          Enabling this option will make the kernel larger and
          slightly increase the size of some data structures.

          If unsure, say Y.
