Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaJHHS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:18:59 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:62655 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaJHHS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <405b439b16ea40078718da326343f673@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1412606822-3406-1-git-send-email-muth@cypress.com>
 <CAAVeFu+vBZ49ciZT+-dnKXks201_psy_NtYsTjw0ptOkx2es7Q@mail.gmail.com> <405b439b16ea40078718da326343f673@BN1PR06MB069.namprd06.prod.outlook.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 8 Oct 2014 16:18:36 +0900
Message-ID: <CAAVeFu+X0Lk=5sNm9kOwGX=2-DYN_-5v-7M9bAWXraffKsTkMg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>, Johan Hovold <johan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 4:09 PM, Muthu Mani <muth@cypress.com> wrote:
>> -----Original Message-----
>> From: Alexandre Courbot [mailto:gnurou@gmail.com]
>> Sent: Tuesday, October 07, 2014 3:34 PM
>> To: Muthu Mani
>> Cc: Samuel Ortiz; Lee Jones; Wolfram Sang; Linus Walleij; Greg Kroah-
>> Hartman; linux-i2c@vger.kernel.org; linux-gpio@vger.kernel.org; linux-
>> usb@vger.kernel.org; Linux Kernel Mailing List; Rajaram Regupathy; Johan
>> Hovold
>> Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-
>> GPIO adapter
>>
>> On Mon, Oct 6, 2014 at 11:47 PM, Muthu Mani <muth@cypress.com> wrote:
>> > +
>> > +static int cy_gpio_direction_input(struct gpio_chip *chip,
>> > +                                       unsigned offset) {
>> > +       return 0;
>> > +}
>> > +
>> > +static int cy_gpio_direction_output(struct gpio_chip *chip,
>> > +                                       unsigned offset, int value) {
>> > +       return 0;
>> > +}
>>
>> If that chip is capable of both output and input, shouldn't these functions be
>> implemented? I think this has already been pointed out in a previous version
>> but you did not reply.
>
> Thanks for your inputs.
>
> Only the GPIOs which are configured to be output GPIO can be set.

In that case cy_gpio_set() should return an error for GPIOs which are
not configured as outputs. Is that guaranteed by the current
implementation?

> The set operation would fail trying to set the input or unconfigured GPIOs.
> In this version of driver, this support is not added, it can be introduced in future versions.
> I will add a TODO note in the code.

Argh, no TODO please. Actual code that will turn this code into a
solid driver that can be merged.

Can all GPIOs be set as input or output? If so, please implement
cy_gpio_direction_*() and make sure that cy_gpio_set() behaves
properly if a GPIO is not an output. If the input/output GPIOs are
fixed, please make cy_gpio_direction_*() return an error if the GPIO
capabilities does not correspond to what is asked, and again ensure
that cy_gpio_set() works as expected.
