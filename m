Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaLJSHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:07:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37715 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490AbaLJSHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:07:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,553,1413244800"; 
   d="scan'208";a="202958882"
Message-ID: <54888BC6.7030601@citrix.com>
Date: Wed, 10 Dec 2014 18:07:02 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: switch to post-init routines in xen
 mmu.c earlier
References: <1418226963-24873-1-git-send-email-jgross@suse.com>
In-Reply-To: <1418226963-24873-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 15:56, Juergen Gross wrote:
> With the virtual mapped linear p2m list the post-init mmu operations
> must be used for setting up the p2m mappings, as in case of
> CONFIG_FLATMEM the init routines may trigger BUGs.
> 
> Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/xen/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 6ab6150..a1a429a 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1225,6 +1225,7 @@ static void __init xen_pagetable_p2m_setup(void)
>  static void __init xen_pagetable_init(void)
>  {
>  	paging_init();
> +	xen_post_allocator_init();
>  
>  	xen_pagetable_p2m_setup();
>  

This feels very chicken-and-egg to me:  To setup the P2M we need to use
the MMU ops that use the P2M...

Please explain very clearly why this is all safe.

> @@ -1236,7 +1237,6 @@ static void __init xen_pagetable_init(void)
>  		xen_remap_memory();
>  
>  	xen_setup_shared_info();
> -	xen_post_allocator_init();
>  }
>  static void xen_write_cr2(unsigned long cr2)
>  {
> 

