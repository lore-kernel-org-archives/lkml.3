Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161145Ab3BGSyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:54:05 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:52669 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161093Ab3BGSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:54:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130207115546.GA3801@sirena.org.uk>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
	<1360105784-12282-4-git-send-email-ks.giri@samsung.com>
	<20130207115546.GA3801@sirena.org.uk>
Date: Thu, 7 Feb 2013 10:54:01 -0800
Message-ID: <CAKrE-KfrWdOxm+DJyWqZn1Ye509E_LjzmDb5FMq55SF9-Sua0A@mail.gmail.com>
Subject: Re: [PATCH 3/4] spi: s3c64xx: add gpio quirk for controller
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 3:55 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Feb 05, 2013 at 03:09:43PM -0800, Girish K S wrote:
>> This patch adds support for spi controllers with
>> dedicated clk/miso/mosi/cs pins. It skips the gpio
>> parsing and initialization for controllers that
>> have dedicated pins.
>
>>               if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
>>                       /* Deselect the last toggled device */
>>                       cs = sdd->tgl_spi->controller_data;
>> -                     gpio_set_value(cs->line,
>> -                             spi->mode & SPI_CS_HIGH ? 0 : 1);
>> +                     if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
>> +                             gpio_set_value(cs->line,
>> +                                     spi->mode & SPI_CS_HIGH ? 0 : 1);
>>               }
>
> This isn't going to work with system designs which ignore the /CS line
> the controller has and just use a GPIO instead.  This is very common,
> for example when connecting multiple devices to the same SPI bus.
As per grant's comment i would remove the quirk option and check for
"cs-gpio" property
to handle /CS. When multiple devices are connected to the same spi
bus, "cs-gpio" entry would exist in the dts
file, and works with /CS gpio lines.
>
> It seems like there's really two changes here.  One change is making the
> provision of pinmux information optional, the other is allowing the user
> to use the controller /CS management rather than using GPIO.
As suggested i would make two changes.
1. would parse the "gpios"  property and make decision whether to use
gpios/dedicated pins for miso/miso/clk.
2.would parse "cs-gpio"  property from dts node to handle the chip select
correct me if my understanding is wrong
