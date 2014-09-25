Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaIYLQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:16:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:37908 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaIYLQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:16:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,596,1406617200"; 
   d="scan'208";a="605184053"
Date: Thu, 25 Sep 2014 14:15:55 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lejun Zhu <lejun.zhu@intel.com>,
        Radivoje Jovanovic <radivoje.jovanovic@intel.com>,
        Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 1/2] gpio / CrystalCove: support virtual GPIO
Message-ID: <20140925111555.GG1786@lahna.fi.intel.com>
References: <1410229968-11638-1-git-send-email-aaron.lu@intel.com>
 <1410229968-11638-2-git-send-email-aaron.lu@intel.com>
 <CACRpkdaJjqs9WNcVvjsSWhzLD2QpcyR11MVm4xhm4GqB28eOCA@mail.gmail.com>
 <54238496.70505@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54238496.70505@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:57:26AM +0800, Aaron Lu wrote:
> The virtual GPIO introduced in ACPI table of Baytrail-T based system is
> used to solve a problem under Windows. We do not have such problems
> under Linux so we do not actually need them. But we have to tell GPIO
> library that the Crystal Cove GPIO chip has this many GPIO pins or the
> common GPIO handler will refuse any access to those high number GPIO
> pins, which will resulted in a failure evaluation of every ACPI control
> method that is used to turn on/off power resource and/or report sensor
> temperatures.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

A minor nit, see below:

> ---
> v2: remove the hunk to increase NR_GPIO to 512.
> 
>  drivers/gpio/gpio-crystalcove.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
> index e3712f0e51ab..186b76ef71a1 100644
> --- a/drivers/gpio/gpio-crystalcove.c
> +++ b/drivers/gpio/gpio-crystalcove.c
> @@ -24,6 +24,7 @@
>  #include <linux/mfd/intel_soc_pmic.h>
>  
>  #define CRYSTALCOVE_GPIO_NUM	16
> +#define CRYSTALCOVE_VGPIO_NUM	0x5e

I would rather see this spelled in decimal base.
