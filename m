Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaJIH7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:59:35 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:48805 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIH7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:59:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACdXCX7PqUHRKJ0KipmYzRF54XRmMYYArr5iof36VskJ75PaKg@mail.gmail.com>
References: <1412606822-3406-1-git-send-email-muth@cypress.com>
 <CAAVeFu+vBZ49ciZT+-dnKXks201_psy_NtYsTjw0ptOkx2es7Q@mail.gmail.com>
 <405b439b16ea40078718da326343f673@BN1PR06MB069.namprd06.prod.outlook.com>
 <CAAVeFu+X0Lk=5sNm9kOwGX=2-DYN_-5v-7M9bAWXraffKsTkMg@mail.gmail.com> <CACdXCX7PqUHRKJ0KipmYzRF54XRmMYYArr5iof36VskJ75PaKg@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 9 Oct 2014 16:59:04 +0900
Message-ID: <CAAVeFuLOwcS-p+zHmLoAaxZz8XFyniuYjj76XMWZpezgkD=WQw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
To: RR <rajaram.officemails@gmail.com>
Cc: Muthu Mani <muth@cypress.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
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

On Thu, Oct 9, 2014 at 8:46 AM, RR <rajaram.officemails@gmail.com> wrote:
> On Wed, Oct 8, 2014 at 12:18 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
>> On Wed, Oct 8, 2014 at 4:09 PM, Muthu Mani <muth@cypress.com> wrote:
>>>> -----Original Message-----
>>>> From: Alexandre Courbot [mailto:gnurou@gmail.com]
>>>> Sent: Tuesday, October 07, 2014 3:34 PM
>>>> To: Muthu Mani
>>>> Cc: Samuel Ortiz; Lee Jones; Wolfram Sang; Linus Walleij; Greg Kroah-
>>>> Hartman; linux-i2c@vger.kernel.org; linux-gpio@vger.kernel.org; linux-
>>>> usb@vger.kernel.org; Linux Kernel Mailing List; Rajaram Regupathy; Johan
>>>> Hovold
>>>> Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-
>>>> GPIO adapter
>>>>
>>>> On Mon, Oct 6, 2014 at 11:47 PM, Muthu Mani <muth@cypress.com> wrote:
>>>> > +
>>>> > +static int cy_gpio_direction_input(struct gpio_chip *chip,
>>>> > +                                       unsigned offset) {
>>>> > +       return 0;
>>>> > +}
>>>> > +
>>>> > +static int cy_gpio_direction_output(struct gpio_chip *chip,
>>>> > +                                       unsigned offset, int value) {
>>>> > +       return 0;
>>>> > +}
>>>>
>>>> If that chip is capable of both output and input, shouldn't these functions be
>>>> implemented? I think this has already been pointed out in a previous version
>>>> but you did not reply.
>>>
>>> Thanks for your inputs.
>>>
>>> Only the GPIOs which are configured to be output GPIO can be set.
>>
>> In that case cy_gpio_set() should return an error for GPIOs which are
>> not configured as outputs. Is that guaranteed by the current
>> implementation?
>>
>>> The set operation would fail trying to set the input or unconfigured GPIOs.
>>> In this version of driver, this support is not added, it can be introduced in future versions.
>>> I will add a TODO note in the code.
>>
>> Argh, no TODO please. Actual code that will turn this code into a
>> solid driver that can be merged.
>
> Does a driver targeted for a custom device has to implement every
> functionality in the 1st version ? My understanding is that Linux
> follows incremental model and allows incremental merge.

Certainly, but we are talking about very basic functionality here.

Right now this driver will incorrectly returns success when trying to
set the direction of a GPIO, even though it did not do anything. There
is also no hint that _set will return an error if called on an
input/unconfigured GPIO.

So while we are not asking for a driver to be perfect on the first
iteration, setting the direction of a GPIO is a very basic
functionality that is essential for a GPIO driver to just work. Custom
device or not, this is mainline. The rest of the driver seems to be
ok, so please take the last few steps that will allow us to merge a
featured driver.
