Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbaBFUjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:39:35 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42588 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaBFUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:39:33 -0500
Message-ID: <52F3F302.1040703@lwfinger.net>
Date: Thu, 06 Feb 2014 14:39:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>, linville@tuxdriver.com,
        chaoming_li@realsil.com.cn
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] rtlwifi: Fix incorrect return from rtl_ps_enable_nic()
References: <1391235070-23180-1-git-send-email-olivier@trillion01.com> <1391235070-23180-2-git-send-email-olivier@trillion01.com>
In-Reply-To: <1391235070-23180-2-git-send-email-olivier@trillion01.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 12:11 AM, Olivier Langlois wrote:
> rtl_ps_enable_nic() is called from loops that will loop until this function returns true or a
> maximum number of retries is performed.
>
> hw_init() returns non-zero on error. In that situation return false to
> restore the original design intent to retry hw init when it fails.
>
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> Cc: Stable <stable@vger.kernel.org>

Acked-by: Larry Finger <Larry.Finger.net>

Larry

> ---
>   drivers/net/wireless/rtlwifi/ps.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
> index 0d81f76..a56e9b3 100644
> --- a/drivers/net/wireless/rtlwifi/ps.c
> +++ b/drivers/net/wireless/rtlwifi/ps.c
> @@ -48,7 +48,7 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
>
>   	/*<2> Enable Adapter */
>   	if (rtlpriv->cfg->ops->hw_init(hw))
> -		return 1;
> +		return false;
>   	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
>
>   	/*<3> Enable Interrupt */
>

