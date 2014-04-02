Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbaDBQEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:04:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58095 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758702AbaDBQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:04:40 -0400
Date: Wed, 2 Apr 2014 17:04:38 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: Get and put regulator of_node
Message-ID: <20140402160438.GO1665@opensource.wolfsonmicro.com>
References: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140402142356.GE2269@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402142356.GE2269@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 03:23:56PM +0100, Mark Brown wrote:
> On Wed, Apr 02, 2014 at 03:06:54PM +0100, Charles Keepax wrote:
> 
> > We should be incrementing the reference count of the of_node for the
> > regulator when we take a copy of it. This patch does so.
> 
> Why?
> 
> Note that in any case this is going to have absolutely no impact on
> practical systems since everything using regulators uses FDT at the
> minute.

Apologies I must be missing something, take for example the fixed
regulator driver (fixed.c). We get an of_node from
pdev->dev->of_node, pull the init_data from it, then copy the
of_node into the regulator_config and call regulator_register.
regulator_register will copy the of_node from the regulator_config
and put it into the new device, but as far as I can see no one ever
incremented the reference count?

	of_node = pdev->dev.of_node;

	drvdata->dev = regulator_register(&drvdata->desc, &cfg);

Looks like there are a couple of other regulator drivers in the
same boat. Just seems easier to let the core do the reference
stuff rather than needing to do it in the drivers.

Thanks,
Charles
