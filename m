Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaHTVAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:00:39 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:44301 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbaHTVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:00:37 -0400
Message-ID: <53F50C74.7080304@akamai.com>
Date: Wed, 20 Aug 2014 17:00:36 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
CC: drjones@redhat.com, konrad.wilk@oracle.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@kernel.org,
        davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH 1/1] jump_label: tidy jump_label_ratelimit.h
References: <1408526982-23196-1-git-send-email-yizhouzhou@ict.ac.cn>
In-Reply-To: <1408526982-23196-1-git-send-email-yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that looks good. While at it I grep'd the tree for
'CONFIG_JUMP_LABEL', and found some uses in the
netfilter code which should probably be
'HAVE_JUMP_LABEL' as well.

Thanks,

-Jason

On 08/20/2014 05:29 AM, Zhouyi Zhou wrote:
> jump_label_ratelimit.h is split from jump_label.h to enable the 
> includers who don't want linux/workqueue.h.
> As HAVE_JUMP_LABEL is only defined in jump_label.h, will following  
> patch makes jump_labe_ratelimit.h more tidy?
>
> Compiled and Tested in x86_64
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  include/linux/jump_label_ratelimit.h |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
> index 089f70f..0d34d7e 100644
> --- a/include/linux/jump_label_ratelimit.h
> +++ b/include/linux/jump_label_ratelimit.h
> @@ -4,15 +4,12 @@
>  #include <linux/jump_label.h>
>  #include <linux/workqueue.h>
>  
> -#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> +#ifdef HAVE_JUMP_LABEL
>  struct static_key_deferred {
>  	struct static_key key;
>  	unsigned long timeout;
>  	struct delayed_work work;
>  };
> -#endif
> -
> -#ifdef HAVE_JUMP_LABEL
>  extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
>  extern void
>  jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);

