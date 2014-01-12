Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaALLil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 06:38:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaALLii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 06:38:38 -0500
Message-ID: <52D27EB4.9050909@redhat.com>
Date: Sun, 12 Jan 2014 12:38:28 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bruce Liu <damuzi000@gmail.com>
CC: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] When timestamping is enabled, stmmac_tx_clean will
 call stmmac_get_tx_hwtstamp to get tx TS. It's possible that skb is NULL
 because there are other network frames that use several descriptors. So we
 must return immediately in stmmac_get_tx_hwtstamp if skb is NULL to avoid
 system crash.
References: <1389492095-6589-1-git-send-email-damuzi000@gmail.com> <20140112093951.GA3743@gmail.com>
In-Reply-To: <20140112093951.GA3743@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 10:39 AM, Bruce Liu wrote:
>   When timestamping is enabled, stmmac_tx_clean will call stmmac_get_tx_hwtstamp to get tx TS.
>   It's possible that skb is NULL because there are other network frames that use several descriptors.
>   So we must return immediately in stmmac_get_tx_hwtstamp if skb is NULL to avoid system crash.
>
>
> Signed-off-by: Bruce Liu <damuzi000@gmail.com>

Please see Documentation/SubmittingPatches +489

You subject line is way too long and should just be something like:

[PATCH net-next] net: stmmac: fix NULL pointer dereference in stmmac_get_tx_hwtstamp

Don't indent your actual commit message with whitespaces as prefix,
and do a line break after around 70 chars.

Btw, I mentioned net-next in the subject since merge window will
open soon anyway.

> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 797b56a..47f2287 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -332,7 +332,7 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
>   		return;
>
>   	/* exit if skb doesn't support hw tstamp */
> -	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)))
> +	if (likely(!skb || !(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)))
>   		return;
>
>   	if (priv->adv_ts)
>
