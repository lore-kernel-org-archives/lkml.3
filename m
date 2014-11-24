Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaKXCbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:31:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:28791 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaKXCbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:31:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,446,1413270000"; 
   d="scan'208";a="627152785"
Date: Mon, 24 Nov 2014 10:10:09 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [CFT PATCH 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141124021009.GB27849@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com>
 <1416594678-13011-3-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416594678-13011-3-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Fri, Nov 21, 2014 at 07:31:18PM +0100, Paolo Bonzini wrote:
[...]
>+		u64 feature = valid & -valid;
>+		int index = fls64(feature) - 1;
>+		void *src = get_xsave_addr(xsave, feature);
>+
>+	        if (src) {
>+			u32 size, offset, ecx, edx;
>+			cpuid_count(XSTATE_CPUID, index,
>+				    &size, &offset, &ecx, &edx);
>+	                memcpy(dest + offset, src, size);

The offset you get is still for compact format, so you almost convert compat 
format to compat format instead of convert compact format to standard format. 
In addition, I think convert standard format to compact format should be 
implemented in put path.

Regards,
Wanpeng Li 

