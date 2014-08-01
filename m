Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaHAGfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaHAGfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:35:18 -0400
Message-ID: <53DB3517.1010408@redhat.com>
Date: Fri, 01 Aug 2014 08:35:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: nVMX: nested TPR shadow/threshold emulation
References: <1406721880-5490-1-git-send-email-wanpeng.li@linux.intel.com> <53D90D5A.3060404@redhat.com> <20140731080353.GA3033@kernel> <53DA0B91.1010703@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AB4D3F5@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AB4D3F5@SHSMSX104.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/08/2014 02:57, Zhang, Yang Z ha scritto:
> > TPR_THRESHOLD will be likely written as zero, but the processor will
> > never use it anyway.  It's just a small optimization because
> > nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW) will almost always be true.
> 
> Theoretically, you are right. But we should not expect all VMMs
> follow it. It is not worth to violate the SDM just for saving two or
> three instructions' cost.

Yes, you do need an "if (cpu_has_vmx_tpr_shadow())" around the
vmcs_write32.  But still, checking nested_cpu_has is not strictly
necessary.  Right now they both are a single AND, but I have plans to
change all of the cpu_has_*() checks to static keys.

Paolo
