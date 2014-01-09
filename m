Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaAIP6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:58:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:48239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaAIP6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:58:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,631,1384329600"; 
   d="scan'208";a="464176571"
Date: Thu, 9 Jan 2014 18:05:05 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: Check conflicting CS based on spi->chip_select
 instead of device name
Message-ID: <20140109160505.GC2494@intel.com>
References: <1389273835-8615-1-git-send-email-mika.westerberg@linux.intel.com>
 <52CEAB4A.605@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CEAB4A.605@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:59:38PM +0200, Jarkko Nikula wrote:
> On 01/09/2014 03:23 PM, Mika Westerberg wrote:
> >Commit e13ac47bec20 (spi: Use stable dev_name for ACPI enumerated SPI
> >slaves) changed the SPI device naming to be based on ACPI device name
> >instead of carrying bus number and chip select for devices enumerated
> >from ACPI namespace.
> >
> >In case of a buggy BIOS that lists multiple SPI devices sharing the same
> >chip select (even though they should use different) the current code fails
> >to detect that and allows the devices to be added to the bus.
> >
> >Fix this by walking through the bus and comparing spi->chip_select instead
> >of device name. This should work regardless what the device name will be in
> >future.
> >
> >Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> >Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >---
> >  drivers/spi/spi.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> >index 349ebba4b199..13dcc360bde6 100644
> >--- a/drivers/spi/spi.c
> >+++ b/drivers/spi/spi.c
> >
> I guess this is a valid fix in that sense that before my patch those
> ill-defined SPI devices were not added. Is this something which
> should go to 3.13?

This is pretty rare case so I wouldn't expect any current HSW machines for
example to have such bugs. I'm not even sure if the SPI bus on LPSS is used
anywhere outside Intel currently.

However, we happen to have few development machines here where this bug
exists.

Up to Mark to decide whether this is urgent enough to be included in 3.13.

> Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Thanks.
