Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3JAJqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:46:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:45286 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3JAJqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="403573016"
Date: Tue, 1 Oct 2013 12:52:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, rjw@rjwysocki.net,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3] i2c: enable runtime PM for I2C adapter devices
 enumerated from ACPI
Message-ID: <20131001095209.GX28875@intel.com>
References: <1380552228-23329-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380552228-23329-2-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 05:43:48PM +0300, Mika Westerberg wrote:
> +static void acpi_i2c_device_pm_get(struct i2c_client *client)
> +{
> +	struct i2c_adapter *adap = client->adapter;
> +
> +	/* Make sure the adapter is active */
> +	if (ACPI_HANDLE(adap->dev.parent))
> +		pm_runtime_get_sync(&adap->dev);
> +	if (ACPI_HANDLE(&client->dev))
> +		acpi_dev_pm_attach(&client->dev, true);

There's a bug here as we call acpi_dev_pm_attach() several times. It
doesn't do any harm because acpi_dev_pm_attach() checks if the device is
already attached to the ACPI domain or not.

I'll fix this in the next revision as well.

> +}
