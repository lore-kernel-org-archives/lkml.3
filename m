Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaEVLQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:16:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:2290 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaEVLQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:16:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,886,1392192000"; 
   d="scan'208";a="435489088"
Date: Thu, 22 May 2014 14:15:54 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, mathias.nyman@linux.intel.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v3] gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140522111554.GG1651@lahna.fi.intel.com>
References: <1400734743-3154-1-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400734743-3154-1-git-send-email-lejun.zhu@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 12:59:03PM +0800, Zhu, Lejun wrote:
> +static int crystalcove_gpio_probe(struct platform_device *pdev)
> +{
> +	int irq = platform_get_irq(pdev, 0);
> +	struct crystalcove_gpio *cg;
> +	int retval;
> +	struct device *dev = pdev->dev.parent;
> +
> +	cg = devm_kzalloc(&pdev->dev, sizeof(*cg), GFP_KERNEL);
> +	if (!cg) {

A minor comment here:

return -ENOMEM;

> +		retval = -ENOMEM;
> +		goto out;
> +	}

Other than that this looks good to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I suppose this is dependent on the MFD driver right? If so, this should
probably be merged along with that patch.
