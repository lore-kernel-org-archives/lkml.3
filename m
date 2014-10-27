Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaJ0PvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:51:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaJ0PvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:51:10 -0400
Message-ID: <544E69E5.7040700@redhat.com>
Date: Mon, 27 Oct 2014 16:51:01 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: trivial fix comment regarding __kvm_set_memory_region
References: <1414423376-64491-1-git-send-email-dingel@linux.vnet.ibm.com>
In-Reply-To: <1414423376-64491-1-git-send-email-dingel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 04:22 PM, Dominik Dingel wrote:
> commit 72dc67a69690 ("KVM: remove the usage of the mmap_sem for the protection of the memory slots.")
> changed the lock which will be taken. This should be reflected in the function
> commentary.

Whoa, February 2008. :)

Thanks, applying this patch.

Paolo

> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d82ec25..8b13607 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -738,7 +738,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>   *
>   * Discontiguous memory is allowed, mostly for framebuffers.
>   *
> - * Must be called holding mmap_sem for write.
> + * Must be called holding kvm->slots_lock for write.
>   */
>  int __kvm_set_memory_region(struct kvm *kvm,
>  			    struct kvm_userspace_memory_region *mem)
> 
