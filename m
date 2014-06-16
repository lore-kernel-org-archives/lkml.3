Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaFPPbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:31:01 -0400
Received: from linode.aoot.com ([69.164.194.13]:55275 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaFPPbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:31:00 -0400
Message-ID: <539F0DAF.1020802@opengridcomputing.com>
Date: Mon, 16 Jun 2014 10:30:55 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com
CC: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/2014 10:25 AM, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
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
>   	} else {
> +		if (skb)
> +			kfree_skb (skb);
>   		skb = alloc_skb(len, gfp);
>   	}
>   	t4_set_arp_err_handler(skb, NULL, NULL);

Can you change the comment?  This patch is now fixing a potential skb 
leak.  Also, kfree_sb() will ignore NULL ptrs, so we could just always 
call it.  But I'd add a comment like /* NULL is ignored */.

Thanks,

Steve.
