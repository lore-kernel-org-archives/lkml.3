Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3IJOaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:30:06 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:40611 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3IJOaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:30:02 -0400
Message-ID: <522F2CE7.2070004@lwfinger.net>
Date: Tue, 10 Sep 2013 09:29:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: farisdehaan@gmail.com
CC: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu: rtw_wlan_util.c: Fixed checkpatch.pl
 warnings.
References: <522eda8b.056c0e0a.0357.656e@mx.google.com>
In-Reply-To: <522eda8b.056c0e0a.0357.656e@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 03:38 AM, farisdehaan@gmail.com wrote:
> From: Faris de Haan <farisdehaan@gmail.com>
>
> Fixed a few of the coding style issues reported by checkpatch.pl
>
> Signed-off-by: Faris de Haan <farisdehaan@gmail.com>
> ---
>   drivers/staging/rtl8188eu/core/rtw_wlan_util.c |   22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> index 013ea48..e7fd751 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> @@ -80,7 +80,7 @@ int cckratesonly_included(unsigned char *rate, int ratelen)
>   	for (i = 0; i < ratelen; i++) {
>   		if  ((((rate[i]) & 0x7f) != 2) && (((rate[i]) & 0x7f) != 4) &&
>   			   (((rate[i]) & 0x7f) != 11)  && (((rate[i]) & 0x7f) != 22))
> -		return false;
> +			return false;
>   	}
>
>   	return true;
> @@ -766,7 +766,7 @@ void HT_caps_handler(struct adapter *padapter, struct ndis_802_11_var_ie *pIE)
>
>   	for (i = 0; i < (pIE->Length); i++) {
>   		if (i != 2) {
> -			/* 	Got the endian issue here. */
> +			/*	Got the endian issue here. */
>   			pmlmeinfo->HT_caps.u.HT_cap[i] &= (pIE->data[i]);
>   		} else {
>   			/* modify from  fw by Thomas 2010/11/17 */
> @@ -1186,7 +1186,7 @@ unsigned int should_forbid_n_rate(struct adapter *padapter)
>   			case _RSN_IE_2_:
>   				if  ((_rtw_memcmp((pIE->data + 8), RSN_CIPHER_SUITE_CCMP, 4))  ||
>   				       (_rtw_memcmp((pIE->data + 12), RSN_CIPHER_SUITE_CCMP, 4)))
> -				return false;
> +					return false;
>   			default:
>   				break;
>   			}
> @@ -1368,21 +1368,21 @@ void update_tx_basic_rate(struct adapter *padapter, u8 wirelessmode)
>   #ifdef CONFIG_88EU_P2P
>   	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
>
> -	/* 	Added by Albert 2011/03/22 */
> -	/* 	In the P2P mode, the driver should not support the b mode. */
> -	/* 	So, the Tx packet shouldn't use the CCK rate */
> +	/*	Added by Albert 2011/03/22 */
> +	/*	In the P2P mode, the driver should not support the b mode. */
> +	/*	So, the Tx packet shouldn't use the CCK rate */
>   	if (!rtw_p2p_chk_state(pwdinfo, P2P_STATE_NONE))
>   		return;
>   #endif /* CONFIG_88EU_P2P */
>   	_rtw_memset(supported_rates, 0, NDIS_802_11_LENGTH_RATES_EX);
>
> -	if ((wirelessmode & WIRELESS_11B) && (wirelessmode == WIRELESS_11B)) {
> +	if ((wirelessmode & WIRELESS_11B) && (wirelessmode == WIRELESS_11B))
>   		memcpy(supported_rates, rtw_basic_rate_cck, 4);
> -	} else if (wirelessmode & WIRELESS_11B) {
> +	else if (wirelessmode & WIRELESS_11B)
>   		memcpy(supported_rates, rtw_basic_rate_mix, 7);
> -	} else {
> +	else
>   		memcpy(supported_rates, rtw_basic_rate_ofdm, 3);
> -	}
> +
>
>   	if (wirelessmode & WIRELESS_11B)
>   		update_mgnt_tx_rate(padapter, IEEE80211_CCK_RATE_1MB);
> @@ -1435,7 +1435,7 @@ unsigned char check_assoc_AP(u8 *pframe, uint len)
>   				DBG_88E("link to Airgo Cap\n");
>   				return HT_IOT_PEER_AIRGO;
>   			} else if (_rtw_memcmp(pIE->data, EPIGRAM_OUI, 3)) {
> -				 epigram_vendor_flag = 1;
> +				epigram_vendor_flag = 1;
>   				if (ralink_vendor_flag) {
>   					DBG_88E("link to Tenda W311R AP\n");
>   					 return HT_IOT_PEER_TENDA;
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

