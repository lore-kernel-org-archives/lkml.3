Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaBLI1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:27:22 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33524 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaBLI1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:27:04 -0500
Date: Wed, 12 Feb 2014 08:26:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Pawel Moll <pawel.moll@arm.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 07/12] mfd: syscon: Consider platform data a regmap
 config name
Message-ID: <20140212082657.GK15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
 <1392188982.914924525@f237.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392188982.914924525@f237.i.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Use the device platform data as a regmap config
> > name. This is particularly useful in the regmap
> > debugfs when there is more than one syscon device
> > registered, to distinguish the register blocks.
> > 
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> ...
> > syscon_regmap_config.max_register = res->end - res->start - 3;
> > +	syscon_regmap_config.name = dev_get_platdata(&pdev->dev);
> 
> Is dev_name(&pdev->dev) can be used for such purpose?

Yes of course.

Either use the automatically generated name or over-ride with
dev->init_name prior to registration or call dev_set_name()
manually. Then retrieve with Alexander's suggestion.

Is there any technical reason why this is not possible with your
implementation?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
