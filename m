Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaAIOVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:21:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:62969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbaAIOU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,631,1384329600"; 
   d="scan'208";a="456089474"
Date: Thu, 9 Jan 2014 16:27:29 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: Check conflicting CS based on spi->chip_select
 instead of device name
Message-ID: <20140109142729.GA2494@intel.com>
References: <1389273835-8615-1-git-send-email-mika.westerberg@linux.intel.com>
 <20140109140646.GT31886@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109140646.GT31886@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 02:06:46PM +0000, Mark Brown wrote:
> On Thu, Jan 09, 2014 at 03:23:55PM +0200, Mika Westerberg wrote:
> 
> > In case of a buggy BIOS that lists multiple SPI devices sharing the same
> > chip select (even though they should use different) the current code fails
> > to detect that and allows the devices to be added to the bus.
> 
> This actually also points out another issue - if we have two instances
> of a device on different buses they could end up with the same
> dev_name() if they have the same chip select.  Hrm.

I don't think that can happen, at least in case of ACPI, since each ACPI
device has unique name, such as 'INT33C0:00' - the ':00' suffix is the
"instance" number ACPI core gives for devices.
