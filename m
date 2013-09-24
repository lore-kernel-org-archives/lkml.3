Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750750Ab3IXFNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 01:13:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:29397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab3IXFNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 01:13:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,968,1371106800"; 
   d="scan'208";a="408116028"
Date: Tue, 24 Sep 2013 08:18:56 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130924051856.GG28875@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <52332BF0.4060605@samsung.com>
 <20130913154013.GD7393@intel.com>
 <5235BA9C.1090509@gmail.com>
 <20130916084708.GN7393@intel.com>
 <523837F9.1020204@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523837F9.1020204@samsung.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 01:07:37PM +0200, Sylwester Nawrocki wrote:
> On 09/16/2013 10:47 AM, Mika Westerberg wrote:
> > I'm actually thinking that it is probably better now if we don't touch the
> > client runtime PM at all in the I2C core.
> > 
> > I proposed a less intrusive solution in this same thread where we power the
> > I2C controller briefly at the client ->probe() (In order to have all the
> > ACPI power resources etc. and the controller on) and let the client driver
> > handle their own runtime PM as they do currently.
> > 
> > Do you think that would work better wrt. fimc-isp-i2c driver?
> 
> That would be no different for this particular driver, as long as the 
> I2C bus controller is activated right before the I2C client's probe().

Rafael pointed out that we can use ->ignore_children for the I2C adapter
device for everything else than ACPI devices. That should keep the existing
behavior.

For ACPI devices we don't set that flag and the runtime PM core will
activate the adapter whenever we try to power on I2C client device. This
will make ACPI happy as well.

If there are no objections, I'm going to send a new version based on the
above.

Thanks everyone for valuable input :)
