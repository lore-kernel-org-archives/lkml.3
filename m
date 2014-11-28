Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaK1PfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:35:06 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:64804 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK1PfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:35:04 -0500
MIME-Version: 1.0
In-Reply-To: <857cab03bd6445c59cc345349a00f67c@BL2FFO11FD010.protection.gbl>
References: <cover.1415962281.git.michal.simek@xilinx.com>
	<6741d995fbec801d795c5db481e39425bd912f8a.1415962281.git.michal.simek@xilinx.com>
	<CACRpkdbZ8Pwy=04dhJq5ONZ1B-SQK1f=eLZjjCDmV7UQ0aHduA@mail.gmail.com>
	<857cab03bd6445c59cc345349a00f67c@BL2FFO11FD010.protection.gbl>
Date: Fri, 28 Nov 2014 16:35:03 +0100
Message-ID: <CACRpkdbL=yOwjC7j=eacg9K2Mb3rwcKy3b0F8y2H9Nz8RsRRcg@mail.gmail.com>
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

On Thu, Nov 27, 2014 at 2:57 PM, Michal Simek <michal.simek@xilinx.com> wrote:
> On 11/27/2014 02:20 PM, Linus Walleij wrote:
>> On Fri, Nov 14, 2014 at 11:52 AM, Michal Simek <michal.simek@xilinx.com> wrote:

>> (...)
>>> +       zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
>>> +                                              ilog2(ZYNQ_OCMC_GRANULARITY),
>>> +                                              -1);
>>
>> Do this:
>>
>> #include <linux/sizes.h>
>>
>> zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
>>                                        ilog2(SZ_64K),
>>                                        -1);
>>
>> And get rid of the #define for ZYNQ_OCMC_GRANULARITY
>
> ilog2 from 32 is different to ilog2 from ilog2 from 0x10000.

Bah I misread the code, forget this comment.

Maybe it's more like I wanted

+#define ZYNQ_OCMC_BLOCK_SIZE   0x10000

To be replaced with SZ_64K

But it's a petty detail anyway.

> Do you have any opinion regarding calling zynq_slcr_get_ocm_config()?
>
> Is it better to expose slcr this interface to drivers?
> Or use regmap and read this value directly?

Depends on what provides that call. The pattern I usually follow
is to expose the mixed-registers range as a syscon device
using drivers/mfd/syscon.c and then use one of the methods from
<linux/mfd/syscon.h> to look up a reference to the regmap and
use it to access misc registers.

> Also I do read for CONFIG_SMP case jump trampoline size - maybe
> you can have better idea how this can be done.

No I have no clue about that... :(

Yours,
Linus Walleij
