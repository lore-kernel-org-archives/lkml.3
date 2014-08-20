Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaHTIhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:37:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:50870 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaHTIg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:36:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374650619"
Date: Wed, 20 Aug 2014 16:38:34 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: vmx: fix ept reserved bits for 1-GByte page
Message-ID: <20140820083833.GA27197@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408519913-8943-1-git-send-email-wanpeng.li@linux.intel.com>
 <53F45893.6050305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F45893.6050305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 10:13:07AM +0200, Paolo Bonzini wrote:
>Il 20/08/2014 09:31, Wanpeng Li ha scritto:
>> EPT misconfig handler in kvm will check which reason lead to EPT
>> misconfiguration after vmexit. One of the reasons is that an EPT
>> paging-structure entry is configured with settings reserved for
>> future functionality. However, the handler can't identify if
>> paging-structure entry of reserved bits for 1-GByte page are
>> configured, since PDPTE which point to 1-GByte page will reserve
>> bits 29:12 instead of bits 7:3 which are reserved for PDPTE that
>> references an EPT Page Directory. This patch fix it by reserve
>> bits 29:12 for 1-GByte page.
>
>Thanks, the patch looks good.
>
>Can you describe how you detected the problem and how you're testing for it?
>

I found the issue by reviewing codes.

Regards,
Wanpeng Li 

>Paolo
