Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaKKLuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:50:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:10478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaKKLuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414773251"
Date: Tue, 11 Nov 2014 13:50:28 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de,
        maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, skuribay@pobox.com, Romain.Baeriswyl@abilis.com,
        wenkai.du@intel.com, chiau.ee.chew@intel.com,
        christian.ruppert@abilis.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20141111115028.GH1454@lahna.fi.intel.com>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 11:40:26AM -0700, David E. Box wrote:
> +void baytrail_evaluate_sem(struct dw_i2c_dev *dev)
> +{
> +	acpi_status status;
> +	unsigned long long shared_host = 0;
> +	acpi_handle handle;
> +
> +	if (!dev || !dev->dev) {
> +		pr_err("%s:%d: device is NULL\n", __func__, __LINE__);

Not sure if it is useful to print things like above.

> +		return;
> +	}
> +
> +	handle = ACPI_HANDLE(dev->dev);
> +	if (!handle)
> +		return;
> +
> +	status = acpi_evaluate_integer(handle, "_SEM", NULL, &shared_host);

Maybe it is better to check first if the operation succeeded before
touching shared_host?

	if (ACPI_SUCCESS(status) && shared_host) {
	}

Otherwise ACPI parts look good to me.

> +
> +	if (shared_host) {
> +		dev_info(dev->dev, "I2C bus managed by PUNIT\n");
> +		dev->has_hw_lock = true;
> +		dev->pm_runtime_disabled = true;
> +	}
> +}
> +EXPORT_SYMBOL(baytrail_evaluate_sem);
