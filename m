Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaBTGay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 01:30:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:18392 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaBTGaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 01:30:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,511,1389772800"; 
   d="scan'208";a="484623233"
Date: Thu, 20 Feb 2014 12:00:32 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 14/15] charger: max14577: Configure battery-dependent
 settings from DTS
Message-ID: <20140220063031.GC2498@jenny-desktop>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
 <1392627950-26927-15-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392627950-26927-15-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:05:49AM +0100, Krzysztof Kozlowski wrote:
> +static inline int max14577_init_eoc(struct max14577_charger *chg,
> +		unsigned int uamp)
> +{
> +	unsigned int current_bits = 0xf;
> +	u8 reg_data;
> +
> +	switch (chg->maxim_core->dev_type) {
> +	case MAXIM_DEVICE_TYPE_MAX77836:
> +		if (uamp < 5000)
> +			return -EINVAL; /* Requested current is too low */
> +
> +		if (uamp == 7500)
> +			current_bits = 0x0;

if (uamp <= 7500) ?

> +	/* Initialize Overvoltage-Protection Threshold */
> +	switch (chg->pdata->ovp_uvolt) {
> +	case 7500000:
> +		reg_data = 0x0;
> +		break;
> +	case 6000000:
> +	case 6500000:
> +	case 7000000:
> +		reg_data = 0x1 + (chg->pdata->ovp_uvolt - 6000000) / 500000;
> +		break;

Is it battery OVP or charger source OVP? If it's battery OVP, then  minimum
level as 6V seems to be unsafe even for 4.4V batteries.
