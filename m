Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3FPMDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 08:03:43 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43240 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab3FPMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 08:03:41 -0400
Date: Sun, 16 Jun 2013 14:03:36 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 28/31] mips/kvm: Only use KVM_COALESCED_MMIO_PAGE_OFFSET
 with KVM_MIPSTE
Message-ID: <20130616120336.GN20046@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-29-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-29-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:32PM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The forthcoming MIPSVZ code doesn't currently use this, so it must
> only be enabled for KVM_MIPSTE.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/kvm_host.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 505b804..9f209e1 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -25,7 +25,9 @@
>  /* memory slots that does not exposed to userspace */
>  #define KVM_PRIVATE_MEM_SLOTS 	0
>  
> +#ifdef CONFIG_KVM_MIPSTE
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> +#endif

What if KVM_MIPSTE and KVM_MIPSVZ both get enabled?

  Ralf
