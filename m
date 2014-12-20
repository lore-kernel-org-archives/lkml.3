Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaLTSHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:07:34 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:57018 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLTSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:07:31 -0500
Message-ID: <5495BAE1.6090202@lwfinger.net>
Date: Sat, 20 Dec 2014 12:07:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chaoming Li <chaoming_li@realsil.com.cn>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192ee: trx.c:  Remove unused
 function
References: <1419079694-32476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419079694-32476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2014 06:48 AM, Rickard Strandqvist wrote:
> Remove the function rtl92ee_get_available_desc() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192ee/trx.c |   21 ---------------------
>   drivers/net/wireless/rtlwifi/rtl8192ee/trx.h |    1 -
>   2 files changed, 22 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Richard: FYI, John Linville stepped down as wireless maintainer this week, thus 
there is no need to send patches to him anymore. Kalle Valo, the new maintainer, 
has stated that it is not necessary to Cc him.

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
> index 2fcbef1..8186ed2 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
> @@ -710,27 +710,6 @@ static u16 get_desc_addr_fr_q_idx(u16 queue_index)
>   	return desc_address;
>   }
>
> -void rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 q_idx)
> -{
> -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	u16 point_diff = 0;
> -	u16 current_tx_read_point = 0, current_tx_write_point = 0;
> -	u32 tmp_4byte;
> -
> -	tmp_4byte = rtl_read_dword(rtlpriv,
> -				   get_desc_addr_fr_q_idx(q_idx));
> -	current_tx_read_point = (u16)((tmp_4byte >> 16) & 0x0fff);
> -	current_tx_write_point = (u16)((tmp_4byte) & 0x0fff);
> -
> -	point_diff = ((current_tx_read_point > current_tx_write_point) ?
> -		      (current_tx_read_point - current_tx_write_point) :
> -		      (TX_DESC_NUM_92E - current_tx_write_point +
> -		       current_tx_read_point));
> -
> -	rtlpci->tx_ring[q_idx].avl_desc = point_diff;
> -}
> -
>   void rtl92ee_pre_fill_tx_bd_desc(struct ieee80211_hw *hw,
>   				 u8 *tx_bd_desc, u8 *desc, u8 queue_index,
>   				 struct sk_buff *skb, dma_addr_t addr)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
> index 6f9be1c..4426c49 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
> @@ -829,7 +829,6 @@ void rtl92ee_rx_check_dma_ok(struct ieee80211_hw *hw, u8 *header_desc,
>   			     u8 queue_index);
>   u16	rtl92ee_rx_desc_buff_remained_cnt(struct ieee80211_hw *hw,
>   					  u8 queue_index);
> -void rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 queue_index);
>   void rtl92ee_pre_fill_tx_bd_desc(struct ieee80211_hw *hw,
>   				 u8 *tx_bd_desc, u8 *desc, u8 queue_index,
>   				 struct sk_buff *skb, dma_addr_t addr);
>

