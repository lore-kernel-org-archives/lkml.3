Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaAIN7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:59:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:62606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaAIN7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:59:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,631,1384329600"; 
   d="scan'208";a="436324689"
Message-ID: <52CEAB4A.605@linux.intel.com>
Date: Thu, 09 Jan 2014 15:59:38 +0200
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: Check conflicting CS based on spi->chip_select instead
 of device name
References: <1389273835-8615-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1389273835-8615-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 03:23 PM, Mika Westerberg wrote:
> Commit e13ac47bec20 (spi: Use stable dev_name for ACPI enumerated SPI
> slaves) changed the SPI device naming to be based on ACPI device name
> instead of carrying bus number and chip select for devices enumerated
> from ACPI namespace.
>
> In case of a buggy BIOS that lists multiple SPI devices sharing the same
> chip select (even though they should use different) the current code fails
> to detect that and allows the devices to be added to the bus.
>
> Fix this by walking through the bus and comparing spi->chip_select instead
> of device name. This should work regardless what the device name will be in
> future.
>
> Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>   drivers/spi/spi.c | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 349ebba4b199..13dcc360bde6 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
>
I guess this is a valid fix in that sense that before my patch those 
ill-defined SPI devices were not added. Is this something which should 
go to 3.13?

Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
