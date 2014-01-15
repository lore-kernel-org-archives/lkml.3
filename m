Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaAOMzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:55:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55753 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaAOMzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:55:39 -0500
Message-ID: <52D684E9.6080308@ti.com>
Date: Wed, 15 Jan 2014 18:24:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 7/7] drivers/gpio: don't check resource with devm_ioremap_resource
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>	<1389700739-3696-7-git-send-email-wsa@the-dreams.de> <CACRpkdYymB4i7Ju5MMNXWVe5nB6_NbWHwrPbOK2KeT0Ji-RzQg@mail.gmail.com>
In-Reply-To: <CACRpkdYymB4i7Ju5MMNXWVe5nB6_NbWHwrPbOK2KeT0Ji-RzQg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014 02:58 PM, Linus Walleij wrote:
> On Tue, Jan 14, 2014 at 12:58 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> 
>> devm_ioremap_resource does sanity checks on the given resource. No need to
>> duplicate this in the driver.
>>
>> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>> ---
>>
>> Should go via subsystem tree
>>
>>  drivers/gpio/gpio-davinci.c | 5 -----
>>  1 file changed, 5 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
>> index 84be701..a5e1a56 100644
>> --- a/drivers/gpio/gpio-davinci.c
>> +++ b/drivers/gpio/gpio-davinci.c
>> @@ -172,11 +172,6 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>>         }
>>
>>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -       if (!res) {
>> -               dev_err(dev, "Invalid memory resource\n");
>> -               return -EBUSY;
>> -       }
>> -
>>         gpio_base = devm_ioremap_resource(dev, res);
>>         if (IS_ERR(gpio_base))
>>                 return PTR_ERR(gpio_base);
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> The DaVinci maintainers are queuing GPIO patches for their driver
> for this merge window, so requesting them to apply this patch.

I wont be sending any more pull requests for v3.14. Even if I send, the
ARM-SoC maintainers will not take it anyway. So likely this wont get
into v3.14. For v3.15, Linus should be able to queue it as dependencies
would have made it into the kernel by then.

Thanks,
Sekhar
