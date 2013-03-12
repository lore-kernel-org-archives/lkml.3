Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab3CLLgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:36:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56271 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab3CLLgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:36:18 -0400
Date: Tue, 12 Mar 2013 07:35:48 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sctp@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/18] net: sctp: remove cast for kmalloc/kzalloc return
 value
Message-ID: <20130312113548.GB25870@hmsreliant.think-freely.org>
References: <513EB23D.7020303@cn.fujitsu.com>
 <513EBFA3.4070303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513EBFA3.4070303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 01:39:47PM +0800, Zhang Yanfei wrote:
> remove cast for kmalloc/kzalloc return value.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-sctp@vger.kernel.org
> ---
>  include/net/sctp/sctp.h |    2 +-
>  net/sctp/protocol.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index df85a0c..cd89510 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -576,7 +576,7 @@ for (pos = chunk->subh.fwdtsn_hdr->skip;\
>  #define WORD_ROUND(s) (((s)+3)&~3)
>  
>  /* Make a new instance of type.  */
> -#define t_new(type, flags)	(type *)kzalloc(sizeof(type), flags)
> +#define t_new(type, flags)	kzalloc(sizeof(type), flags)
>  
>  /* Compare two timevals.  */
>  #define tv_lt(s, t) \
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 1c2e46c..eaee00c 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1403,7 +1403,7 @@ SCTP_STATIC __init int sctp_init(void)
>  
>  	/* Allocate and initialize the endpoint hash table.  */
>  	sctp_ep_hashsize = 64;
> -	sctp_ep_hashtable = (struct sctp_hashbucket *)
> +	sctp_ep_hashtable =
>  		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
>  	if (!sctp_ep_hashtable) {
>  		pr_err("Failed endpoint_hash alloc\n");
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

