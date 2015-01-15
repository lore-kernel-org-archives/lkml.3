Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbAOJ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:26:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbbAOJ0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:26:51 -0500
Message-ID: <54B787D7.7040202@suse.com>
Date: Thu, 15 Jan 2015 10:26:47 +0100
From: =?windows-1252?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/8] x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com> <1421312314-72330-4-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1421312314-72330-4-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 09:58 AM, Christian Borntraeger wrote:
> ACCESS_ONCE does not work reliably on non-scalar types. For
> example gcc 4.6 and 4.7 might remove the volatile tag for such
> accesses during the SRA (scalar replacement of aggregates) step
> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
>
> Change the p2m code to replace ACCESS_ONCE with READ_ONCE.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Juergen Gross <jgross@suse.com>

> ---
>   arch/x86/xen/p2m.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index edbc7a6..cb71016 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -554,7 +554,7 @@ static bool alloc_p2m(unsigned long pfn)
>   		mid_mfn = NULL;
>   	}
>
> -	p2m_pfn = pte_pfn(ACCESS_ONCE(*ptep));
> +	p2m_pfn = pte_pfn(READ_ONCE(*ptep));
>   	if (p2m_pfn == PFN_DOWN(__pa(p2m_identity)) ||
>   	    p2m_pfn == PFN_DOWN(__pa(p2m_missing))) {
>   		/* p2m leaf page is missing */
>

