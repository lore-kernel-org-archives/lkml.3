Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936405Ab3DQTYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:24:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55484 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936199Ab3DQTYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:24:42 -0400
Date: Wed, 17 Apr 2013 20:24:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V5 7/7] drivers/regulator: DA9058 REGULATOR driver
Message-ID: <20130417192440.GC19873@opensource.wolfsonmicro.com>
References: <201304171638.r3HGc3Qv023842@latitude>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304171638.r3HGc3Qv023842@latitude>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:33:37PM +0100, Anthony Olech wrote:

> +	reg->init.constraints.name = rpdata->regulator_name;
> +	reg->init.constraints.min_uv = rpdata->min_uv;
> +	reg->init.constraints.max_uv = rpdata->max_uv;
> +	reg->init.constraints.valid_ops_mask = rpdata->valid_ops_mask;
> +	reg->init.constraints.valid_modes_mask = rpdata->valid_modes_mask;
> +	reg->init.constraints.boot_on = rpdata->boot_on;
> +	reg->init.constraints.always_on = rpdata->always_on;
> +	reg->init.num_consumer_supplies = rpdata->num_consumer_supplies;
> +	reg->init.consumer_supplies = rpdata->consumer_supplies;

Just embed a regulator_init_data or pointer to one in the platform data,
the driver should not need to care about the contents - think what
happens if we add new features to the API...
