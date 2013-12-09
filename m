Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775Ab3LIISh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:18:37 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37212 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3LIISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <52A24E08.706@codeaurora.org>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com>
	<52A24E08.706@codeaurora.org>
Date: Mon, 9 Dec 2013 09:18:33 +0100
Message-ID: <CACRpkdb+9DE6WNfBSp9Y8ErhHjaE-PdezJbYvsLLhiCjXfmA-A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 11:22 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 12/05/13 18:10, Bjorn Andersson wrote:

As the driver is merged I expect fixes to come in as additional patches.

>> Add initial definition of parameters for pinctrl-msm for the msm8x74
>> platform.
>
> Hmm. We've tried to remove 'x' from our code because it isn't really
> accurate and leads to more confusion.

So does this pin controller have a real name in the data sheet?

I usually prefer to name the drivers after the name of the IP
block rather than the SoC if possible.

Or should it just be named pinctrl-msm.c?

>> +#define PINGROUP(id, f1, f2, f3, f4, f5, f6, f7)     \
>> +     {                                               \
>> +             .name = "gpio" #id,                     \
>> +             .pins = gpio##id##_pins,                \
>> +             .npins = ARRAY_SIZE(gpio##id##_pins),   \
>> +             .funcs = {                              \
>> +                     MSM_MUX_NA, /* gpio mode */     \
>> +                     MSM_MUX_##f1,                   \
>> +                     MSM_MUX_##f2,                   \
>> +                     MSM_MUX_##f3,                   \
>> +                     MSM_MUX_##f4,                   \
>> +                     MSM_MUX_##f5,                   \
>> +                     MSM_MUX_##f6,                   \
>> +                     MSM_MUX_##f7                    \
>> +             },                                      \
>> +             .ctl_reg = 0x1000 + 0x10 * id ,         \
>
> Weird trailing space here.

Please send patches.

> Also, do we ever plan to have anything more than the gpio pins and the
> sdc pins? It seems like we spend a lot of space describing exactly the
> same thing in these structs for each of the 146 gpio pins when we could
> just know that range 0 to 146 is gpio pins and have different code for
> that part vs the 6 or something sd pins.

Some platforms use the .gpio_request_enable()/.gpio_disable_free()
instead of one group per pin for this very reason.

>> +static struct of_device_id msm8x74_pinctrl_of_match[] = {
>
> const?

Please send patches.

>> +static int __init msm8x74_pinctrl_init(void)
>> +{
>> +     return platform_driver_register(&msm8x74_pinctrl_driver);
>> +}
>> +arch_initcall(msm8x74_pinctrl_init);
>> +
>> +static void __exit msm8x74_pinctrl_exit(void)
>> +{
>> +     platform_driver_unregister(&msm8x74_pinctrl_driver);
>> +}
>> +module_exit(msm8x74_pinctrl_exit);
>
> Why not module_platform_driver()? I thought pinctrl supported deferred
> probing?

It does. Tested patches accepted.

Yours,
Linus Walleij
