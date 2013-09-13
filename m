Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3IMKKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:10:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:21136 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab3IMKKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,897,1371106800"; 
   d="scan'208";a="294433247"
Date: Fri, 13 Sep 2013 13:16:11 +0300
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
Message-ID: <20130913101611.GA7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <20130913095950.GA29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913095950.GA29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:59:50AM +0100, Mark Brown wrote:
> On Fri, Sep 13, 2013 at 09:54:34AM +0300, Mika Westerberg wrote:
> > On Thu, Sep 12, 2013 at 02:34:21PM -0700, Kevin Hilman wrote:
> 
> > > For hardware that is disabled/powered-off on startup, there will now be
> > > a mismatch between the hardware state an the RPM core state.
> 
> > The call to pm_runtime_get_noresume() should make sure that the device is
> > in active state (at least in state where it can access the bus) if I'm
> > understanding this right.
> 
> Accessing the bus isn't an issue for I2C outside of ACPI, the power
> management of the device is totally disassociated from the bus and the
> controller is responsible for ensuring it is available during transfers.

Yes, but since we want to support ACPI as well, we must make sure that the
adapter (and the associated controller) is available when client ->probe()
is called.
