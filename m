Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaGJJbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:31:32 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:33145 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaGJJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
	<1404982207-4707-2-git-send-email-harinik@xilinx.com>
	<CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
Date: Thu, 10 Jul 2014 15:01:25 +0530
Message-ID: <CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
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

Hi Geert,

On Thu, Jul 10, 2014 at 2:48 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Harini,
>
> On Thu, Jul 10, 2014 at 10:50 AM, Harini Katakam <harinik@xilinx.com> wrote:
>> +       master->flags = SPI_MASTER_QUAD_MODE;
>
> SPI_MASTER_QUAD_MODE is not one of the SPI_MASTER_* defines
> in include/linux/spi/spi.h?
>

I'm sorry about that. That flag is unused - will remove this statement.

>> +       master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
>> +                           SPI_TX_DUAL | SPI_TX_QUAD;
>
> Your driver advertises Dual/Quad SPI Transfer capabilities, but it doesn't
> check spi_transfer.[tr]x_nbits? How can it determine when to enable Dual/Quad?
>

Here the driver is just giving information that the controller support it.
The MTD layer enables dual/quad based on what the flash supports; quad
being the first priority
I understand that the spi core reads rx, tx-bus-width property and
master support flags and
performs the necessary checks.

Regards,
Harini
