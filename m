Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaFNN2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:28:53 -0400
Received: from lekensteyn.nl ([178.21.112.251]:42427 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbaFNN2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:28:52 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: wireless: rtlwifi: rtl8188ee: hw.c:  Cleaning up if statement that always evaluates to false
Date: Sat, 14 Jun 2014 15:28:37 +0200
Message-ID: <2259587.sBdtJmoxcK@al>
User-Agent: KMail/4.13.1 (Linux/3.15.0-rc8-custom-00058-gd2cfd31; KDE/4.13.1; x86_64; ; )
In-Reply-To: <1402752272-13696-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402752272-13696-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <1402752272-13696-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 June 2014 15:24:32 Rickard Strandqvist wrote:
> I found a logical error in an if statement that always evaluates to false.
> 
> This has after same discussion resulted in that we add a macro to handle this.

This commit message is useless. If you really need to refer to a mailing
list thread, use something like:

Link: http://lkml.kernel.org/r/MESSAGE_ID_HERE

... but it would even be better if you *explain* why the previous behavior
is wrong, and what this patch does in an attempt to fix that.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/net/wireless/rtlwifi/rtl8188ee/hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> index 94cd9df..9bdac68 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> @@ -1231,7 +1231,7 @@ static int _rtl88ee_set_media_status(struct ieee80211_hw *hw,
>  
>  	rtl_write_byte(rtlpriv, (MSR), bt_msr);
>  	rtlpriv->cfg->ops->led_control(hw, ledaction);
> -	if ((bt_msr & 0xfc) == MSR_AP)
> +	if ((bt_msr & MSR_MASK) == MSR_AP)

There is no such constant as MSR_MASK. Please compile test before sending.

>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>  	else
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
> 

Kind regards,
Peter

