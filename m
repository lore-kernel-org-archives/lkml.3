Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3I3Sxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:53:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:54701 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab3I3Sxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="403293745"
Date: Mon, 30 Sep 2013 21:59:07 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3] i2c: enable runtime PM for I2C adapter devices
 enumerated from ACPI
Message-ID: <20130930185907.GS28875@intel.com>
References: <1380552228-23329-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
 <34540715.4ajYlpge4D@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34540715.4ajYlpge4D@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 07:20:59PM +0200, Rafael J. Wysocki wrote:
> > +static void acpi_i2c_device_pm_get(struct i2c_client *client)
> > +{
> > +	struct i2c_adapter *adap = client->adapter;
> > +
> > +	/* Make sure the adapter is active */
> > +	if (ACPI_HANDLE(adap->dev.parent))
> > +		pm_runtime_get_sync(&adap->dev);
> > +	if (ACPI_HANDLE(&client->dev))
> > +		acpi_dev_pm_attach(&client->dev, true);
> 
> It would be sufficient to do
> 
> 	if (ACPI_HANDLE(&client->dev)) {
> 		pm_runtime_get_sync(&adap->dev);
> 		acpi_dev_pm_attach(&client->dev, true);
> 	}
> 
> here (and below), because I don't think the client with an ACPI handle and the
> parent without one is extremely unlikely (to the point of non-existence
> actually ;-)).  And even if something like that happens, then we only enable
> runtime PM for the adapter if the parent has an ACPI handle, so it still should
> be OK.

OK, I'll change that in the next revision. 

> Apart from this the patch looks good to me.

Thanks!
