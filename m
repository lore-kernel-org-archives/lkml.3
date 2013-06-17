Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab3FQJz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:55:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3FQJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:55:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        "Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [68/83] ath9k: Disable PowerSave by default
References: <lsq.1371420098.113375664@decadent.org.uk>
Date: Mon, 17 Jun 2013 10:55:22 +0100
In-Reply-To: <lsq.1371420098.113375664@decadent.org.uk> (Ben Hutchings's
	message of "Sun, 16 Jun 2013 23:01:38 +0100")
Message-ID: <87fvwhrrhx.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> 3.2.47-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> commit 73c79617596b89a3693ff0d89d42bcd5ddedcf15 upstream.

This SHA1 seems to be wrong, you probably meant
531671cb17af07281e6f28c1425f754346e65c41.

Cheers,
-- 
Luis

>
> Almost all the DMA issues which have plagued ath9k (in station mode)
> for years are related to PS. Disabling PS usually "fixes" the user's
> connection stablility. Reports of DMA problems are still trickling in
> and are sitting in the kernel bugzilla. Until the PS code in ath9k is
> given a thorough review, disbale it by default. The slight increase
> in chip power consumption is a small price to pay for improved link
> stability.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -691,8 +691,7 @@ void ath9k_set_hw_capab(struct ath_softc
>  		BIT(NL80211_IFTYPE_ADHOC) |
>  		BIT(NL80211_IFTYPE_MESH_POINT);
>  
> -	if (AR_SREV_5416(sc->sc_ah))
> -		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>  
>  	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
