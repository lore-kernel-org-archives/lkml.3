Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaGNH1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:27:11 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:45219 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaGNH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140711133841.GU30458@sirena.org.uk>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
	<1404982207-4707-2-git-send-email-harinik@xilinx.com>
	<20140711133841.GU30458@sirena.org.uk>
Date: Mon, 14 Jul 2014 12:57:07 +0530
Message-ID: <CAFcVEC+fO9e6d0HXC0UsY3ptNhXhD0TVFuuw3HdS5RpAUmtR8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jul 11, 2014 at 7:08 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jul 10, 2014 at 02:20:06PM +0530, Harini Katakam wrote:
>
>> This patch adds support for QSPI controller used by Zynq.
>
> The driver looks pretty clean but there are a couple of issues below,
> including a little bit more of the flash specifics.
>
>> +static void zynq_qspi_chipselect(struct spi_device *qspi, bool is_high)
>> +{
>> +     struct zynq_qspi *xqspi = spi_master_get_devdata(qspi->master);
>> +     u32 config_reg;
>> +
>> +     config_reg = zynq_qspi_read(xqspi, ZYNQ_QSPI_CONFIG_OFFSET);
>> +
>> +     /* Select upper/lower page before asserting CS */
>> +     if (xqspi->is_stacked) {
>> +             u32 lqspi_cfg_reg;
>
> Like with the dual and quad mode stuff this looks very much like it's
> specific to flash rather than something that applies to a generic SPI
> driver.  However it does look like it's a generic SPI device which could
> be used in other applications which makes things a bit tricky.  We don't
> have a really good answer for this right now unfortunately, probably we
> need some sort of special interface between the SPI and flash subsystems
> to allow flash to use the flash specific stuff.
>
> For use as a generic SPI device what I'd suggest is stripping out the
> flash specifics, merging the rest of the support and then considering
> the flash specifics separately.

Reply in the other thread.

>
>> +/**
>> + * zynq_prepare_transfer_hardware - Prepares hardware for transfer.
>> + * @master:  Pointer to the spi_master structure which provides
>> + *           information about the controller.
>> + *
>> + * This function enables SPI master controller.
>> + *
>> + * Return:   Always 0
>> + */
>> +static int zynq_prepare_transfer_hardware(struct spi_master *master)
>> +{
>> +     struct zynq_qspi *xqspi = spi_master_get_devdata(master);
>> +
>> +     zynq_qspi_config_clock_mode(master->cur_msg->spi);
>
> The clock mode needs to be (and is) configured per transfer so I'd
> expect it's possible to remove this call.
>

Yeah I understand. It can go away from here and there should be a
prepare_message as per Lars-Peter's patches on spi-cadence.
I'll reflect the same in this driver.

Regards,
Harini
