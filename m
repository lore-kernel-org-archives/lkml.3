Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaEOSd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:33:58 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:56885 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaEOSdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:33:50 -0400
Message-ID: <5375088D.1090009@candelatech.com>
Date: Thu, 15 May 2014 11:33:49 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:  fix rssi reporting.
References: <1400178663-25661-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1400178663-25661-1-git-send-email-greearb@candelatech.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, ...this and previous patch should not have gone to LKML.

Will send it over to ath10k list where it was supposed to go.

Thanks,
Ben

On 05/15/2014 11:31 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When the driver cannot provide proper rssi, mark
> status with RX_FLAG_NO_SIGNAL_VAL so that stack
> properly ignores it.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> Patch is against my tree, hopefully will apply OK against upstream
> but have not tested that yet.
> 
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 0c83ffb..d8ec8dd 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -1216,11 +1216,12 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>  	mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
>  
>  	/* Fill this once, while this is per-ppdu */
> -	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID) {
> -		memset(rx_status, 0, sizeof(*rx_status));
> +	memset(rx_status, 0, sizeof(*rx_status));
> +	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID)
>  		rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR +
>  				     rx->ppdu.combined_rssi;
> -	}
> +	else
> +		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
>  
>  	if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
>  		/* TSF available only in 32-bit */
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

