Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3DAIXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:23:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:61577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787Ab3DAIXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:23:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,385,1363158000"; 
   d="scan'208";a="310414691"
Date: Mon, 1 Apr 2013 11:27:17 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] ACPI / SPI: Use parent's ACPI_HANDLE() in
 acpi_register_spi_devices()
Message-ID: <20130401082717.GK21804@intel.com>
References: <2747891.0orCNBJG8v@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2747891.0orCNBJG8v@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:21:08AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The ACPI handle of struct spi_master's dev member should not be
> set, because this causes that struct spi_master to be associated
> with the ACPI device node corresponding to its parent as the
> second "physical_device", which is incorrect (this happens during
> the registration of struct spi_master).  Consequently,
> acpi_register_spi_devices() should use the ACPI handle of the
> parent of the struct spi_master it is called for rather than that
> struct spi_master's ACPI handle (which should be NULL).
> 
> Make that happen and modify the spi-pxa2xx driver, which currently is
> the only driver for ACPI-enumerated SPI controller chips, not to set
> the ACPI handle for the struct spi_master it creates.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
