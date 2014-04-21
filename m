Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaDUVBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbaDUVBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:01:11 -0400
Date: Mon, 21 Apr 2014 17:12:56 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] KVM: x86: speedups for emulator memory accesses
Message-ID: <20140421201256.GA1615@amt.cnet>
References: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396366006-22227-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:26:40PM +0200, Paolo Bonzini wrote:
> Another emulator speedup series, shaving up to 400 cycles (25%) off
> RMW instructions.
> 
> The performance of various instructions is now relatively flat:
> 
>  jump  919  (down from 2300)
>  move  1075 (down from 2700)
>  arith 1081 (down from 2600)
>  load  1267 (down from 2800, 1400 after previous round)
>  store 1213 (down from 2900, 1300 after previous round)
>  RMW   1310 (down from 3200, 1700 after previous round)
> 
> The next low-hanging fruit is fetching instructions and initializing
> the context.  Similar optimizations to those done here could be made
> for instruction fetch.
> 
> Paolo Bonzini (6):
>   KVM: emulate: simplify writeback
>   KVM: emulate: abstract handling of memory operands
>   KVM: export mark_page_dirty_in_slot
>   KVM: emulate: introduce memory_prepare callback to speed up memory access
>   KVM: emulate: activate memory access optimization
>   KVM: emulate: extend memory access optimization to stores
> 
>  arch/x86/include/asm/kvm_emulate.h |  28 ++++++++++
>  arch/x86/kvm/emulate.c             | 107 +++++++++++++++++++++++++++----------
>  arch/x86/kvm/x86.c                 |  67 +++++++++++++++++++++++
>  include/linux/kvm_host.h           |   6 +++
>  virt/kvm/kvm_main.c                |  17 ++----
>  5 files changed, 185 insertions(+), 40 deletions(-)
> 
> -- 
> 1.8.3.1

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

