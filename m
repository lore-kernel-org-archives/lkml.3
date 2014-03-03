Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaCCNPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:15:01 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42950 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940AbaCCNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:15:00 -0500
X-Sasl-enc: No0/uXV5OTAxZRMPC64MY46fD53iJJtjJBzRC7OnoEKj 1393852497
Message-ID: <5314804F.9090806@iki.fi>
Date: Mon, 03 Mar 2014 15:14:55 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Vegard Nossum <vegardno@ifi.uio.no>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, kmemcheck: Use kstrtoint() instead of sscanf()
References: <5304558F.9050605@huawei.com> <alpine.DEB.2.02.1402182344001.3551@chino.kir.corp.google.com> <alpine.DEB.2.02.1402191412300.31921@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402191412300.31921@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 12:14 AM, David Rientjes wrote:
> Kmemcheck should use the preferred interface for parsing command line
> arguments, kstrto*(), rather than sscanf() itself.  Use it appropriately.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Pekka Enberg <penberg@kernel.org>

Andrew, can you pick this up?

> ---
>   arch/x86/mm/kmemcheck/kmemcheck.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -78,10 +78,16 @@ early_initcall(kmemcheck_init);
>    */
>   static int __init param_kmemcheck(char *str)
>   {
> +	int val;
> +	int ret;
> +
>   	if (!str)
>   		return -EINVAL;
>   
> -	sscanf(str, "%d", &kmemcheck_enabled);
> +	ret = kstrtoint(str, 0, &val);
> +	if (ret)
> +		return ret;
> +	kmemcheck_enabled = val;
>   	return 0;
>   }
>   

