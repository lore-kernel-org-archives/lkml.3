Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbaGAJFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:05:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43925 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbaGAJFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:05:31 -0400
Date: Tue, 1 Jul 2014 10:05:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH resend v2 0/3]  mfd-core: Don't register supplies from
 add_device, add register_supply_aliases()
Message-ID: <20140701090524.GC27971@lee--X1>
References: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I already send this series before (in time for 3.16) and AFAIK we agreed
> on going with this series instead of the incomplete fix for the related oops
> which now has been merged as commit d137be00ee017bc40e6027cb66d667a2e0b450fd
> 
> I still believe that this series is the more correct fix, as platform
> devices must simply not be used at all before they have been added.

We were waiting for Mark's comments.  Which we still have to do.

As they never appeared the temporary fix went in instead.

Moving forward, should that fix be reverted, or it is okay just to
apply this set on top?

> This series changes the probe messages for the axp209 pmic regulators from:
> 
> [    1.386371] Adding alias for supply acin,(null) -> acin,0-0034
> [    1.392205] Adding alias for supply vin2,(null) -> vin2,0-0034
> [    1.398112] Adding alias for supply vin3,(null) -> vin3,0-0034
> [    1.403995] Adding alias for supply ldo24in,(null) -> ldo24in,0-0034
> [    1.410344] Adding alias for supply ldo3in,(null) -> ldo3in,0-0034
> [    1.416551] Adding alias for supply ldo5in,(null) -> ldo5in,0-0034
> 
> To:
> 
> [    1.410545] Adding alias for supply acin,axp20x-regulator -> acin,0-0034
> [    1.417288] Adding alias for supply vin2,axp20x-regulator -> vin2,0-0034
> [    1.424002] Adding alias for supply vin3,axp20x-regulator -> vin3,0-0034
> [    1.430695] Adding alias for supply ldo24in,axp20x-regulator -> ldo24in,0-003
> 4
> [    1.437922] Adding alias for supply ldo3in,axp20x-regulator -> ldo3in,0-0034
> [    1.444973] Adding alias for supply ldo5in,axp20x-regulator -> ldo5in,0-0034
> 
> Notice how all the "(null)" bits are gone.
> 
> No need to rush this into 3.16, but I would still like to see this merged
> into 3.17 .
> 
> Changes since v1:
> -Rebased on top of 3.16-rc1 / commit d137be00ee017bc40e6027cb66d667a2e0b450fd
> 
> Thanks & Regards,
> 
> Hans

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
