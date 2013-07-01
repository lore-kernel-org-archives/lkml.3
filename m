Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3GAQBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:01:55 -0400
Received: from a10-63.smtp-out.amazonses.com ([54.240.10.63]:51677 "EHLO
	a10-63.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab3GAQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:01:54 -0400
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 12:01:53 EDT
Date: Mon, 1 Jul 2013 15:49:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/slab: Fix /proc/slabinfo unwriteable for slab
In-Reply-To: <1372069394-26167-3-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <0000013f9aed0ce5-ff542635-3074-4f9b-842e-d04492ed3e90-000000@email.amazonses.com>
References: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com> <1372069394-26167-3-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.10.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Wanpeng Li wrote:

>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d161b81..7fdde79 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -631,10 +631,20 @@ static const struct file_operations proc_slabinfo_operations = {
>  	.release	= seq_release,
>  };
>
> +#ifdef CONFIG_SLAB
> +static int __init slab_proc_init(void)
> +{
> +	proc_create("slabinfo", S_IWUSR | S_IRUSR, NULL, &proc_slabinfo_operations);
> +	return 0;
> +}
> +#endif
> +#ifdef CONFIG_SLUB
>  static int __init slab_proc_init(void)
>  {
>  	proc_create("slabinfo", S_IRUSR, NULL, &proc_slabinfo_operations);
>  	return 0;
>  }

It may be easier to define a macro SLABINFO_RIGHTS and use #ifdefs to
assign the correct one. That way we have only one slab_proc_init().
