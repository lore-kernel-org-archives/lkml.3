Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaHYJGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:06:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:10562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaHYJGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:06:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,395,1406617200"; 
   d="scan'208";a="589415797"
Date: Mon, 25 Aug 2014 17:08:22 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix xen guest panic due to lack of
 KVM_REQ_EVENT
Message-ID: <20140825090822.GA4955@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408953506-7289-1-git-send-email-wanpeng.li@linux.intel.com>
 <53FAFB53.7040806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FAFB53.7040806@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Mon, Aug 25, 2014 at 11:01:07AM +0200, Paolo Bonzini wrote:
>Il 25/08/2014 09:58, Wanpeng Li ha scritto:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c10408e..b7c0073 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4928,6 +4928,8 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>>  		if (!mask)
>>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>>  	}
>> +	if (!(int_shadow || mask))
>> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
>>  }
>>  
>>  static void inject_emulated_exception(struct kvm_vcpu *vcpu)
>
>No, this patch undoes the optimization in the buggy patch.
>
>A KVM_REQ_EVENT must be missing somewhere else.
>

Could you give some tips in order that I can figure it out?

Regards,
Wanpeng Li 

>Paolo
