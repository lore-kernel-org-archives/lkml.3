Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbbAIMvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:51:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7354 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbbAIMvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:51:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,730,1413244800"; 
   d="scan'208";a="213986449"
Message-ID: <54AFCEE5.3060402@citrix.com>
Date: Fri, 9 Jan 2015 12:51:49 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: use correct type for physical addresses
References: <1420736490-15351-1-git-send-email-jgross@suse.com> <1420736490-15351-4-git-send-email-jgross@suse.com>
In-Reply-To: <1420736490-15351-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/15 17:01, Juergen Gross wrote:
> When converting a pfn to a physical address be sure to use 64 bit
> wide types.
> 
> Also avoid invalidating memory for zero sized non-aligned extra
> memory regions.

"Also" means this bit should be in another patch...

> Signed-off-by: Juergen Gross <jgross@suse.com>
> Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/xen/setup.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index feb6d86..8839d7b 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -160,6 +160,8 @@ void __init xen_inv_extra_mem(void)
>  	int i;
>  
>  	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
> +		if (!xen_extra_mem[i].size)
> +			continue;
>  		pfn_s = PFN_DOWN(xen_extra_mem[i].start);
>  		pfn_e = PFN_UP(xen_extra_mem[i].start + xen_extra_mem[i].size);
>  		for (pfn = pfn_s; pfn < pfn_e; pfn++)

i.e., this hunk should be in a separate path.

David
