Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaD2Cgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:36:47 -0400
Received: from ozlabs.org ([103.22.144.67]:54369 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaD2Cgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:36:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        riel@redhat.com, mgorman@suse.de, ak@linux.intel.com,
        peterz@infradead.org, mingo@kernel.org, dave.hansen@intel.com,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 2/2] powerpc/pseries: init fault_around_order for pseries
In-Reply-To: <1398675690-16186-3-git-send-email-maddy@linux.vnet.ibm.com>
References: <1398675690-16186-1-git-send-email-maddy@linux.vnet.ibm.com> <1398675690-16186-3-git-send-email-maddy@linux.vnet.ibm.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 29 Apr 2014 11:48:40 +0930
Message-ID: <877g686fpb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Madhavan Srinivasan <maddy@linux.vnet.ibm.com> writes:
> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
> index 2db8cc6..c87e6b6 100644
> --- a/arch/powerpc/platforms/pseries/setup.c
> +++ b/arch/powerpc/platforms/pseries/setup.c
> @@ -74,6 +74,8 @@ int CMO_SecPSP = -1;
>  unsigned long CMO_PageSize = (ASM_CONST(1) << IOMMU_PAGE_SHIFT_4K);
>  EXPORT_SYMBOL(CMO_PageSize);
>  
> +extern unsigned int fault_around_order;
> +

It's considered bad form to do this.  Put the declaration in linux/mm.h.

Thanks,
Rusty.
PS.  But we're getting there! :)
