Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaHAGoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:44:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:63256 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaHAGoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:44:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,778,1400050800"; 
   d="scan'208";a="578618688"
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
Thread-Index: AQHPrJX4RhX9yaWyK0S7bgZ3S5tyfZu5Y36AgAGGr9D//9v+gIAAhwdg
Date: Fri, 1 Aug 2014 06:44:10 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB4D72D@SHSMSX104.ccr.corp.intel.com>
References: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com>
 <53D90D5A.3060404@redhat.com> <20140731080353.GA3033@kernel>
 <53DA0B91.1010703@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB4D3F5@SHSMSX104.ccr.corp.intel.com>
 <53DB3517.1010408@redhat.com>
In-Reply-To: <53DB3517.1010408@redhat.com>
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

Paolo Bonzini wrote on 2014-08-01:
> Il 01/08/2014 02:57, Zhang, Yang Z ha scritto:
>>> TPR_THRESHOLD will be likely written as zero, but the processor
>>> will never use it anyway.  It's just a small optimization because
>>> nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW) will almost always
> be true.
>> 
>> Theoretically, you are right. But we should not expect all VMMs
>> follow it. It is not worth to violate the SDM just for saving two or
>> three instructions' cost.
> 
> Yes, you do need an "if (cpu_has_vmx_tpr_shadow())" around the
> vmcs_write32.  But still, checking nested_cpu_has is not strictly necessary.
> Right now they both are a single AND, but I have plans to change all
> of the
> cpu_has_*() checks to static keys.

See v2 patch. It isn't a problem anymore.

> 
> Paolo


Best regards,
Yang


