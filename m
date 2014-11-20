Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080AbaKTFBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:01:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:31664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaKTFA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:00:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="488969896"
Message-ID: <546D7584.6070505@linux.intel.com>
Date: Thu, 20 Nov 2014 13:00:52 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] KVM: Initialize VT-d Posted-Interrtups Descriptor
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com> <1415600812-27773-3-git-send-email-feng.wu@intel.com> <546210B1.7060007@linux.intel.com> <E959C4978C3B6342920538CF579893F0022A04CD@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F0022A04CD@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/20 12:53, Wu, Feng wrote:
> 
> 
>> -----Original Message-----
<snit>
>>> +	/*
>>> +	 * Initialize Posted-Interrupt Descriptor
>>> +	 */
>>> +
>>> +	pi_clear_sn(&vmx->pi_desc);
>>> +	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
>>> +
>>> +	/* Physical mode for Notificaiton Event */
>>> +	vmx->pi_desc.ndm = 0;
>>> +	dest = cpu_physical_id(vmx->vcpu.cpu);
>>> +
>>> +	if (x2apic_mode)
>> Hi Feng,
>> 	Could you try to use x2apic_enabled() here so you don't
>> need to export x2apic_mode?
>> Regards!
>> Gerry
> 
> In that case, we should also export x2apic_enabled(), right?
Hi Feng,
	x2apic_enabled() is a static inline function:)
Regards!
Gerry
