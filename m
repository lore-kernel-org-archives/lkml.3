Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3KVMKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:10:37 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3KVMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:10:36 -0500
Date: Fri, 22 Nov 2013 07:10:30 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Chang Xiangzhong <changxiangzhong@gmail.com>
Cc: vyasevich@gmail.com, davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sctp: set chunk->tsn_gap_acked at the end of cycle
Message-ID: <20131122121030.GB27391@hmsreliant.think-freely.org>
References: <1385106589-402-1-git-send-email-changxiangzhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385106589-402-1-git-send-email-changxiangzhong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 08:49:49AM +0100, Chang Xiangzhong wrote:
> tsn_gap_acked is an important state flag in chunk, which indicates if the
> chunk has been acked in gap reports before. SFR-CACC algorithm depends on this
> variable. So set this at the end of each iteration, otherwise the SFR-CACC
> algorithm would never be toggled.
> 
> Signed-off-by: Chang Xiangzhong <changxiangzhong@gmail.com>
> ---
>  net/sctp/outqueue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 1b494fa..bff828c 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -1396,7 +1396,6 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  			 * while DATA was outstanding).
>  			 */
>  			if (!tchunk->tsn_gap_acked) {
> -				tchunk->tsn_gap_acked = 1;
>  				if (TSN_lt(*highest_new_tsn_in_sack, tsn))
>  					*highest_new_tsn_in_sack = tsn;
>  				bytes_acked += sctp_data_size(tchunk);
> @@ -1460,6 +1459,8 @@ static void sctp_check_transmitted(struct sctp_outq *q,
>  				 */
>  				list_add_tail(lchunk, &tlist);
>  			}
> +
> +			tchunk->tsn_gap_acked = 1;
>  		} else {
>  			if (tchunk->tsn_gap_acked) {
>  				pr_debug("%s: receiver reneged on data TSN:0x%x\n",
> -- 
> 1.8.4.3
> 
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
