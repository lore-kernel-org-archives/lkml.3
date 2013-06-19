Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710Ab3FSMOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934297Ab3FSMOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:14:05 -0400
Message-ID: <51C1A083.9050209@redhat.com>
Date: Wed, 19 Jun 2013 14:13:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5/7] KVM: MMU: document fast page fault in
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
> Document fast page fault to Documentation/virtual/kvm/mmu.txt
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/mmu.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index 4fb442b..b5ce7dd 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -275,6 +275,9 @@ Handling a page fault is performed as follows:
>     information is stored and cache the information to vcpu->arch.mmio_gva,
>     vcpu->arch.access and vcpu->arch.mmio_gfn then call the emulator to emulate
>     the instruction who will get the benefit from the cached mmio info
> + - If both P bit and R/W bit of error code are set, there has a chance to
> +   fast fix the page fault, please see the description of "Fast page fault" in
> +   Documentation/virtual/kvm/locking.txt

 - If both P bit and R/W bit of error code are set, this could possibly
   be handled as a "fast page fault" (fixed without taking the MMU lock).  See
   the description in Documentation/virtual/kvm/locking.txt.

Paolo

>   - if needed, walk the guest page tables to determine the guest translation
>     (gva->gpa or ngpa->gpa)
>     - if permissions are insufficient, reflect the fault back to the guest
> 

