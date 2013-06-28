Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3F1Xnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:43:43 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.9]:46727 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab3F1Xnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:43:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1372463020!5931809!2
X-Originating-IP: [216.166.12.7]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Fri, 28 Jun 2013 18:42:59 -0500
Subject: RE: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
Thread-Topic: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
Thread-Index: Ac50Vbr3DNTFF3JCQn6/doKIm3qXFAAAiDuQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC38FE45@AUSP01VMBX24.collaborationhost.net>
References: <201306281143.35130.hartleys@visionengravers.com>
 <51CE199A.4040606@gmail.com>
In-Reply-To: <51CE199A.4040606@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5SNiETX024650

On Friday, June 28, 2013 4:18 PM, Ryan Mallon wrote:
> On 29/06/13 04:43, H Hartley Sweeten wrote:
>> __spi_async(), which starts every SPI message transfer, initializes
>> the bits_per_word and max speed for every transfer in the message.
>> Since the conditional test in ep93xx_spi_process_transfer() will
>> always succeed just remove it and always call ep93xx_spi_chip_setup()
>> to configure the hardware for each transfer in the message.
>> 
>> Remove the redundant ep93xx_spi_chp_setup() in ep93xx_spi_process_transfer()
>> which just initializes the hardware to the "default" based on the SPI
>> device.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> Cc: Mika Westerberg <mika.westerberg@iki.fi>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> ---
>
>
>> +	err = ep93xx_spi_calc_divisors(espi, chip, t->speed_hz);
>> +	if (err) {
>> +		dev_err(&espi->pdev->dev, "failed to adjust speed\n");
>
>
> Printing out the speed it was trying to set might be useful here?

Technically I don't think this can ever happen.

The minimum and maximum possible speeds are determined during the probe.

	espi->max_rate = clk_get_rate(espi->clk) / 2;
	espi->min_rate = clk_get_rate(espi->clk) / (254 * 256);

Each transfer is validated to make sure the speed is greater than the
minimum.

		if (t->speed_hz < espi->min_rate)
			return -EINVAL;

Then the rate is clamped to the min/max rates.

	rate = clamp(rate, espi->min_rate, espi->max_rate);

The calculations for the div_csr and div_cpsr values needed to produce
the desired rate should always succeed.

Patch 7/8 actually replaces that dev_err() message with a more generic
one. In reality, even the new message, and the error checking, could
probably be removed.

Regards,
Hartley

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
