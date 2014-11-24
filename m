Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaKXC0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:26:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:36964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaKXC0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:26:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="420597268"
Date: Mon, 24 Nov 2014 10:05:53 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, fenghua.yu@intel.com,
        kvm list <kvm@vger.kernel.org>, Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: KVM causes #GP on XRSTORS
Message-ID: <20141124020553.GA27849@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <AA52FB0B-FB19-4DC0-964B-2984040B15A6@gmail.com>
 <546F505F.9080309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546F505F.9080309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Fri, Nov 21, 2014 at 03:46:55PM +0100, Paolo Bonzini wrote:
>
>
>On 20/11/2014 17:34, Nadav Amit wrote:
>> Fenghua,
>> 
>> I got KVM (v3.17) crashing on a machine that supports XRSTORS - It appears to get a #GP when it is trying to load the guest FPU.
>> One reason for the #GP is that XCOMP_BV[63] is zeroed on the guest_fpu, but I am not sure it is the only problem.
>> Was KVM ever tested with XRSTORS?
>
>What is the content of the CPUID[EAX=13,ECX=0] and CPUID[EAX=13,ECX=1]
>leaves on the host?
>
>Fenghua, which processors have XSAVEC, which have XGETBV with ECX=1, and
>which have XSAVES?  We need to expose this in QEMU, for which I can send

Skylake-client supports XSAVES.

>a patch later today or next week (CCing Eduardo for this).

Actually I do the xsaves work in kvm/qemu recently and the patches are
complete, I will start to test it before send out.

Regards,
Wanpeng Li 

>
>We will also have to uncompact the XSAVE area either in KVM_GET_XSAVE or
>in QEMU.  It's probably not hard to do it in the kernel.
>
>Paolo
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
