Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaFHUhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:37:55 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36388 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaFHUhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:37:46 -0400
Date: Sun, 8 Jun 2014 13:37:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Levente Kurusa <levex@linux.com>,
        Masanari Iida <standby24x7@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8821ae: rtl8821ae: hw.c:  Cleaning up if
 statement that always evaluates to false
In-Reply-To: <1402191812-26264-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.DEB.2.02.1406081336080.19183@chino.kir.corp.google.com>
References: <1402191812-26264-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2014, Rickard Strandqvist wrote:

> I find a logical error in an if statement '(X & 0xfc) == 0x3' is always false
> 

The test you're changing is '(X & ~0xfc) == 0x3' which is not always 
false, so is (bt_msr & MSR_AP) == MSR_AP or (bt_msr & ~MSR_AP) == MSR_AP 
correct?  Either way, your changelog makes no sense in combination with 
your patch.

> After pointing this out, Larry Finger informed what would be the correct one.
> '(X & 0x3) == 0x3'
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8821ae/rtl8821ae/hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> index 1b8583b..52322e3 100644
> --- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> +++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
> @@ -1623,7 +1623,7 @@ static int _rtl8821ae_set_media_status(struct ieee80211_hw *hw,
>  
>  	rtl_write_byte(rtlpriv, (MSR), bt_msr);
>  	rtlpriv->cfg->ops->led_control(hw, ledaction);
> -	if ((bt_msr & ~0xfc) == MSR_AP)
> +	if ((bt_msr & MSR_AP) == MSR_AP)
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>  	else
>  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
