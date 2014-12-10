Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaLJQOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:14:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbaLJQOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:14:08 -0500
Date: Wed, 10 Dec 2014 11:13:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Subject: Re: [PATCH] xen: switch to post-init routines in xen mmu.c earlier
Message-ID: <20141210161353.GD4268@laptop.dumpdata.com>
References: <1418226963-24873-1-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418226963-24873-1-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 04:56:03PM +0100, Juergen Gross wrote:
> With the virtual mapped linear p2m list the post-init mmu operations
> must be used for setting up the p2m mappings, as in case of
> CONFIG_FLATMEM the init routines may trigger BUGs.

Um, could you explain a bit more of why the CONFIG_FLATMEM
is such unique? What about the other CONFIG_*MEM cases?

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
> @@ -1236,7 +1237,6 @@ static void __init xen_pagetable_init(void)
>  		xen_remap_memory();
>  
>  	xen_setup_shared_info();
> -	xen_post_allocator_init();
>  }
>  static void xen_write_cr2(unsigned long cr2)
>  {
> -- 
> 2.1.2
> 
