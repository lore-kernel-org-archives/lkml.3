Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3JYKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:42:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3JYKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:42:50 -0400
X-AuditID: cbfee691-b7f866d000001b8c-8d-526a4b281d8b
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Ray Jui'" <rjui@broadcom.com>, "'Chris Ball'" <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org
References: <1C995FCD38EDD646A035D3E5892E8C7C04C189A8@SJEXCHMB13.corp.ad.broadcom.com>
In-reply-to: <1C995FCD38EDD646A035D3E5892E8C7C04C189A8@SJEXCHMB13.corp.ad.broadcom.com>
Subject: RE: [PATCH] mmc: fix host release issue after discard operation
Date: Fri, 25 Oct 2013 19:42:48 +0900
Message-id: <001301ced16e$f2695480$d73bfd80$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7RBfyzY93ANZCAT8mBR0aq+1TZbAAF1uhw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zQ10N76wggyOPlCy2v97IZnF51xw2
	i6czN7M5MHvMun+WzePQlbWMHp83yQUwR3HZpKTmZJalFunbJXBlvLp+m6ngrlDFw/NT2RoY
	v/F1MXJySAiYSPT8n8gIYYtJXLi3nq2LkYtDSGAZo8TNV1tZYYqe3t7IDmILCUxnlDhxLAWi
	6A+jxKkP/UwgCTYBLYm/b94wdzFycIgIOEi8visPEmYWUJD4dW8TK0RvhMS3F2/ZQGxOgUiJ
	Sc/ngcWFBTwkHjz7DnYEi4CqxKslD8B28QrYSvz/8ZoRwhaU+DH5HgvETD2Jj39uM0LY8hKb
	17wFWyshoC7x6K8uSFhEwEii69QFNogSEYl9L94xgpwsIXCIXeL15EfsELsEJL5NPsQC0Ssr
	sekAM8S7khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYoTE38QdjPcPWB9iTAZaP5FZSjQ5Hxi/eSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqJuqvctyz5yDTcenTdy3/45Ms6egg7mNwPTpXQka
	Lw0O6DJ98K09yd//ZQ934IFlCxnzjnp8EpnLstvr6YrPfx79M/r+1HK7nBjL9SvrJ0bey+it
	kXrlu8Dh5rb3/aU/FQ7du30nsODm0/rUafIWW6tmJ+5V2p/LsTb211+r54c/xYRfmS9ktE2J
	pTgj0VCLuag4EQCJwGvN1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV0N76wgg4N/ZC22v97IZnF51xw2
	i6czN7M5MHvMun+WzePQlbWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZry6fpup4K5QxcPzU9kaGL/xdTFyckgImEg8vb2RHcIWk7hwbz0biC0kMJ1R4sSx
	lC5GLiD7D6PEqQ/9TCAJNgEtib9v3jB3MXJwiAg4SLy+Kw8SZhZQkPh1bxMrRG+ExLcXb8Hm
	cApESkx6Pg8sLizgIfHg2XdGEJtFQFXi1ZIHYHt5BWwl/v94zQhhC0r8mHyPBWKmnsTHP7cZ
	IWx5ic1r3oKtlRBQl3j0VxckLCJgJNF16gIbRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEj
	yypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Oh+Jr2DcVWDxSFGAQ5GJR7ehBmZQUKsiWXF
	lbmHGCU4mJVEeHfbZwUJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w8eSVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2NiIAtf2D4GSV0T3xqlStcJvzQ0
	jh/b8mXNursGfl57HC4l8Bx//iai4lS83sy04+FZXx/sPsRT7nm/8epfH4cFceEl/RmX2qe/
	tJvx78HVX95W2sarhTd9WlFYWCHP8S1a+ObjjT3fA+q37Hn5rXi1gfPjD5Wm3jWTj/2136GY
	v1FI9sPi+9+UWIozEg21mIuKEwHVxh4pMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,

On Fri, October 25, 2013, Ray Jui wrote:
> Under function mmc_blk_issue_rq, after an MMC discard operation,
> the MMC request data structure may be freed in memory. Later in
> the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
> is dangerous and invalid. It causes the MMC host not being released
> when it should
> 
> This patch fixes the issue by marking the special request down before
> the discard/flush operation
> 
> Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> ---
>  drivers/mmc/card/block.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 1a3163f..9e8e970 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -1954,7 +1954,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
> 
>  static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>  {
> -	int ret;
> +	int ret, req_is_special = 0;
It would be better to use boolean?

Either, in a different way, I considered to save the cmd_flags like below.
unsigned int cmd_flags = req ? req->cmd_flags : 0;

Then, we could replace several 'if statement' without dereference.
if (req && req->cmd_flags & REQ_DISCARD) -> if (cmd_flags & REQ_DISCARD)

Just my suggestion.

Thanks,
Seungwon Jeon
>  	struct mmc_blk_data *md = mq->data;
>  	struct mmc_card *card = md->queue.card;
>  	struct mmc_host *host = card->host;
> @@ -1973,6 +1973,10 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>  		goto out;
>  	}
> 
> +	/* mark special request here since req may be freed later */
> +	if (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK))
> +		req_is_special = 1;
> +
>  	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
>  	if (req && req->cmd_flags & REQ_DISCARD) {
>  		/* complete ongoing async transfer before issuing discard */
> @@ -1999,7 +2003,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> 
>  out:
>  	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
> -	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
> +	     req_is_special)
>  		/*
>  		 * Release host when there are no more requests
>  		 * and after special request(discard, flush) is done.
> --
> 1.7.9.5

