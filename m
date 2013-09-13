Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3IMLpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:45:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:63010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab3IMLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,897,1371106800"; 
   d="scan'208";a="395231367"
Date: Fri, 13 Sep 2013 14:50:35 +0300
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
Message-ID: <20130913115035.GB7393@intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <20130913095950.GA29403@sirena.org.uk>
 <20130913101611.GA7393@intel.com>
 <20130913103152.GE29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913103152.GE29403@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:31:52AM +0100, Mark Brown wrote:
> On Fri, Sep 13, 2013 at 01:16:11PM +0300, Mika Westerberg wrote:
> > On Fri, Sep 13, 2013 at 10:59:50AM +0100, Mark Brown wrote:
> 
> > > Accessing the bus isn't an issue for I2C outside of ACPI, the power
> > > management of the device is totally disassociated from the bus and the
> > > controller is responsible for ensuring it is available during transfers.
> 
> > Yes, but since we want to support ACPI as well, we must make sure that the
> > adapter (and the associated controller) is available when client ->probe()
> > is called.
> 
> Right, but this probably needs to be highlighted more since it's a very
> surprising thing for I2C and is causing confusion.

By highlighted more, do you mean something like adding a comment in the
code about this or?
