Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaBCLaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:30:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:7319 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbaBCLap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:30:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,771,1384329600"; 
   d="scan'208";a="408061353"
Date: Mon, 3 Feb 2014 17:00:32 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 16/18] charger: max14577: Add support for MAX77836 charger
Message-ID: <20140203113031.GA8848@jenny-desktop>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-17-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390911522-28209-17-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 01:18:40PM +0100, Krzysztof Kozlowski wrote:
> -	/* Battery-Charger Constant Voltage (CV) Mode, from SM-V700: 4.35V */
> +	/* Battery-Charger Constant Voltage (CV) Mode, set to: 4.35V */

Does this charger chip support only 4.35V batteries? If the CV is hard coded
to 4.35V, it's not safe for 4.2V batteries.

> +	/* End-of-Charge Current, set to 50mA (max14577) / 7.5mA (max77836) */
The End of charge current basically depend on battery and not on charger chip.

> -	/* Overvoltage-Protection Threshold, from SM-V700: 6.5V */
> +	/* Overvoltage-Protection Threshold, set to 6.5V */
6.5V as over voltage for battery? A 4.35V battery would have exploded by
that time!
