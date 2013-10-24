Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3JXIiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:38:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab3JXIiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:38:09 -0400
Message-ID: <1382603886.1559.11.camel@linux-fkkt.site>
Subject: Re: [PATCH v2] Input: add regulator haptic driver
From: Oliver Neukum <oneukum@suse.de>
To: "hyunhee.kim" <hyunhee.kim@samsung.com>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        broonie@opensource.wolfsonmicro.com, peter.ujfalusi@ti.com,
        wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kyungmin.park@samsung.com,
        "'Aristeu Sergio Rozanski Filho'" <aris@ruivo.org>
Date: Thu, 24 Oct 2013 10:38:06 +0200
In-Reply-To: <025101ced083$35f2a270$a1d7e750$%kim@samsung.com>
References: <000a01cec629$3cf34de0$b6d9e9a0$%kim@samsung.com>
	 <20131021155558.GA4255@core.coreip.homeip.net>
	 <025101ced083$35f2a270$a1d7e750$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 15:35 +0900, hyunhee.kim wrote:

Hi,

first of all your mail client mangled the patch.

> +static void regulator_haptic_toggle(struct regulator_haptic *haptic, bool
> enable)
> +{
> +	int ret;
> +
> +	mutex_lock(&haptic->mutex);
> +	if (enable && !haptic->enabled) {
> +		haptic->enabled = true;
> +		ret = regulator_enable(haptic->regulator);
> +		if (ret)
> +			dev_err(haptic->dev, "failed to enable
> regulator\n");
> +	} else if (!enable && haptic->enabled) {
> +		haptic->enabled = false;
> +		ret = regulator_disable(haptic->regulator);
> +		if (ret)
> +			dev_err(haptic->dev, "failed to disable
> regulator\n");
> +	}
> +	mutex_unlock(&haptic->mutex);
> +}
> +

Is there anything gained by the toggle parameter? Just code two
functions.

	Regards
		Oliver


