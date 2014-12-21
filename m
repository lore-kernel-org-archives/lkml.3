Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaLUAqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 19:46:17 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40357 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaLUAqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 19:46:14 -0500
Message-ID: <54961852.8000403@lwfinger.net>
Date: Sat, 20 Dec 2014 18:46:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chaoming Li <chaoming_li@realsil.com.cn>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8723be: phy.c:  Remove unused
 function
References: <1419116358-13223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419116358-13223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2014 04:59 PM, Rickard Strandqvist wrote:
> Remove the function rtl8723be_phy_get_txpower_level() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/net/wireless/rtlwifi/rtl8723be/phy.c |   25 -------------------------
>   drivers/net/wireless/rtlwifi/rtl8723be/phy.h |    2 --
>   2 files changed, 27 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
> index 20dcc25..b7b73cb 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
> @@ -874,31 +874,6 @@ void rtl8723be_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
>   		  ROFDM0_RXDETECTOR3, rtlphy->framesync);
>   }
>
> -void rtl8723be_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel)
> -{
> -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	struct rtl_phy *rtlphy = &rtlpriv->phy;
> -	u8 txpwr_level;
> -	long txpwr_dbm;
> -
> -	txpwr_level = rtlphy->cur_cck_txpwridx;
> -	txpwr_dbm = rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_B,
> -						 txpwr_level);
> -	txpwr_level = rtlphy->cur_ofdm24g_txpwridx;
> -	if (rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_G, txpwr_level) >
> -	    txpwr_dbm)
> -		txpwr_dbm =
> -		    rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_G,
> -						 txpwr_level);
> -	txpwr_level = rtlphy->cur_ofdm24g_txpwridx;
> -	if (rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_N_24G,
> -					 txpwr_level) > txpwr_dbm)
> -		txpwr_dbm =
> -		    rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_N_24G,
> -						 txpwr_level);
> -	*powerlevel = txpwr_dbm;
> -}
> -
>   static u8 _rtl8723be_phy_get_ratesection_intxpower_byrate(enum radio_path path,
>   							  u8 rate)
>   {
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.h b/drivers/net/wireless/rtlwifi/rtl8723be/phy.h
> index 6339738..9021d47 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8723be/phy.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/phy.h
> @@ -114,8 +114,6 @@ bool rtl8723be_phy_mac_config(struct ieee80211_hw *hw);
>   bool rtl8723be_phy_bb_config(struct ieee80211_hw *hw);
>   bool rtl8723be_phy_rf_config(struct ieee80211_hw *hw);
>   void rtl8723be_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
> -void rtl8723be_phy_get_txpower_level(struct ieee80211_hw *hw,
> -				     long *powerlevel);
>   void rtl8723be_phy_set_txpower_level(struct ieee80211_hw *hw,
>   				     u8 channel);
>   void rtl8723be_phy_scan_operation_backup(struct ieee80211_hw *hw,
>

