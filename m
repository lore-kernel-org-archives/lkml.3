Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3IVHmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 03:42:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3IVHmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 03:42:43 -0400
Date: Sun, 22 Sep 2013 10:42:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>, kvm@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
Message-ID: <20130922074238.GG25202@redhat.com>
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 04:06:10PM +0200, Paolo Bonzini wrote:
> Paul Gortmaker reported a BUG on preempt-rt kernels, due to taking the
> mmu_lock within the raw kvm_lock in mmu_shrink_scan.  He provided a
> patch that shrunk the kvm_lock critical section so that the mmu_lock
> critical section does not nest with it, but in the end there is no reason
> for the vm_list to be protected by a raw spinlock.  Only manipulations
> of kvm_usage_count and the consequent hardware_enable/disable operations
> are not preemptable.
> 
> This small series thus splits the kvm_lock in the "raw" part and the
> "non-raw" part.
> 
> Paul, could you please provide your Tested-by?
> 
Reviewed-by: Gleb Natapov <gleb@redhat.com>

But why should it go to stable?

> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (3):
>   KVM: cleanup (physical) CPU hotplug
>   KVM: protect kvm_usage_count with its own spinlock
>   KVM: Convert kvm_lock back to non-raw spinlock
> 
>  Documentation/virtual/kvm/locking.txt |  8 ++++--
>  arch/x86/kvm/mmu.c                    |  4 +--
>  arch/x86/kvm/x86.c                    |  8 +++---
>  include/linux/kvm_host.h              |  2 +-
>  virt/kvm/kvm_main.c                   | 51 ++++++++++++++++++-----------------
>  5 files changed, 40 insertions(+), 33 deletions(-)
> 
> -- 
> 1.8.3.1

--
			Gleb.
