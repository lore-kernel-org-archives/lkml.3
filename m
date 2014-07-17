Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaGQLtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:49:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:26580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbaGQLtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:49:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,678,1400050800"; 
   d="scan'208";a="571243214"
Date: Thu, 17 Jul 2014 19:50:08 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        Zhang Yang <yang.z.zhang@intel.com>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Fix virtual interrupt delivery
 injection
Message-ID: <20140717115008.GA10133@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1405594981-31384-1-git-send-email-wanpeng.li@linux.intel.com>
 <53C7B3FA.3050506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7B3FA.3050506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:31:06PM +0200, Paolo Bonzini wrote:
>Il 17/07/2014 13:03, Wanpeng Li ha scritto:
>>+		/*
>>+		 * Fall back to old way to inject the interrupt since there
>>+		 * is no vAPIC-v for L2.
>>+		 */
>>+		if (vcpu->arch.exception.pending ||
>>+				vcpu->arch.nmi_injected ||
>>+				vcpu->arch.interrupt.pending)
>>+			return;
>
>This is just
>
>	if (kvm_event_needs_reinjection(vcpu))
>		return;
>
>but apart from this the patch is okay.  I'll make the change and
>apply it, thanks.
>

Thanks.

Regards,
Wanpeng Li 

>Paolo
