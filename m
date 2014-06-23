Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaFWWaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:30:08 -0400
Received: from lekensteyn.nl ([178.21.112.251]:60294 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbaFWWaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:30:06 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Ben Hutchings <ben@decadent.org.uk>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv3 6/6] drivers/staging/rtl8821ae: replace magic number by macro
Date: Tue, 24 Jun 2014 00:29:54 +0200
Message-ID: <1455413.BevQxGKhmu@al>
User-Agent: KMail/4.13.2 (Linux/3.15.0-rc8-custom-00058-gd2cfd31; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1403561511-8117-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403561511-8117-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(staging drivers are handled by Greg KH, cc'ing him)

On Tuesday 24 June 2014 00:11:51 Rickard Strandqvist wrote:
> For consistency with other drivers, replace a magic number by a macro.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Reviewed-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  drivers/staging/rtl8821ae/rtl8821ae/hw.c  |    2 +-
>  drivers/staging/rtl8821ae/rtl8821ae/reg.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> index 1b8583b..1aa1661 100644
> --- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> +++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> @@ -1623,7 +1623,7 @@ static int _rtl8821ae_set_media_status(struct ieee80211_hw *hw,
>  
>  	rtl_write_byte(rtlpriv, (MSR), bt_msr);
>  	rtlpriv->cfg->ops->led_control(hw, ledaction);
> -	if ((bt_msr & ~0xfc) == MSR_AP)
> +	if ((bt_msr & MSR_MASK) == MSR_AP)
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>  	else
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
> diff --git a/drivers/staging/rtl8821ae/rtl8821ae/reg.h b/drivers/staging/rtl8821ae/rtl8821ae/reg.h
> index beffb42..4cb3ca9 100644
> --- a/drivers/staging/rtl8821ae/rtl8821ae/reg.h
> +++ b/drivers/staging/rtl8821ae/rtl8821ae/reg.h
> @@ -431,6 +431,7 @@
>  #define	MSR_ADHOC					0x01
>  #define	MSR_INFRA					0x02
>  #define	MSR_AP						0x03
> +#define	MSR_MASK					0x03
>  
>  #define	RRSR_RSC_OFFSET				21
>  #define	RRSR_SHORT_OFFSET			23
> 

