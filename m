Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaJ1NZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:25:44 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:53011 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaJ1NZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <1414429069.8884.10.camel@perches.com>
References: <1414427472-4100-1-git-send-email-octavian.purdila@intel.com>
	<1414427472-4100-2-git-send-email-octavian.purdila@intel.com>
	<1414429069.8884.10.camel@perches.com>
Date: Tue, 28 Oct 2014 15:25:36 +0200
Message-ID: <CAMoF9u3DDPFXHKUmmPhAEXiqV3p5TaMfvQU-_HTmLO6amDxntw@mail.gmail.com>
Subject: Re: [PATCH v9 1/4] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 6:57 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-10-27 at 18:31 +0200, Octavian Purdila wrote:
>> This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
>> Master Adapter DLN-2. Details about the device can be found here:
>
> trivia:
>

Thanks for the review Joe.

>> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> []
>> +static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
>> +                       const void *obuf, unsigned obuf_len,
>> +                       void *ibuf, unsigned *ibuf_len)
>> +{
>> +     int ret = 0;
>> +     int rx_slot;
>> +     struct dln2_response *rsp;
>> +     struct dln2_rx_context *rxc;
>> +     struct device *dev = &dln2->interface->dev;
>> +     const int timeout = DLN2_USB_TIMEOUT * HZ / 1000;
>
> unsigned long timeout?
>

Ok.

> []
>
>> +     ret = wait_for_completion_interruptible_timeout(&rxc->done, timeout);
>> +     if (ret <= 0) {
>> +             if (!ret)
>> +                     ret = -ETIMEDOUT;
>> +             goto out_free_rx_slot;
>> +     }
>
> []

I think you forgot to add your comments here?

>
>> +static int dln2_print_serialno(struct dln2_dev *dln2)
>> +{
>> +     int ret;
>> +     __le32 serial_no;
>> +     int len = sizeof(serial_no);
>> +     struct device *dev = &dln2->interface->dev;
>> +
>> +     ret = _dln2_transfer(dln2, DLN2_HANDLE_CTRL, CMD_GET_DEVICE_SN, NULL, 0,
>> +                          &serial_no, &len);
>> +     if (ret < 0)
>> +             return ret;
>> +     if (len < sizeof(serial_no))
>> +             return -EREMOTEIO;
>> +
>> +     dev_info(dev, "Diolan DLN2 serial 0x%x\n", le32_to_cpu(serial_no));
>
> why a hex serial #?
>

Good point, I will switch it to decimal.
