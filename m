Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaLDNxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:53:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbaLDNxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:53:07 -0500
Date: Thu, 4 Dec 2014 14:52:56 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Nadav Amit <namit@cs.technion.ac.il>, hpa@linux.intel.com,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141204135255.GA26941@potion.brq.redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
 <802AF3F4-2631-4979-A8CC-46B406546062@gmail.com>
 <547F1D84.9040505@redhat.com>
 <20141203184537.GA27128@potion.brq.redhat.com>
 <548064FF.3000107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <548064FF.3000107@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 14:43+0100, Paolo Bonzini:
> On 03/12/2014 19:45, Radim Krčmář wrote:
> > Btw, we don't care about crashers from userspace?
> 
> We do, but they're taken care of by
> 
>                 if (xstate_bv & ~kvm_supported_xcr0())
>                         return -EINVAL;
> 
> in kvm_vcpu_ioctl_x86_set_xsave.  kvm_supported_xcr0 is always a subset
> of host_xcr0, hence:

Ah, thanks.  (If this trend continues, I won't be able to hold even
bodily fluids after few more reviews ...)
