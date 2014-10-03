Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaJCMac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:30:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45091 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaJCMa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:30:29 -0400
MIME-Version: 1.0
In-Reply-To: <20141003011433.GG1323@katana>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
	<1411661254-5204-3-git-send-email-octavian.purdila@intel.com>
	<20141003011433.GG1323@katana>
Date: Fri, 3 Oct 2014 15:30:28 +0300
Message-ID: <CAE1zotLmY-UMVCGgJB=1X2MuMgERjdD2f7TsXVonZxE-cWb+kA@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] i2c: add support for Diolan DLN-2 USB-I2C adapter
From: Octavian Purdila <octavian.purdila@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 4:14 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Hi,
>
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index 2ac87fa..6afc17e 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -1021,4 +1021,14 @@ config SCx200_ACB
>>         This support is also available as a module.  If so, the module
>>         will be called scx200_acb.
>>
>> +config I2C_DLN2
>> +       tristate "Diolan DLN-2 USB I2C adapter"
>> +       depends on MFD_DLN2
>> +       help
>> +         If you say yes to this option, support will be included for Diolan
>> +         DLN2, a USB to I2C interface.
>> +
>> +         This driver can also be built as a module.  If so, the module
>> +         will be called i2c-dln2.
>> +
>
> Please keep to the existing sorting.
>
>
>>  endmenu
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index 49bf07e..3118fea 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -100,5 +100,6 @@ obj-$(CONFIG_I2C_ELEKTOR) += i2c-elektor.o
>>  obj-$(CONFIG_I2C_PCA_ISA)    += i2c-pca-isa.o
>>  obj-$(CONFIG_I2C_SIBYTE)     += i2c-sibyte.o
>>  obj-$(CONFIG_SCx200_ACB)     += scx200_acb.o
>> +obj-$(CONFIG_I2C_DLN2)               += i2c-dln2.o
>
> Ditto!
>
>> +static int dln2_i2c_enable(struct dln2_i2c *dln2, bool enable)
>> +{
>> +     int ret;
>> +     u16 cmd;
>> +
>> +     if (enable)
>> +             cmd = DLN2_I2C_ENABLE;
>> +     else
>> +             cmd = DLN2_I2C_DISABLE;
>
> Ternary operator?
>

In the first versions of the patch it was used, but Johan suggested to avoid it.

I have addressed the rest of you comments, thanks for the review.
