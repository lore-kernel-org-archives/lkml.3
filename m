Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaHAA5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:57:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:62885 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaHAA5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,776,1400050800"; 
   d="scan'208";a="463811895"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
Thread-Topic: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
Thread-Index: AQHPrJX4RhX9yaWyK0S7bgZ3S5tyfZu5Y36AgAGGr9A=
Date: Fri, 1 Aug 2014 00:57:11 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB4D3F5@SHSMSX104.ccr.corp.intel.com>
References: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com>
 <53D90D5A.3060404@redhat.com> <20140731080353.GA3033@kernel>
 <53DA0B91.1010703@redhat.com>
In-Reply-To: <53DA0B91.1010703@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote on 2014-07-31:
> Il 31/07/2014 10:03, Wanpeng Li ha scritto:
>>> One thing:
>>> 
>>>> +	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>>>> +		vmcs_write32(TPR_THRESHOLD, vmcs12->tpr_threshold);
>>> 
>>> I think you can just do this write unconditionally, since most
>>> hypervisors will enable this.  Also, you probably can add the tpr
>> 
>> What will happen if a hypervisor doesn't enable it? I make it more
>> cleaner in version two.
> 
> TPR_THRESHOLD will be likely written as zero, but the processor will
> never use it anyway.  It's just a small optimization because
> nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW) will almost always be true.

Theoretically, you are right. But we should not expect all VMMs follow it. It is not worth to violate the SDM just for saving two or three instructions' cost.

> 
> Paolo
> 
>>> threshold field to the read-write fields for shadow VMCS.
>> 
>> Agreed.
>> 
>> Regards,
>> Wanpeng Li


Best regards,
Yang


