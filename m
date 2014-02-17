Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaBQIDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:03:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:48912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaBQIDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:03:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,859,1384329600"; 
   d="scan'208";a="456721954"
Date: Mon, 17 Feb 2014 10:11:04 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] i2c: designware-pci: Add Baytrail PCI IDs
Message-ID: <20140217081104.GM5018@intel.com>
References: <1391524279-23409-1-git-send-email-mika.westerberg@linux.intel.com>
 <20140215152736.GF2579@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215152736.GF2579@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 04:27:37PM +0100, Wolfram Sang wrote:
> On Tue, Feb 04, 2014 at 04:31:19PM +0200, Mika Westerberg wrote:
> > Intel Baytrail I2C controllers can be enumerated from PCI as well as from
> > ACPI. In order to support this add the Baytrail PCI IDs to the driver.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Basically fine, one question:
> 
> > -	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
> > -		adap->nr);
> > +
> > +	if (adap->nr < 0)
> > +		snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci");
> > +	else
> > +		snprintf(adap->name, sizeof(adap->name),
> > +			 "i2c-designware-pci-%d", adap->nr);
> 
> Maybe we just drop the "-%d" suffix entirely?

I suggested that already when Benson (CC'd) sent his Haswell patch series.
His opinion was that it is useful in certain cases to know the bus number
(like grepping /proc/interrupts, IIRC).

For Baytrail we don't need it so if nobody objects, I'll just go ahead and
drop it.
