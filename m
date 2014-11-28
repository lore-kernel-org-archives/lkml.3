Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaK1Dfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 22:35:39 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:40214 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaK1Dfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 22:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAGOxZ51P30BY2sOhUeMRK64CGF1fNcc-63RCXiAqZ6Rgpv3K7Q@mail.gmail.com>
References: <CAFp+6iF-N63YSsdv2a6=MYp_mD=eQY_Oi8=9JVNU5dG0BA7YGQ@mail.gmail.com>
	<1416834177-11170-1-git-send-email-gautam.vivek@samsung.com>
	<CAGOxZ51P30BY2sOhUeMRK64CGF1fNcc-63RCXiAqZ6Rgpv3K7Q@mail.gmail.com>
Date: Fri, 28 Nov 2014 09:05:36 +0530
Message-ID: <CAFp+6iFcMGTBQDcdK0cbcu0s9a3022nogaUvbPA2ZsCN80hRSA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: exynos: Add BUS1 pin controller for exynos7
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Alim Akhtar <alim.akhtar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "robh+dt" <robh+dt@kernel.org>, kgene <kgene@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alim,


On Wed, Nov 26, 2014 at 7:03 PM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
> Hi Vivek,
>
> On Mon, Nov 24, 2014 at 6:32 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> USB and Power regulator on Exynos7 require gpios available
>> in BUS1 pin controller block.
>> So adding the BUS1 pinctrl support.
>>
>> Signed-off-by: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> ---
> Looks good to me.
> Thanks!
>
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks for the review.

>
>>
>> This patch was part of series:
>> "[PATCH 00/11] Exynos7: Adding USB 3.0 support"
>>  https://lkml.org/lkml/2014/11/21/247
>>
>> Changes since V1:
>>  - Added support for all pin banks which are part of BUS1 pin controller.
>>
>>  drivers/pinctrl/samsung/pinctrl-exynos.c |   19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
>> index d5d4cfc..44e60dc 100644
>> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
>> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
>> @@ -1300,6 +1300,20 @@ static const struct samsung_pin_bank_data exynos7_pin_banks7[] __initconst = {
>>         EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr3", 0x0c),
>>  };
>>
>> +/* pin banks of exynos7 pin-controller - BUS1 */
>> +static const struct samsung_pin_bank_data exynos7_pin_banks8[] __initconst = {
>> +       EXYNOS_PIN_BANK_EINTG(8, 0x020, "gpf0", 0x00),
>> +       EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpf1", 0x04),
>> +       EXYNOS_PIN_BANK_EINTG(4, 0x060, "gpf2", 0x08),
>> +       EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpf3", 0x0c),
>> +       EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpf4", 0x10),
>> +       EXYNOS_PIN_BANK_EINTG(8, 0x0c0, "gpf5", 0x14),
>> +       EXYNOS_PIN_BANK_EINTG(5, 0x0e0, "gpg1", 0x18),
>> +       EXYNOS_PIN_BANK_EINTG(5, 0x100, "gpg2", 0x1c),
>> +       EXYNOS_PIN_BANK_EINTG(6, 0x120, "gph1", 0x20),
>> +       EXYNOS_PIN_BANK_EINTG(3, 0x140, "gpv6", 0x24),
>> +};
>> +
>>  const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
>>         {
>>                 /* pin-controller instance 0 Alive data */
>> @@ -1342,5 +1356,10 @@ const struct samsung_pin_ctrl exynos7_pin_ctrl[] __initconst = {
>>                 .pin_banks      = exynos7_pin_banks7,
>>                 .nr_banks       = ARRAY_SIZE(exynos7_pin_banks7),
>>                 .eint_gpio_init = exynos_eint_gpio_init,
>> +       }, {
>> +               /* pin-controller instance 8 BUS1 data */
>> +               .pin_banks      = exynos7_pin_banks8,
>> +               .nr_banks       = ARRAY_SIZE(exynos7_pin_banks8),
>> +               .eint_gpio_init = exynos_eint_gpio_init,
>>         },
>>  };
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Regards,
> Alim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
