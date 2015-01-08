Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbbAHDQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 22:16:34 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:20973 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbbAHDQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 22:16:33 -0500
Message-ID: <54ADF60F.9070300@imgtec.com>
Date: Thu, 8 Jan 2015 00:14:23 -0300
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?gbk?Q?=22Peter_Pan_=C5=CB=B6=B0_=28peterpandong=29=22?= 
	<peterpandong@micron.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        =?gbk?Q?=22Qi_Wang_=CD=F5=C6=F0_=28qiwang=29=22?= 
	<qiwang@micron.com>,
        =?gbk?Q?=22Frank_Liu_=C1=F5=C8=BA_=28frankliu=29=22?= 
	<frankliu@micron.com>,
        =?gbk?Q?=22Melanie_Zhang_=D5=C5=D1=E0_=28me?=
	 =?gbk?Q?laniezhang=29=22?= <melaniezhang@micron.com>
Subject: Re: [PATCH 1/3] mtd: spi-nand framework
References: <87F60714EC601C4C83DFF1D2E3D390A04AB404@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <87F60714EC601C4C83DFF1D2E3D390A04AB404@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.100.200.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/07/2015 09:48 PM, Peter Pan ÅË¶° (peterpandong) wrote:
[..]
> +
> +static void spi_nand_set_defaults(struct spi_nand_chip *chip)
> +{
> +	struct spi_device *spi = chip->spi;
> +
> +	if (spi->mode & SPI_RX_QUAD)
> +		chip->read_cache = spi_nand_read_from_cache_x4;
> +	else if (spi->mode & SPI_RX_DUAL)
> +		chip->read_cache = spi_nand_read_from_cache_x2;
> +	else
> +		chip->read_cache = spi_nand_read_from_cache;
> +
> +	if (!chip->reset)
> +		chip->reset = spi_nand_reset;
> +	if (!chip->erase_block)
> +		chip->erase_block = spi_nand_erase_block;
> +	if (!chip->load_page)
> +		chip->load_page = spi_nand_read_page_to_cache;
> +	if (!chip->store_cache)
> +		chip->store_cache = spi_nand_program_data_to_cache;

IMO, this is a mistake and one of the reasons why this whole file is so big.

Do you have any reason for keeping the SPI commands (read page to cache,
program data to cache, etc.) in the spi-nand-base.c ?

This shouldn't belong to the framework, but to some spi-nand-device.c
implementing the SPI NAND commands for the devices we have seen so far.
In fact, I don't think you should inherit this "default" hook stuff from
NAND, it only makes the code more obscure.

As Brian noted, such a separation would be benefitial to support a
potential SPI-NAND-specific controller.

However, I think the stronger reason is that it results in a much
simpler and clean initial code.
-- 
Ezequiel
