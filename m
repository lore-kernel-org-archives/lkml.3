Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3GHLuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:50:52 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:37250 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab3GHLus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:50:48 -0400
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] PF: Move architecture specifics to the backends
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Jul 2013 12:50:32 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Organization: ARM Ltd
Message-ID: <4a7e12c08e8973572f2bfe05cebb3dfb@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: dingel@linux.vnet.ibm.com, gleb@redhat.com, pbonzini@redhat.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, xiantao.zhang@intel.com, agraf@suse.de, christoffer.dall@linaro.org, ralf@linux-mips.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-05 21:55, Dominik Dingel wrote:
> Current common codes uses PAGE_OFFSET to indicate a bad host virtual 
> address.
> As this check won't work on architectures that don't map kernel and
> user memory
> into the same address space (e.g. s390), it is moved into architcture
> specific
> code.
>
> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
> ---
>  arch/arm/include/asm/kvm_host.h     |  8 ++++++++
>  arch/ia64/include/asm/kvm_host.h    |  3 +++
>  arch/mips/include/asm/kvm_host.h    |  6 ++++++
>  arch/powerpc/include/asm/kvm_host.h |  8 ++++++++
>  arch/s390/include/asm/kvm_host.h    | 12 ++++++++++++
>  arch/x86/include/asm/kvm_host.h     |  8 ++++++++
>  include/linux/kvm_host.h            |  8 --------
>  7 files changed, 45 insertions(+), 8 deletions(-)

[...]

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a63d83e..210f493 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -85,14 +85,6 @@ static inline bool is_noslot_pfn(pfn_t pfn)
>  	return pfn == KVM_PFN_NOSLOT;
>  }
>
> -#define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
> -#define KVM_HVA_ERR_RO_BAD	(PAGE_OFFSET + PAGE_SIZE)
> -
> -static inline bool kvm_is_error_hva(unsigned long addr)
> -{
> -	return addr >= PAGE_OFFSET;
> -}
> -
>  #define KVM_ERR_PTR_BAD_PAGE	(ERR_PTR(-ENOENT))
>
>  static inline bool is_error_page(struct page *page)

Nit: This breaks arm64. I suppose the patches have been created before 
the arm64 code got merged, so I'd expect the next version of this series 
to deal with arm64 as well.

Thanks,

         M.
-- 
Fast, cheap, reliable. Pick two.
