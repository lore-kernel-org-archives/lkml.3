Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaA0PK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:10:28 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51256 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaA0PK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:10:26 -0500
MIME-Version: 1.0
In-Reply-To: <21221.47960.726835.615315@gargle.gargle.HOWL>
References: <CA+5PVA4fnCo8anT0HZCVu4+AFAseibm=0yD8nL3Lm7Q5dA-qZQ@mail.gmail.com>
	<21221.47960.726835.615315@gargle.gargle.HOWL>
Date: Mon, 27 Jan 2014 10:10:25 -0500
X-Google-Sender-Auth: DkodJq8qIUou1OX-eFKhlFisVj4
Message-ID: <CA+5PVA4A2YerXG0V6JWagAWBPBVbtn1X0Os0hhw9HCK5aeN2ZQ@mail.gmail.com>
Subject: Re: ath9k ARM build error with v3.13-8330-g4ba9920
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, ath9k-devel@venema.h4ckr.net,
        netdev <netdev@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 8:50 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> Josh Boyer wrote:
>> adds a udelay(10000) call to the ath9k driver.  This will cause a
>> build error on various ARM configs because the value passed to udelay
>> is too large:
>>
>> ERROR: "__bad_udelay" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>>
>> Is the 10000 microsecond udelay really required?  I believe the limit
>> on ARM is 2000.  Perhaps something else could be done in this case?
>
> The delay is a workaround for a HW issue. Does this patch fix the problem ?

It fixes the build error, yes.  I don't have actual HW to test, but
the driver compiles on ARM now with the same config as before.
Thanks!

josh

>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index fbf43c0..11eab9f 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1316,7 +1316,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
>         if (AR_SREV_9300_20_OR_LATER(ah))
>                 udelay(50);
>         else if (AR_SREV_9100(ah))
> -               udelay(10000);
> +               mdelay(10);
>         else
>                 udelay(100);
>
> @@ -2051,9 +2051,8 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
>
>         REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
>                     AR_RTC_FORCE_WAKE_EN);
> -
>         if (AR_SREV_9100(ah))
> -               udelay(10000);
> +               mdelay(10);
>         else
>                 udelay(50);
>
>
> Sujith
