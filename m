Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3EHOkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:40:31 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47957 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3EHOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:40:28 -0400
MIME-Version: 1.0
X-Originating-IP: [111.255.126.240]
In-Reply-To: <518A1232.1020605@metafoo.de>
References: <1368002183.31837.2.camel@phoenix>
	<518A1232.1020605@metafoo.de>
Date: Wed, 8 May 2013 22:40:26 +0800
Message-ID: <CAFRkauCpcT5eWX6z6ywVZP0RX9M4irbpbxvXbmR0XW+JFBz7qw@mail.gmail.com>
Subject: Re: [PATCH RFC] iio: dac: Fix build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m
From: Axel Lin <axel.lin@ingics.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/8 Lars-Peter Clausen <lars@metafoo.de>:
> On 05/08/2013 10:36 AM, Axel Lin wrote:
>> This patch fixes below build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m:
>>
>> drivers/built-in.o: In function `ad5064_i2c_write':
>> drivers/iio/dac/ad5064.c:608: undefined reference to `i2c_master_send'
>> drivers/built-in.o: In function `ad5064_i2c_register_driver':
>> drivers/iio/dac/ad5064.c:646: undefined reference to `i2c_register_driver'
>> drivers/built-in.o: In function `ad5064_i2c_unregister_driver':
>> drivers/iio/dac/ad5064.c:651: undefined reference to `i2c_del_driver'
>> make: *** [vmlinux] Error 1
>>
>> Add config IIO_DAC_I2C_AND_SPI helper to handle such case:
>> When CONFIG_I2C=m, meaning we can't build the drivers in with I2C support.
>> Thus don't allow the drivers to be compiled as built-in.
>>
>
> My plan was to do something like "depends on (SPI_MASTER && I2C!=m) || I2C",
This change seems simpler than this path.
Thus I'm going to send v2 for it.

Thanks,
Axel
