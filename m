Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaITGc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:32:27 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56971 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaITGcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:32:25 -0400
MIME-Version: 1.0
In-Reply-To: <201409200448.48180.arnd@arndb.de>
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
	<1411158165-25794-5-git-send-email-octavian.purdila@intel.com>
	<201409200448.48180.arnd@arndb.de>
Date: Sat, 20 Sep 2014 09:32:24 +0300
Message-ID: <CAE1zot+ENng7QE42UK9jahCcgNq6eLjKH4BMPX7OtAwHQLQnCg@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] gpio: add support for the Diolan DLN-2 USB GPIO driver
From: Octavian Purdila <octavian.purdila@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 5:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 19 September 2014, Octavian Purdila wrote:
>> +struct dln2_gpio_pin {
>> +     __le16 pin;
>> +} __packed;
>
> This does not need to be marked packed, since it is never embedded in another
> structure.
>

Will do.

>> +struct dln2_gpio_pin_val {
>> +     __le16 pin;
>> +     u8 value;
>> +} __packed;
>
> It's enough here to mark just the 'pin' member as packed.
>

OK.

>> +static int dln2_gpio_get_pin_count(struct platform_device *pdev)
>> +{
>> +     int ret;
>> +     __le16 count;
>> +     int len = sizeof(count);
>> +
>> +     ret = dln2_transfer(pdev, DLN2_GPIO_GET_PIN_COUNT, NULL, 0, &count,
>> +                         &len);
>
> You must not do a USB transaction on stack memory.
>

dln2_transfer allocate a new buffer (in dln2_prep_buf(), with
kmalloc()) and does the USB transfer with that buffer.
