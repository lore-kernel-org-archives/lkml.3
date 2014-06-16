Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaFPSec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:34:32 -0400
Received: from linode.aoot.com ([69.164.194.13]:56925 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbaFPSeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:34:31 -0400
Message-ID: <539F38B3.2020405@opengridcomputing.com>
Date: Mon, 16 Jun 2014 13:34:27 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, swise@chelsio.com
CC: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infinibad: fix memory leak in function send_flowc
References: <1402943456-7532-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402943456-7532-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/2014 1:30 PM, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 5e153f6..c518411 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -455,7 +455,10 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
>   	unsigned int flowclen = 80;
>   	struct fw_flowc_wr *flowc;
>   	int i;
>
> +	if (!skb) {
> +		kfree_skb();
> +		pr_warn(MOD "%s failed to allocate skb.\n", __func__);
> +	}
>   	skb = get_skb(skb, flowclen, GFP_KERNEL);

Oops, shouldn't the if statement be after the call to get_skb()?  :) 
(you're having a bad day ;))

>   	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
>   

One more nit:  The comment is no longer correct.  It should be something 
like:

iw_cxgb4: in send_flowc(), handle a null skb return from get_skb()


