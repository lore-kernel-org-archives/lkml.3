Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaFAQis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 12:38:48 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:48714 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaFAQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 12:38:46 -0400
Message-ID: <538B5714.6060107@cogentembedded.com>
Date: Sun, 01 Jun 2014 20:38:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192de: phy.c:  Cleaning up
 uninitialized variables
References: <1401626948-16183-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401626948-16183-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/01/2014 04:49 PM, Rickard Strandqvist wrote:

> There is a risk that the variable will be used without being initialized.

> This was largely found by using a static code analysis program called cppcheck.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> index 3d1f0dd..66abaf6 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> @@ -203,11 +203,11 @@ u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
>   	u32 returnvalue, originalvalue, bitshift;
> -	u8 dbi_direct;
>
>   	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x)\n",
>   		 regaddr, bitmask);
>   	if (rtlhal->during_mac1init_radioa || rtlhal->during_mac0init_radiob) {
> +		u8 dbi_direct = 0;

    Empty line is needed here, after declarations, like above.

>   		/* mac1 use phy0 read radio_b. */
>   		/* mac0 use phy1 read radio_b. */
>   		if (rtlhal->during_mac1init_radioa)

WBR, Sergei

