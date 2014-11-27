Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaK0NU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:20:27 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37975 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaK0NUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:20:25 -0500
MIME-Version: 1.0
In-Reply-To: <6741d995fbec801d795c5db481e39425bd912f8a.1415962281.git.michal.simek@xilinx.com>
References: <cover.1415962281.git.michal.simek@xilinx.com>
	<6741d995fbec801d795c5db481e39425bd912f8a.1415962281.git.michal.simek@xilinx.com>
Date: Thu, 27 Nov 2014 14:20:24 +0100
Message-ID: <CACRpkdbZ8Pwy=04dhJq5ONZ1B-SQK1f=eLZjjCDmV7UQ0aHduA@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] ARM: zynq: Add OCM controller driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 11:52 AM, Michal Simek <michal.simek@xilinx.com> wrote:

> The driver provide memory allocator which can
> be used by others drivers to allocate memory inside OCM.
> All location for 64kB blocks are supported

Allocation?

> and driver is trying to allocate the largest continuous
> block of memory.

Isn't all genalloc allocations continuous?

(...)
> +       zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
> +                                              ilog2(ZYNQ_OCMC_GRANULARITY),
> +                                              -1);

Do this:

#include <linux/sizes.h>

zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
                                       ilog2(SZ_64K),
                                       -1);

And get rid of the #define for ZYNQ_OCMC_GRANULARITY

Yours,
Linus Walleij
