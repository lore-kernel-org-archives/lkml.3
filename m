Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3KMBaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:30:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab3KMBar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:30:47 -0500
Date: Tue, 12 Nov 2013 22:10:30 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 03/15] KVM: MMU: flush tlb if the spte can be
 locklessly modified
Message-ID: <20131113001030.GB14651@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:21PM +0800, Xiao Guangrong wrote:
> Relax the tlb flush condition since we will write-protect the spte out of mmu
> lock. Note lockless write-protection only marks the writable spte to readonly
> and the spte can be writable only if both SPTE_HOST_WRITEABLE and
> SPTE_MMU_WRITEABLE are set (that are tested by spte_is_locklessly_modifiable)
> 
> This patch is used to avoid this kind of race:
> 
>       VCPU 0                         VCPU 1
> lockless wirte protection:
>       set spte.w = 0
>                                  lock mmu-lock
> 
>                                  write protection the spte to sync shadow page,
>                                  see spte.w = 0, then without flush tlb
> 
> 				 unlock mmu-lock
> 
>                                  !!! At this point, the shadow page can still be
>                                      writable due to the corrupt tlb entry
>      Flush all TLB
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

