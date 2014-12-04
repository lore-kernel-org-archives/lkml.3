Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaLDR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:56:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbaLDR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:56:14 -0500
Date: Thu, 4 Dec 2014 18:56:02 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] KVM: x86: support XSAVES usage in the host
Message-ID: <20141204175602.GA18653@potion.brq.redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417708634-24333-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 16:57+0100, Paolo Bonzini:
> Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
> struct xsave_struct might be using the compacted format.  Convert
> in order to preserve userspace ABI.
> 
> Likewise, userspace is passing non-compacted format for KVM_SET_XSAVE
> but the kernel will pass it to XRSTORS, and we need to convert back.
> 
> Fixes: f31a9f7c71691569359fa7fb8b0acaa44bce0324
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: stable@vger.kernel.org
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Reported-by: Nadav Amit <namit@cs.technion.ac.il>
> Tested-by: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

> +++ b/arch/x86/kvm/x86.c
> @@ -3132,15 +3132,89 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> +	u64 xstate_bv = xsave->xsave_hdr.xstate_bv;

(This looks like the only change since last review.)
