Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCFKYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:24:53 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36186 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaCFKYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:24:48 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-03-53184cee1020
From: Kamil Debski <k.debski@samsung.com>
To: "'Anton Tikhomirov'" <av.tikhomirov@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com, yulgon.kim@samsung.com, p.paneri@samsung.com,
        jg1.han@samsung.com, galak@codeaurora.org, matt.porter@linaro.org,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu,
        sander@humilis.net
References: <1394033288-5551-1-git-send-email-k.debski@samsung.com>
 <1394033288-5551-4-git-send-email-k.debski@samsung.com>
 <005c01cf3915$c53476c0$4f9d6440$%tikhomirov@samsung.com>
In-reply-to: <005c01cf3915$c53476c0$4f9d6440$%tikhomirov@samsung.com>
Subject: RE: [PATCH v9 3/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Thu, 06 Mar 2014 11:24:44 +0100
Message-id: <193a01cf3926$4bef53f0$e3cdfbd0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac84h7VFDZ0Y6kzhQc2nfLU7hPJrnwAiULiAAAQU3TA=
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUhTYRzGe8/3hoPjaeqLFxoDKw01JehFRESSzoWGMLrxpuZcajg/dlQy
	oqagTqnNEsROUtm08iMXOs1lRk5RRNT5kRi5UWIMc2Ya0iiSPOxmd8/zvM/v+V+8DM4NEZFM
	UUmFzlCiKVZRcmL2cHo1/kcWVJ/90ChDnaNrJHoyOU8ii6+DRPUr4zRa7lgikevbXQrN1fqO
	7Nt2CrUtvMfQs+d1OHo16abRnOUzhe7XttJowd6IoQlfA4leekZp1PzXRSFb2zaB6nt/ksg0
	N06nK/ll8z2Md4humt/fseL8+uo7ij+covlHbj/gzfYewE+vvcH4XwNRObJceWq+rrioSmdI
	TLsqL5xZraPKbBE3hv0WwgjsXBOQMZA9Bz+Z+8iADocuj41qAnKGY7sAtB98AQFjxKBjfPfo
	hWEoNhb2eHgpV7L9AA5tioRkcNaKQ+PiGB4gRgB88MJDSISMzYQTe9elE8fZDOjy1mCSJtgY
	aH7swaSKgk2HS79xKVawodDfIpGyo804aHNMYwEdDQf7dnCpDtlTcONfvBQr2RQ4YqknAxUl
	dBu9ZDPgxKAlMWhJDFoSg5CngOgBYbpKbZmQV6BPThA0eqGypCBBW6ofAIGvPhgBXVMpTsAy
	QBWieH0pQs2RmiqhWu8EkMFVSoU9Cao5Rb6m+qbOUHrFUFmsE5wAY2SRRpCg8M0cXsuybq07
	wy/0z1q9rRWxK2HdMantNdYok9B+kpj0qf6MZZsWv945OL2Qv3f7co3tzH63UxnysWG7JcOf
	neOc/z7lSNwpV0dyxsG8YyngxGZ89u7E0K208s7k3LTzQuJDnB6u2uq76MXHNjK1cb2h+J7J
	vxsd5heXVIRQqEmKww2C5j/mvqrUyAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton, Kishon,

> From: Anton Tikhomirov [mailto:av.tikhomirov@samsung.com]
> Sent: Thursday, March 06, 2014 9:26 AM
> 
> Hi Kamil,
> 
> ...
> 
> > +| 3. Supporting SoCs
> > ++--------------------
> > +
> > +To support a new SoC a new file should be added to the drivers/phy
> > +directory. Each SoC's configuration is stored in an instance of the
> > +struct samsung_usb2_phy_config.
> > +
> > +struct samsung_usb2_phy_config {
> > +	const struct samsung_usb2_common_phy *phys;
> > +	unsigned int num_phys;
> > +	bool has_mode_switch;
> 
> You missed rate_to_clk here.

Thank you for spotting this.

Kishon: I am sorry that this omission was made. I am happy to send an
updated patchset. However, I want to give some time for any additional
comments. Do you think that we have for this? Is today evening ok with you?
> 
> > +};
> > +
> 
> ...
> 
> > diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-
> samsung-
> > usb2.c new file mode 100644 index 0000000..c3b7719
> > --- /dev/null
> > +++ b/drivers/phy/phy-samsung-usb2.c
> > @@ -0,0 +1,222 @@
> > +/*
> > + * Samsung SoC USB 1.1/2.0 PHY driver
> > + *
> > + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > + * Author: Kamil Debski <k.debski@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/spinlock.h>
> > +#include "phy-samsung-usb2.h"
> > +
> > +static int samsung_usb2_phy_power_on(struct phy *phy) {
> > +	struct samsung_usb2_phy_instance *inst = phy_get_drvdata(phy);
> > +	struct samsung_usb2_phy_driver *drv = inst->drv;
> > +	int ret;
> > +
> > +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> > +		inst->cfg->label);
> > +	ret = clk_prepare_enable(drv->clk);
> 
> clk_prepare_enable() can sleep, and therefore doesn't allow
> samusng_usb2_phy_power_on() to be used in atomic context (e.g. inside
> spin_lock-ed area), what sometimes may be desirable.
> What about to prepare clock in probe, and just enable it here
> (note: clk_enable() doesn't sleep).

>From the onward discussion between you and Kishon, I draw the conclusion
that this change is not necessary. Right?

> 
> > +	if (ret)
> > +		goto err_main_clk;
> > +	ret = clk_prepare_enable(drv->ref_clk);
> > +	if (ret)
> > +		goto err_instance_clk;
> > +	if (inst->cfg->power_on) {
> > +		spin_lock(&drv->lock);
> > +		ret = inst->cfg->power_on(inst);
> > +		spin_unlock(&drv->lock);
> > +	}
> > +
> > +	return 0;
> 
> Thank you

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


