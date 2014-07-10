Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaGJJSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:18:18 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:42693 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaGJJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:18:13 -0400
MIME-Version: 1.0
In-Reply-To: <1404982207-4707-2-git-send-email-harinik@xilinx.com>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
	<1404982207-4707-2-git-send-email-harinik@xilinx.com>
Date: Thu, 10 Jul 2014 11:18:11 +0200
X-Google-Sender-Auth: y-tnX5UKQfMpw15U0A4-Vy4fb4U
Message-ID: <CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harini Katakam <harinik@xilinx.com>
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
        artem.bityutskiy@linux.intel.com,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        michals@xilinx.com, punnaia@xilinx.com,
        Harini Katakam <harinikatakamlinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harini,

On Thu, Jul 10, 2014 at 10:50 AM, Harini Katakam <harinik@xilinx.com> wrote:
> +       master->flags = SPI_MASTER_QUAD_MODE;

SPI_MASTER_QUAD_MODE is not one of the SPI_MASTER_* defines
in include/linux/spi/spi.h?

> +       master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_RX_DUAL | SPI_RX_QUAD |
> +                           SPI_TX_DUAL | SPI_TX_QUAD;

Your driver advertises Dual/Quad SPI Transfer capabilities, but it doesn't
check spi_transfer.[tr]x_nbits? How can it determine when to enable Dual/Quad?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
