Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3JRW1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:27:41 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35008 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab3JRW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:27:39 -0400
Message-ID: <5261B5D6.2020002@lwfinger.net>
Date: Fri, 18 Oct 2013 17:27:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Felipe Pena <felipensp@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: net: wireless: rtlwifi: Fix wrong assignment
References: <1382134538-3719-1-git-send-email-felipensp@gmail.com>
In-Reply-To: <1382134538-3719-1-git-send-email-felipensp@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 05:15 PM, Felipe Pena wrote:
> There is a typo in the struct member name on assignment when checking
> rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40, the check uses pwrgroup_ht40
> for bound limit and uses pwrgroup_ht20 when assigning instead.
>
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192se/rf.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
> index 5061f1d..92d38ab 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
> @@ -265,7 +265,7 @@ static void _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
>   				    rtlefuse->pwrgroup_ht40
>   				    [RF90_PATH_A][chnl - 1]) {
>   					pwrdiff_limit[i] =
> -					  rtlefuse->pwrgroup_ht20
> +					  rtlefuse->pwrgroup_ht40
>   					  [RF90_PATH_A][chnl - 1];
>   				}
>   			} else {

Good catch. There is only one problem - by convention we skip 
drivers/net/wireless in the subject. That would probably be OK, but you are 
missing the rtl8192se part, which needs to be there. I suggest that you use the 
subject "rtlwifi: rtl8192de: Fix wrong assignment".

Larry


