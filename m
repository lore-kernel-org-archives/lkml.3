Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaH2LN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:13:57 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:14134 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaH2LN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:13:56 -0400
Message-ID: <5400606B.8010905@bfs.de>
Date: Fri, 29 Aug 2014 13:13:47 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, George Zhang <georgezhang@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] VMCI: integer overflow in vmci_datagram_dispatch()
References: <20140829084256.GA14780@mwanda>
In-Reply-To: <20140829084256.GA14780@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 29.08.2014 10:42, schrieb Dan Carpenter:
> This is untrusted user data from vmci_host_do_send_datagram() so the
> VMCI_DG_SIZE() macro can have an integer overflow.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
> index f3cdd90..8226652 100644
> --- a/drivers/misc/vmw_vmci/vmci_datagram.c
> +++ b/drivers/misc/vmw_vmci/vmci_datagram.c
> @@ -328,7 +328,8 @@ int vmci_datagram_dispatch(u32 context_id,
>  
>  	BUILD_BUG_ON(sizeof(struct vmci_datagram) != 24);
>  
> -	if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
> +	if (dg->payload_size > VMCI_MAX_DG_SIZE ||
> +	    VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
>  		pr_devel("Payload (size=%llu bytes) too big to send\n",
>  			 (unsigned long long)dg->payload_size);
>  		return VMCI_ERROR_INVALID_ARGS;

Are your sure about that ">" ? maybe ">=" was intended ?

re,
 wh

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
