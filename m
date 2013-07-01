Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab3GASY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:24:56 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:33229 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab3GASYy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:24:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1372703092!11754363!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Ryan Mallon <rmallon@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Mon, 1 Jul 2013 13:22:50 -0500
Subject: RE: [PATCH 2/8] spi: spi-ep93xx: use bits_per_word_mask
Thread-Topic: [PATCH 2/8] spi: spi-ep93xx: use bits_per_word_mask
Thread-Index: Ac51rPZNmmxg83eoSOydU4YpXPK+zwA2tlLQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC38FFBD@AUSP01VMBX24.collaborationhost.net>
References: <201306281143.07615.hartleys@visionengravers.com>
 <20130630161358.GA786@mwesterb-mobl.lan>
In-Reply-To: <20130630161358.GA786@mwesterb-mobl.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 30, 2013 9:14 AM, Mika Westerberg wrote:
> On Fri, Jun 28, 2013 at 11:43:07AM -0700, H Hartley Sweeten wrote:
>> This driver supports 16 to 4 bits per work. Set the bits_per_word_mask
>> to allows the spi core to handle validation.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> Cc: Mika Westerberg <mika.westerberg@iki.fi>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> ---
>>  drivers/spi/spi-ep93xx.c | 11 +----------
>>  1 file changed, 1 insertion(+), 10 deletions(-)
>> 
>> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
>> index c633cd0..93ae7b6 100644
>> --- a/drivers/spi/spi-ep93xx.c
>> +++ b/drivers/spi/spi-ep93xx.c
>> @@ -272,12 +272,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
>>  	struct ep93xx_spi *espi = spi_master_get_devdata(spi->master);
>>  	struct ep93xx_spi_chip *chip;
>>  
>> -	if (spi->bits_per_word < 4 || spi->bits_per_word > 16) {
>> -		dev_err(&espi->pdev->dev, "invalid bits per word %d\n",
>> -			spi->bits_per_word);
>> -		return -EINVAL;
>> -	}
>> -
>>  	chip = spi_get_ctldata(spi);
>>  	if (!chip) {
>>  		dev_dbg(&espi->pdev->dev, "initial setup for %s\n",
>> @@ -341,10 +335,6 @@ static int ep93xx_spi_transfer(struct spi_device *spi, struct spi_message *msg)
>>  
>>  	/* first validate each transfer */
>>  	list_for_each_entry(t, &msg->transfers, transfer_list) {
>> -		if (t->bits_per_word) {
>> -			if (t->bits_per_word < 4 || t->bits_per_word > 16)
>> -				return -EINVAL;
>> -		}
>>  		if (t->speed_hz && t->speed_hz < espi->min_rate)
>>  				return -EINVAL;
>>  	}
>> @@ -1022,6 +1012,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
>>  	master->bus_num = pdev->id;
>>  	master->num_chipselect = info->num_chipselect;
>>  	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
>> +	master->bits_per_word_mask = 0xfff8;	/* 16 to 4 bits per word */
>
> Please use SPI_BPW_RANGE_MASK(4, 16) here.

I thought there was a macro for this, just couldn't find it. I'll fix this.

Thanks, 
Hartley

