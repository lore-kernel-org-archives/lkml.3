Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaGaJZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:25:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53269 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaGaJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:25:44 -0400
Message-ID: <53DA0B91.1010703@redhat.com>
Date: Thu, 31 Jul 2014 11:25:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com> <53D90D5A.3060404@redhat.com> <20140731080353.GA3033@kernel>
In-Reply-To: <20140731080353.GA3033@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/07/2014 10:03, Wanpeng Li ha scritto:
>> One thing:
>>
>>> +	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>>> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>>
>> I think you can just do this write unconditionally, since most
>> hypervisors will enable this.  Also, you probably can add the tpr
> 
> What will happen if a hypervisor doesn't enable it? I make it more 
> cleaner in version two.

TPR_THRESHOLD will be likely written as zero, but the processor will
never use it anyway.  It's just a small optimization because
nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW) will almost always be true.

Paolo

>> threshold field to the read-write fields for shadow VMCS.
> 
> Agreed.
> 
> Regards,
> Wanpeng Li 

