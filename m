Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaKYKd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:33:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:6557 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaKYKdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:33:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="490252348"
Date: Tue, 25 Nov 2014 18:13:31 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, namit@cs.technion.ac.il,
        hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
Message-ID: <20141125101331.GA28985@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Mon, Nov 24, 2014 at 05:43:32PM +0100, Paolo Bonzini wrote:
>The first patch ensures that XSAVES is not exposed in the guest until
>we emulate MSR_IA32_XSS.  The second exports XSAVE data in the correct
>format.
>
>I tested these on a non-XSAVES system so they should not be completely
>broken, but I need some help.  I am not even sure which XSAVE states
>are _not_ enabled, and thus compacted, in Linux.
>
>Note that these patches do not add support for XSAVES in the guest yet,
>since MSR_IA32_XSS is not emulated.
>
>If they fix the bug Nadav reported, I'll add Reported-by and commit.

I test this patchset w/ your "KVM: x86: export get_xsave_addr" patch on 
Skylake and guest hang during boot. The guest screen show "Probing EDD 
(edd=off to disable)... ok", and no more dump.

Regards,
Wanpeng Li 

>
>Thanks,
>
>Paolo
>
>v1->v2: also adjust KVM_SET_XSAVE
>
>Paolo Bonzini (2):
>  kvm: x86: mask out XSAVES
>  KVM: x86: support XSAVES usage in the host
>
> arch/x86/kvm/cpuid.c | 11 ++++++-
> arch/x86/kvm/x86.c   | 87 +++++++++++++++++++++++++++++++++++++++++++-----
> 2 files changed, 90 insertions(+), 8 deletions(-)
>
>-- 
>1.8.3.1
