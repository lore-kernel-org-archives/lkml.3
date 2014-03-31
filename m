Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaCaIWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:22:16 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37244 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbaCaIWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAFcVECJsEp_s2V5=oK_UJahGRUpWYWMCxTMxqdpX+O0qebP41A@mail.gmail.com>
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
	<CACRpkdbU35xG1QtagB+9e9vxvehf1UQFaF4PikJhsPNAMw=D1Q@mail.gmail.com>
	<CAFcVECJsEp_s2V5=oK_UJahGRUpWYWMCxTMxqdpX+O0qebP41A@mail.gmail.com>
Date: Mon, 31 Mar 2014 10:22:09 +0200
Message-ID: <CACRpkdZEFsJubRVwCp6nTie7s7+DZOym6SWsA2ZynN_devi-2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] GPIO: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        michals@xilinx.com, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 5:44 AM, Harini Katakam
<harinikatakamlinux@gmail.com> wrote:
> On Sat, Mar 29, 2014 at 3:20 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Thu, Mar 27, 2014 at 4:25 PM, Harini Katakam <harinik@xilinx.com> wrote:

>>> +/* Read/Write access to the GPIO PS registers */
>>> +static inline u32 zynq_gpio_readreg(void __iomem *offset)
>>> +{
>>> +       return readl_relaxed(offset);
>>> +}
>>> +
>>> +static inline void zynq_gpio_writereg(void __iomem *offset, u32 val)
>>> +{
>>> +       writel_relaxed(val, offset);
>>> +}
>>
>> I think this is unnecessary and confusing indirection.
>> Just use the readl_relaxed/writel_relaxed functions directly in
>> the code.
>>
>
> This is just to be flexible.

Define exactly what you mean with "flexible" in this context. I
only see unnecessary overhead and hard-to-read code.

>> This is also pretty convoluted. Are you sure you don't want to
>> implement one gpiochip per bank instead? I guess the final "+1"
>> means there is actually one IRQ per bank even?
>
> There is only one IRQ for all four banks.

OK I get it. Then it makes sense to have all banks registered as
one device and the IRQ tied to this one device.

>>> +static const struct dev_pm_ops zynq_gpio_dev_pm_ops = {
>>> +       SET_SYSTEM_SLEEP_PM_OPS(zynq_gpio_suspend, zynq_gpio_resume)
>>> +       SET_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend, zynq_gpio_runtime_resume,
>>> +                          zynq_gpio_idle)
>>> +};
>>
>> Is this runtime PM implementation aligned with Ulf Hansson's recent
>> new helpers to simplify suspend+runtime PM coexistance?
>>
>
> I'm sorry i just looked at them -
> pm_runtime_force_suspend/resume are not used here.

Sorry, I was more thinking of change
717e5d458e3bfca495a38dca61c64f274c049e46
"PM / Runtime: Implement the pm_generic_runtime functions for CONFIG_PM"

Yours,
Linus Walleij
