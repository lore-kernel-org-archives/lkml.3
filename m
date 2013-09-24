Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3IXQyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:54:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1085 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3IXQy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:54:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Sep 2013 09:54:26 -0700
Message-ID: <5241C8FF.4080708@nvidia.com>
Date: Tue, 24 Sep 2013 22:46:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [rtc-linux] [PATCH V3 2/3] pincntrl: add support for AMS AS3722
 pin control driver
References: <1380023921-29867-1-git-send-email-ldewangan@nvidia.com> <1380023921-29867-3-git-send-email-ldewangan@nvidia.com> <CACRpkda3m4ipTsS8FZoU1QDwrvwmKFn4awyfXOy2VOiuV63y6A@mail.gmail.com>
In-Reply-To: <CACRpkda3m4ipTsS8FZoU1QDwrvwmKFn4awyfXOy2VOiuV63y6A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 September 2013 06:22 PM, Linus Walleij wrote:
> On Tue, Sep 24, 2013 at 1:58 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>> +static int as_pci_to_irq(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct as3722_pctrl_info *as_pci = to_as_pci(chip);
>> +
>> +       return as3722_irq_get_virq(as_pci->as3722, offset);
>> +}
>> +
>> +static int as_pci_request(struct gpio_chip *chip, unsigned offset)
>> +{
>> +       struct as3722_pctrl_info *as_pci = to_as_pci(chip);
>> +
>> +       if (as_pci->gpio_control[offset].io_function)
>> +               return -EBUSY;
>> +       return 0;
>> +}
> Why is this not calling pinctrl_request_gpio(as_pci->chip.base + offset)
> instead of just checking if we happen to be GPIO and failing if
> we are not?
>
> I would implement .free calling pinctrl_free_gpio(gpio) as well.
>
> See e.g. pinctrl-abx500.c
>
>

Wow, cool, I saw and it is simple,  the gpios callback is wrapper over 
the pincontrol mux APIs.

I also see opportunity to re-factor the 
request/free/direction_input/direction_output to move to core so that 
need not to implement locally, the gpio_chip's callback can use directly.

Will post once this driver is accepted.
