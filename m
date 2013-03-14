Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3CNL6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:58:19 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:53366 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab3CNL6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:58:16 -0400
Message-ID: <5141BB52.6080604@slimlogic.co.uk>
Date: Thu, 14 Mar 2013 11:58:10 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: Re: [PATCH v8 07/12] gpio: palmas: add in GPIO support for palmas
 charger
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk> <1362662276-20792-7-git-send-email-ian@slimlogic.co.uk> <CACRpkdaNs+NmAbuwRYzn1xgjHy=7ZknJa-GD1+Q8HBsu53KQqQ@mail.gmail.com>
In-Reply-To: <CACRpkdaNs+NmAbuwRYzn1xgjHy=7ZknJa-GD1+Q8HBsu53KQqQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/13 14:15, Linus Walleij wrote:
> Sorry for slow replies :-(
>
> On Thu, Mar 7, 2013 at 2:17 PM, Ian Lartey <ian@slimlogic.co.uk> wrote:
>
>> +static int palmas_gpio_read(struct palmas *palmas, unsigned int reg,
>> +               int gpio, unsigned int *dest)
>
> I don't like "int gpio" here, please use "int offset".
>
> This is not a global GPIO number, it is an offset in the local gpio_chip,
> right?

Correct.
>
>> +{
>> +       /* registers for second bank are identical and offset by 0x9 */
>> +       if (gpio > 7)
>> +               reg += PALMAS_GPIO_DATA_IN2;
>> +
>> +       return palmas_read(palmas, PALMAS_GPIO_BASE, reg, dest);
>> +}
>> +
>> +static int palmas_gpio_write(struct palmas *palmas, unsigned int reg,
>> +               int gpio, unsigned int data)
>> +{
>> +       /* registers for second bank are identical and offset by 0x9 */
>> +       if (gpio > 7)
>> +               reg += PALMAS_GPIO_DATA_IN2;
>> +
>> +       return palmas_write(palmas, PALMAS_GPIO_BASE, reg, data);
>> +}
>> +
>> +static int palmas_gpio_update_bits(struct palmas *palmas, unsigned int reg,
>> +               int gpio, unsigned int mask, unsigned int data)
>> +{
>> +       /* registers for second bank are identical and offset by 0x9 */
>> +       if (gpio > 7)
>> +               reg += PALMAS_GPIO_DATA_IN2;
>> +
>> +       return palmas_update_bits(palmas, PALMAS_GPIO_BASE, reg, mask, data);
>> +}
>
>
>> -       ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_IN, &val);
>> +       ret = palmas_gpio_read(palmas, PALMAS_GPIO_DATA_IN, offset, &val);
>
> (Obviously you are passing the offset.)
>
>> +               ret = palmas_gpio_write(palmas, PALMAS_GPIO_SET_DATA_OUT,
>> +                               offset, BIT(offset % 8));
> (..)
>> +               ret = palmas_gpio_write(palmas, PALMAS_GPIO_CLEAR_DATA_OUT,
>> +                               offset, BIT(offset % 8));
> (...)
>> +       ret = palmas_gpio_update_bits(palmas, PALMAS_GPIO_DATA_DIR,
>> +                       offset, 1 << (offset % 8), 1 << (offset % 8));
>
> Why aren't you using the BIT() macro here too?
>
> Further: if these functions are always used like this, with offset
> and some BIT() or (1 << (offset % 8)) why don't you move that
> latter part into the static helper and just pass offset into the
> helper?
>

Good points  - I missed the other bit shifts.


> Yours,
> Linus Walleij


Thanks

Ian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

