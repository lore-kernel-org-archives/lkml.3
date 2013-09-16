Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3IPOcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:32:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:5719 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3IPOcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,915,1371106800"; 
   d="scan'208";a="378926631"
Date: Mon, 16 Sep 2013 17:38:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
Message-ID: <20130916143811.GP7393@intel.com>
References: <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
 <20130913173149.GE7393@intel.com>
 <87ioy4e8bw.fsf@linaro.org>
 <20130915064139.GJ7393@intel.com>
 <20130915124744.GW29403@sirena.org.uk>
 <20130915132823.GL7393@intel.com>
 <20130916101249.GX29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916101249.GX29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:12:49AM +0100, Mark Brown wrote:
> That's definitely an ACPI specific (probably x86 specific ACPI?)
> requirement not a generic one, on some systems it would increase power
> consumption since the controller will need to sit on while the device is
> functioning autonomously.

Yes, the ACPI 5.0 spec says that the device cannot be in higher D-state
than its parent. This is not x86 specific, though I'm not sure if this is
implemented elsewhere.

> Even though the controller power consumption is going to be minimal the
> power domain it is in may be relatively large.  Can't the power domains
> for ACPI deal with this requirement, for example by making the I2C slave
> power domains children of the controller power domain?

We'll look into this. Thanks for the suggestion.
