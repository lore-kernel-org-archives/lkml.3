Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaBHINz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:13:55 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36603 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaBHINx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:13:53 -0500
Message-ID: <52F5E739.3030809@redhat.com>
Date: Sat, 08 Feb 2014 09:13:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, akpm@linux-foundation.org
CC: x86@kernel.org, linux-kernel@vger.kernel.org, gleb@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 01/14] asmlinkage, kvm: Make kvm_rebooting visible
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/02/2014 08:51, Andi Kleen ha scritto:
> kvm_rebooting is referenced from assembler code, thus
> needs to be visible.
>
> Cc: gleb@redhat.com
> Cc: pbonzini@redhat.com
> Cc: kvm@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 03a0381..b5ec7fb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,7 +102,7 @@ static void kvm_release_pfn_dirty(pfn_t pfn);
>  static void mark_page_dirty_in_slot(struct kvm *kvm,
>  				    struct kvm_memory_slot *memslot, gfn_t gfn);
>
> -bool kvm_rebooting;
> +__visible bool kvm_rebooting;
>  EXPORT_SYMBOL_GPL(kvm_rebooting);
>
>  static bool largepages_enabled = true;
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
