Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaBLLGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:06:52 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31992 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751167AbaBLLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:06:50 -0500
Message-ID: <1392203209.3380.57.camel@hornet>
Subject: Re: [PATCH 07/12] mfd: syscon: Consider platform data a regmap
 config name
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 12 Feb 2014 11:06:49 +0000
In-Reply-To: <20140212082657.GK15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-8-git-send-email-pawel.moll@arm.com>
	 <1392188982.914924525@f237.i.mail.ru> <20140212082657.GK15081@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 08:26 +0000, Lee Jones wrote:
> > > Use the device platform data as a regmap config
> > > name. This is particularly useful in the regmap
> > > debugfs when there is more than one syscon device
> > > registered, to distinguish the register blocks.
> > > 
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Cc: Lee Jones <lee.jones@linaro.org>
> > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > > ---
> > ...
> > > syscon_regmap_config.max_register = res->end - res->start - 3;
> > > +	syscon_regmap_config.name = dev_get_platdata(&pdev->dev);
> > 
> > Is dev_name(&pdev->dev) can be used for such purpose?
> 
> Yes of course.
> 
> Either use the automatically generated name or over-ride with
> dev->init_name prior to registration or call dev_set_name()
> manually. Then retrieve with Alexander's suggestion.
> 
> Is there any technical reason why this is not possible with your
> implementation?

Hold on, guys. Let me just point out that we're talking "non-DT"
platform devices here (either statically defined struct
platform_device-s or - my case - the MFD cells).

In this case device/driver matching relies completely on device name.
Either the pdev->name must be identical (strcmp) to pdrv->name, or the
pdev->name must be identical (strcmp again) to one of the pdev->id_table
entries. See platform_match() in driver/base/platform.c for more
details.

Therefore the dev_name(&pdev->dev) on a non-DT-originating sysconf
devince will always return "sysconf.*", unless you're ready to maintain
a growing syscon_ids[] list. If so, I will have to add three entries
there ("sys_id", "sys_misc" and "sys_procid"). I hope you are not
seriously considering this idea :-) After all that's what the
platform_data was invented for.

Pawel


