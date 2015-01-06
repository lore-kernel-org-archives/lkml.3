Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbbAFVtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:49:53 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:40373 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbbAFVtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:49:51 -0500
Date: Tue, 6 Jan 2015 22:47:56 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Ken Wilson <ken.wilson@opengear.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, gerg@uclinux.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        broonie@kernel.org, ezequiel.garcia@free-electrons.com,
        galak@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: orion: Add multiple chip select support for Armada
 370 and 375
Message-ID: <20150106214756.GE25030@lunn.ch>
References: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420579846-31962-1-git-send-email-ken.wilson@opengear.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ken

> -static const struct orion_spi_dev armada_spi_dev_data = {
> +static const struct orion_spi_dev armada_370_spi_dev_data = {
>  	.typ = ARMADA_SPI,
>  	.min_divisor = 1,
>  	.max_divisor = 1920,
>  	.prescale_mask = ARMADA_SPI_CLK_PRESCALE_MASK,
> +	.num_cs = 4,
> +};
> +
> +static const struct orion_spi_dev armada_375_spi_dev_data = {
> +	.typ = ORION_SPI,
> +	.min_divisor = 4,
> +	.max_divisor = 30,
> +	.prescale_mask = ORION_SPI_CLK_PRESCALE_MASK,
> +	.num_cs = 3,
>  };

Documentation/devicetree/bindings/spi/spi-bus.txt has the optional property:

- num-cs : total number of chipselects

Would it be better to use that?

      Andrew
