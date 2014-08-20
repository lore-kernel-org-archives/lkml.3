Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaHTHai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:30:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:27970 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaHTHag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:30:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,900,1400050800"; 
   d="scan'208";a="579181670"
Date: Wed, 20 Aug 2014 15:32:09 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: vmx: fix ept reserved bits for 1-GByte page
Message-ID: <20140820073209.GA11700@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408504651-7341-1-git-send-email-wanpeng.li@linux.intel.com>
 <53F4457A.8060506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F4457A.8060506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 08:51:38AM +0200, Paolo Bonzini wrote:
>Il 20/08/2014 05:17, Wanpeng Li ha scritto:
>> +	else if (spte & (1ULL << 7))
>
>You have to check level == 1 specifically here, or add...
>
>> +		/*
>> +		 * 1GB/2MB page, bits 29:12 or 20:12 reserved respectively,
>> +		 * level == 1 if the hypervisor is using the ignored bit 7.
>> +		 */
>> +		mask |= (PAGE_SIZE << ((level - 1) * 9)) - PAGE_SIZE;
>> +	else
>
>... "if (level > 1)" here.
>
>Otherwise, you're marking bits 6:3 as reserved for 4K pages.  This
>should cause a WARN, because KVM puts 0110 in those bits:
>
>                ret = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT)
>                        | VMX_EPT_IPAT_BIT;
>
>(in vmx_get_mt_mask: writeback memory, ignore PAT memory type from the
>guest's page tables)
>

Got it.

Regards,
Wanpeng Li 

>How are you testing this patch?
>
>Paolo
>
>> +		/* bits 6:3 reserved */
>> +		mask |= 0x78;
