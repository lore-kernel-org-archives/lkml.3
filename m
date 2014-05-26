Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaEZPyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:54:41 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:16723 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaEZPyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:54:39 -0400
Message-ID: <538363B6.2010803@bfs.de>
Date: Mon, 26 May 2014 17:54:30 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benoit Taine <benoit.taine@lip6.fr>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/18] VMCI: Use kmemdup instead of kmalloc + memcpy
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr> <1401117687-28911-3-git-send-email-benoit.taine@lip6.fr>
In-Reply-To: <1401117687-28911-3-git-send-email-benoit.taine@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 26.05.2014 17:21, schrieb Benoit Taine:
> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/memdup.cocci
> 
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> ---
> Tested by compilation without errors.
> 
>  drivers/misc/vmw_vmci/vmci_datagram.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
> index f3cdd90..d93b469 100644
> --- a/drivers/misc/vmw_vmci/vmci_datagram.c
> +++ b/drivers/misc/vmw_vmci/vmci_datagram.c
> @@ -276,11 +276,10 @@ static int dg_dispatch_as_host(u32 context_id, struct vmci_datagram *dg)
>  		}
>  
>  		/* We make a copy to enqueue. */
> -		new_dg = kmalloc(dg_size, GFP_KERNEL);
> +		new_dg = kmemdup(dg, dg_size, GFP_KERNEL);
>  		if (new_dg == NULL)
>  			return VMCI_ERROR_NO_MEM;


i can not see much of the code but this looks like
  new_dg=dg;
what is possible in c99.

re,
 wh

>  
> -		memcpy(new_dg, dg, dg_size);
>  		retval = vmci_ctx_enqueue_datagram(dg->dst.context, new_dg);
>  		if (retval < VMCI_SUCCESS) {
>  			kfree(new_dg);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
