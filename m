Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaJ2CVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:21:10 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41930 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaJ2CVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbe6OC-4CZ_DiUBcuv9wsMVtvk1FpkdNn5pZG+sgP6wZQ@mail.gmail.com>
References: <1412606822-3406-1-git-send-email-muth@cypress.com>
	<CAAVeFu+vBZ49ciZT+-dnKXks201_psy_NtYsTjw0ptOkx2es7Q@mail.gmail.com>
	<405b439b16ea40078718da326343f673@BN1PR06MB069.namprd06.prod.outlook.com>
	<CAAVeFu+X0Lk=5sNm9kOwGX=2-DYN_-5v-7M9bAWXraffKsTkMg@mail.gmail.com>
	<CACdXCX7PqUHRKJ0KipmYzRF54XRmMYYArr5iof36VskJ75PaKg@mail.gmail.com>
	<CACRpkdbe6OC-4CZ_DiUBcuv9wsMVtvk1FpkdNn5pZG+sgP6wZQ@mail.gmail.com>
Date: Wed, 29 Oct 2014 07:51:06 +0530
Message-ID: <CACdXCX4z=AbL6-O3Y76ZtLwyZ1F82_N4y60VmBKXnzf3KXvOzg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
From: RR <rajaram.officemails@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Muthu Mani <muth@cypress.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
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

On Mon, Oct 27, 2014 at 9:00 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Oct 9, 2014 at 1:46 AM, RR <rajaram.officemails@gmail.com> wrote:
>> On Wed, Oct 8, 2014 at 12:18 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
>>> On Wed, Oct 8, 2014 at 4:09 PM, Muthu Mani <muth@cypress.com> wrote:
>
>>>>> > +static int cy_gpio_direction_output(struct gpio_chip *chip,
>>>>> > +                                       unsigned offset, int value) {
>>>>> > +       return 0;
>>>>> > +}
>>>>>
>>>>> If that chip is capable of both output and input, shouldn't these functions be
>>>>> implemented? I think this has already been pointed out in a previous version
>>>>> but you did not reply.
>>>>
>>>> Thanks for your inputs.
>>>>
>>>> Only the GPIOs which are configured to be output GPIO can be set.
>>>
>>> In that case cy_gpio_set() should return an error for GPIOs which are
>>> not configured as outputs. Is that guaranteed by the current
>>> implementation?
>>>
>>>> The set operation would fail trying to set the input or unconfigured GPIOs.
>>>> In this version of driver, this support is not added, it can be introduced in future versions.
>>>> I will add a TODO note in the code.
>>>
>>> Argh, no TODO please. Actual code that will turn this code into a
>>> solid driver that can be merged.
>>
>> Does a driver targeted for a custom device has to implement every
>> functionality in the 1st version ?
>
> When you post a driver to the GPIO maintainers it is *NOT* tageted
> at a consumer device, it is targeted at the kernel community and
> upstream maintainers.

Totally agree. What I was conveying the patch has not modified
any "core" kernel function and is specific to a device thus will not
affect system.

>
> Of course you can deliver add-on patches out-of-tree to your
> customers, it's generally a bad idea for the long term and maintenance
> of your driver, but it's your pick.

AFAIR In the recent past xHCI or gadget core or musb or dw3
patches were added in increments. May be my analogy is incorrect and
I am ignorant of some philosophy here.

Sincerely I somehow was not convinced basic functionality is missing
as referred in the review comment.We have tested the driver for most of
the functionality of our DVK and is working perfectly.

Moreover currently we do not expect an user to set gpio direction as
it involves vendor specific usb control commands.

Having said that we have taken the feedback and working to close this.

>
> Yours,
> Linus Walleij
