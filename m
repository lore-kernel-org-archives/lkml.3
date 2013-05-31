Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3EaQK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:10:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33183 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3EaQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:10:50 -0400
Message-ID: <51A8CB87.80201@wwwdotorg.org>
Date: Fri, 31 May 2013 10:10:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org> <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org> <1528437.8btZmmDHhd@wuerfel>
In-Reply-To: <1528437.8btZmmDHhd@wuerfel>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 02:45 AM, Arnd Bergmann wrote:
> Can you check this part again:
> 
> On Tuesday 21 May 2013 20:36:35 Stephen Warren wrote:
>> diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
...
>> @@ -1190,11 +1172,13 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
>>         drv_data->ioaddr = ssp->mmio_base;
>>         drv_data->ssdr_physical = ssp->phys_base + SSDR;
>>         if (pxa25x_ssp_comp(drv_data)) {
>> +               master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 16);
>>                 drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE;
>>                 drv_data->dma_cr1 = 0;
>>                 drv_data->clear_sr = SSSR_ROR;
>>                 drv_data->mask_sr = SSSR_RFS | SSSR_TFS | SSSR_ROR;
>>         } else {
>> +               master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
>>                 drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE | SSCR1_TINTE;
>>                 drv_data->dma_cr1 = DEFAULT_DMA_CR1;
>>                 drv_data->clear_sr = SSSR_ROR | SSSR_TINT;
> 
> I get a new build warning
> 
> drivers/spi/spi-pxa2xx.c: In function 'pxa2xx_spi_probe':
> drivers/spi/spi-pxa2xx.c:1152:3: warning: left shift count >= width of type [enabled by default]
>    master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
>    ^

That should be fixed by the patches I sent yesterday.
