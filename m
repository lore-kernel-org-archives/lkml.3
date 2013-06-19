Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934449Ab3FSKdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:33:05 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:34507 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981Ab3FSKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:33:03 -0400
Message-ID: <51C188D6.9040603@redhat.com>
Date: Wed, 19 Jun 2013 12:32:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: MMU: update the documentation for reverse mapping
 of parent_pte
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1371632965-20077-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
> Update the document to match the current reverse mapping of
> parent_pte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/mmu.txt | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
> index 43fcb76..869abcc 100644
> --- a/Documentation/virtual/kvm/mmu.txt
> +++ b/Documentation/virtual/kvm/mmu.txt
> @@ -191,12 +191,12 @@ Shadow pages contain the following information:
>      A counter keeping track of how many hardware registers (guest cr3 or
>      pdptrs) are now pointing at the page.  While this counter is nonzero, the
>      page cannot be destroyed.  See role.invalid.
> -  multimapped:
> -    Whether there exist multiple sptes pointing at this page.
> -  parent_pte/parent_ptes:
> -    If multimapped is zero, parent_pte points at the single spte that points at
> -    this page's spt.  Otherwise, parent_ptes points at a data structure
> -    with a list of parent_ptes.
> +  parent_ptes:
> +    The reverse mapping for the pte/ptes pointing at this page's spt. If
> +    parent_ptes bit 0 is zero, only one spte points at this pages and
> +    parent_ptes points at this single spte, otherwise, there exists multiple
> +    sptes pointing at this page and (parent_ptes & ~0x1) points at a data
> +    structure with a list of parent_ptes.

Applying with this small change:

The reverse mapping for the pte/ptes pointing at this page's spt. If
bit 0 is zero, only one spte points at this pages and parent_ptes
points at this single spte.  If bit 0 is set, there exist multiple
sptes pointing at this page and (parent_ptes & ~0x1) points at a data
structure with a list of parent_ptes.

Paolo

>    unsync:
>      If true, then the translations in this page may not match the guest's
>      translation.  This is equivalent to the state of the tlb when a pte is
> 

