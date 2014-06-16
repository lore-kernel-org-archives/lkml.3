Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaFPRJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:09:04 -0400
Received: from linode.aoot.com ([69.164.194.13]:42100 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbaFPRJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:09:02 -0400
Message-ID: <539F24AA.1020406@opengridcomputing.com>
Date: Mon, 16 Jun 2014 12:08:58 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com
CC: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch Resend] infiniband:memory leak in get_skb function in
 file cm.c
References: <1402938381-5882-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402938381-5882-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/16/2014 12:06 PM, Nicholas Krause wrote:
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f9477e2..2d56983 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,15 +340,13 @@ static int status2errno(int status)
>    */
>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>   {
>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>                  skb_trim(skb, 0);
>                  skb_get(skb);
>                  skb_reset_transport_header(skb);
>          } else {
> +if (!skb)
> +	skb_kfree(skb);
> +	/*NULL is ignored */
>                  skb = alloc_skb(len, gfp);

This is still incorrect and the formatting is screwy.

As we discussed, you can call skb_kfree() with a NULL skb and it will 
silently ignore it.  So you don't need th 'if (!skb)'...

Perhaps you should read up more on submitting patches to get the 
formatting correct, and how to use the various tools, etc.

steve.
>          }
>          t4_set_arp_err_handler(skb, NULL, NULL);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

