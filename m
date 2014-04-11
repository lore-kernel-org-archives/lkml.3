Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaDKC21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:28:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:21540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbaDKC2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:28:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,838,1389772800"; 
   d="scan'208";a="417602701"
Message-ID: <53475344.5090009@linux.intel.com>
Date: Thu, 10 Apr 2014 19:28:20 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost> <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com> <53444220.50009@intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com> <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost> <5345D360.5000506@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com>
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 06:19 AM, Romer, Benjamin M wrote:
> 
> I'm confused by the intended behavior of KVM.. Is the intention of the
> -cpu switch to fully emulate a particular CPU? If that's the case, the
> Intel documentation says bit 31 should always be 0, so the value
> returned by the cpuid instruction isn't correct. If the intention is to
> present a VM with a specific CPU architecture, the CPU ought to behave
> as described in Intel's virtualization documentation and just vmexit
> instead of faulting with invalid op, IMHO. 
> 
> I've already said the check in the code was insufficient, and I'm trying
> to fix that part now. :)
> 

I'm still confused where KVM comes into the picture.  Are you actually
using KVM (and thus talking about nested virtualization) or are you
using Qemu in JIT mode and running another hypervisor underneath?

The hypervisor bit is a complete red herring.  If the guest CPU is
running in VT-x mode, then VMCALL should VMEXIT inside the guest
(invoking the guest root VT-x), but the fact still remains that you
should never, ever, invoke VMCALL unless you know what hypervisor you
have underneath.

	-hpa

