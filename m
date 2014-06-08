Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaFHUrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:47:42 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:57752 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaFHUrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:47:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1406081333550.19183@chino.kir.corp.google.com>
References: <1402191743-26177-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<alpine.DEB.2.02.1406081333550.19183@chino.kir.corp.google.com>
Date: Sun, 8 Jun 2014 22:47:31 +0200
Message-ID: <CAFo99gZtZWEwgNoMzxOS-S_XG+p83_T3GypMdcDyhswe2-r3MA@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8723be: hw.c: Cleaning up if
 statement that always evaluates to false
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Rientjes <rientjes@google.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Joe Perches <joe@perches.com>, Peter Wu <lekensteyn@gmail.com>,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Quite right!
I found this error in some of the files. And after discussion with
Larry Finger and Peter Wu, it was decided that all files with this if
statement should change.

But of course I should update the comment to something more suitable.


Kind regards
Rickard Strandqvist


2014-06-08 22:35 GMT+02:00 David Rientjes <rientjes@google.com>:
> On Sun, 8 Jun 2014, Rickard Strandqvist wrote:
>
>> I find a logical error in an if statement '(X & 0xfc) == 0x3' is always false
>>
>
> Where is the 0xfc that your converting?
>
>> After pointing this out, Larry Finger informed what would be the correct one.
>> '(X & 0x3) == 0x3'
>>
>
> This is already what it is, just say that you're replacing it with the
> constant.
>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/net/wireless/rtlwifi/rtl8723be/hw.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> index 0fdf090..b61044f 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
>> @@ -1197,7 +1197,7 @@ static int _rtl8723be_set_media_status(struct ieee80211_hw *hw,
>>       }
>>       rtl_write_byte(rtlpriv, (MSR), bt_msr);
>>       rtlpriv->cfg->ops->led_control(hw, ledaction);
>> -     if ((bt_msr & 0x03) == MSR_AP)
>> +     if ((bt_msr & MSR_AP) == MSR_AP)
>>               rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>>       else
>>               rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
