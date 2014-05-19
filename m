Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaESMpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:45:09 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:57650 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaESMpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:45:06 -0400
Message-ID: <5379FCD0.2030506@cogentembedded.com>
Date: Mon, 19 May 2014 16:45:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        "John W. Linville" <linville@tuxdriver.com>
CC: kernel-janitors@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/13] libertas: make return of 0 explicit
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-05-2014 8:31, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.

> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)

> // <smpl>
> @r exists@
> local idexpression ret;
> expression e;
> position p;
> @@
>
> -ret = 0;
> ... when != ret = e
> return
> - ret
> + 0
>    ;
> // </smpl>

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> Alternatively, was an error code intended in the bad length case, as is
> done in process_brxed_802_11_packet?

>   drivers/net/wireless/libertas/rx.c |    7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)

> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index c7366b0..807c5b8 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
[...]
> @@ -154,10 +152,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>   	else
>   		netif_rx_ni(skb);
>
> -	ret = 0;
>   done:
> -	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
> -	return ret;
> +	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", 0);

    Why not just "ret 0"?

> +	return 0;

WBR, Sergei

