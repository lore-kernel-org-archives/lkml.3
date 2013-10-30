Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3J3Bm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:42:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3J3Bm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:42:26 -0400
Message-ID: <527063FB.7070400@infradead.org>
Date: Tue, 29 Oct 2013 18:42:19 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, broonie@kernel.org
CC: ning.li@intel.com, linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 11:05, David Cohen wrote:

a few more comments:

> +static unsigned int ssp_get_clk_div(int speed)
> +{
> +	return max(100000000 / speed, 4) - 1;

Divide uses library call?  I dunno...
Bad if so.  Would need to use some function from
#include <asm-generic/div64.h>

> +}

> +/**
> + * setup() - Driver setup procedure
> + * @spi:	Pointeur to the spi_device struct

		Pointer

> + */
> +static int setup(struct spi_device *spi)
> +{
> +}
> +/**
> + * ssp_spi_probe() - Driver probe procedure
> + * @pdev:	Pointer to the pci_dev struct
> + * @ent:	Pointer to the pci_device_id struct
> + */
> +static int ssp_spi_probe(struct pci_dev *pdev,
> +	const struct pci_device_id *ent)
> +{
> +	/* Set platform & configuration quirks */
> +	if (sspc->quirks & QUIRKS_PLATFORM_MRST) {
> +		/* Apply bit banging workarround on MRST */

		                     workaround

> +		sspc->quirks |= QUIRKS_BIT_BANGING;
> +		/* MRST slave mode workarrounds */

		                   workarounds

> +		if (ssp_cfg_is_spi_slave(ssp_cfg))
> +			sspc->quirks |= QUIRKS_USE_PM_QOS |
> +					QUIRKS_SRAM_ADDITIONAL_CPY;
> +	}
> +	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
> +		ssp_timing_wr = 1;
> +
> +	if (status < 0) {
> +		dev_err(&pdev->dev, "can not get IRQ\n");

		                     cannot

> +		goto err_free_4;
> +	}
> +
> +}

> +MODULE_AUTHOR("Ken Mills");
> +MODULE_DESCRIPTION("Bulverde SSP core SPI contoller");

                                             controller

> +MODULE_LICENSE("GPL");


-- 
~Randy
