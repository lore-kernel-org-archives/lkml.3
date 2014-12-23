Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaLWA2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 19:28:33 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45047 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaLWA2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 19:28:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAEUmHyYbPbeWzHEaPYFAV+wTGYqhz7pps6XEzNrK_jQm_HPKpg@mail.gmail.com>
References: <1419286616-9893-1-git-send-email-wsa@the-dreams.de>
	<1419286616-9893-3-git-send-email-wsa@the-dreams.de>
	<CAEUmHyYbPbeWzHEaPYFAV+wTGYqhz7pps6XEzNrK_jQm_HPKpg@mail.gmail.com>
Date: Tue, 23 Dec 2014 05:58:29 +0530
Message-ID: <CAEUmHyaSo+rtfobH8jHidcX1e=5fRiCxHKDF=sEEKXPDcD7WeQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: ieee802154: don't use devm_pinctrl_get_select_default()
 in probe
From: Varka Bhadram <varkabhadram@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.

Acked-by: Varka Bhadram <varkabhadram@gmail.com>

On Tue, Dec 23, 2014 at 5:40 AM, Varka Bhadram <varkabhadram@gmail.com> wrote:
>
> Thanks for the patch.
>
> Acked-by: Varka Bhadram <varkabhadram@gmail.com>
>
> On Tue, Dec 23, 2014 at 3:46 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>>
>> Since commit ab78029ecc34 (drivers/pinctrl: grab default handles from device
>> core), we can rely on device core for setting the default pins.
>>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> ---
>>  drivers/net/ieee802154/cc2520.c | 7 -------
>>  1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
>> index c2b7da3da183..033473448d9f 100644
>> --- a/drivers/net/ieee802154/cc2520.c
>> +++ b/drivers/net/ieee802154/cc2520.c
>> @@ -19,7 +19,6 @@
>>  #include <linux/workqueue.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/skbuff.h>
>> -#include <linux/pinctrl/consumer.h>
>>  #include <linux/of_gpio.h>
>>  #include <linux/ieee802154.h>
>>
>> @@ -841,7 +840,6 @@ done:
>>  static int cc2520_probe(struct spi_device *spi)
>>  {
>>         struct cc2520_private *priv;
>> -       struct pinctrl *pinctrl;
>>         struct cc2520_platform_data *pdata;
>>         int ret;
>>
>> @@ -854,11 +852,6 @@ static int cc2520_probe(struct spi_device *spi)
>>
>>         spi_set_drvdata(spi, priv);
>>
>> -       pinctrl = devm_pinctrl_get_select_default(&spi->dev);
>> -       if (IS_ERR(pinctrl))
>> -               dev_warn(&spi->dev,
>> -                        "pinctrl pins are not configured\n");
>> -
>>         pdata = cc2520_get_platform_data(spi);
>>         if (!pdata) {
>>                 dev_err(&spi->dev, "no platform data\n");
>> --
>> 2.1.3
>>
>
>
>
> --
> Thanks and Regards,
> Varka Bhadram.




-- 
Thanks and Regards,
Varka Bhadram.
