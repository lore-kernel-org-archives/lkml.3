Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaHUX24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:28:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:14769 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaHUX2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:28:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,376,1406617200"; 
   d="scan'208";a="591610943"
Date: Fri, 22 Aug 2014 07:30:29 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] KVM: nVMX: nested TPR shadow/threshold emulation
Message-ID: <20140821233029.GA2420@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408621610-9665-1-git-send-email-wanpeng.li@linux.intel.com>
 <1408621610-9665-2-git-send-email-wanpeng.li@linux.intel.com>
 <53F5E720.9000308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F5E720.9000308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Thu, Aug 21, 2014 at 02:33:36PM +0200, Paolo Bonzini wrote:
[...]
>>  		return;
>> @@ -7847,6 +7859,27 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu,
>>  		vmx->nested.apic_access_page =
>>  			nested_get_page(vcpu, vmcs12->apic_access_addr);
>>  	}
>> +
>> +	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
>
>Missing PAGE_ALIGNED check.  I should have spotted this before, so I
>just fixed it and will commit the patch soon.
>

Maybe I misunderstand your comments "On real hardware you could point
the virtual-APIC page to an invalid address."
http://lists.openwall.net/linux-kernel/2014/08/07/344

>Thanks for your persistence!
>

Thanks for your great help. ;-)

Regards,
Wanpeng Li 

>Paolo
