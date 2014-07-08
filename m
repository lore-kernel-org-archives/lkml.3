Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaGHJZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:25:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:32673 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaGHJZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:25:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="360119301"
Date: Tue, 8 Jul 2014 17:26:28 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Bandan Das <bsd@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH] KVM: x86: Check for nested events if there is an
 injectable interrupt
Message-ID: <20140708092628.GA19860@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <jpgd2dgfp5s.fsf@redhat.com>
 <53BB86C2.9040805@redhat.com>
 <53BB9638.6040803@siemens.com>
 <53BBA523.4080006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBA523.4080006@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:00:35AM +0200, Paolo Bonzini wrote:
>Il 08/07/2014 08:56, Jan Kiszka ha scritto:
>>I don't think arch.nmi_pending can flip asynchronously, only in the
>>context of the VCPU thread - in contrast to pending IRQ states.
>
>Right, only nmi_queued is changed from other threads.  /me should
>really look at the code instead of going from memory.
>
>>>Jan, what do you think?  Can you run Jailhouse through this patch?
>>
>>Jailhouse seems fine with it, and it resolves the lockup of nested KVM
>>here as well.
>
>Thinking more about it, I think this is the right fix.  Not setting
>KVM_REQ_EVENT in some cases can be an optimization, but it's not
>necessary.  Definitely there are other cases in which KVM_REQ_EVENT
>is set even though no event is pending---most notably during
>emulation of invalid guest state.

Anyway, 

Reviewed-by: Wanpeng Li <wanpeng.li@linux.intel.com>

>
>Paolo
