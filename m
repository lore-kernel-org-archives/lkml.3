Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaLJDb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:31:29 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:14851 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaLJDb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:31:27 -0500
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="52527429"
Message-ID: <5487BE86.30900@broadcom.com>
Date: Tue, 9 Dec 2014 19:31:18 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Scott Branden" <sbranden@broadcom.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] i2c: iproc: Add Broadcom iProc I2C Driver
References: <rjui@broadcom.com>	<1418172891-19441-1-git-send-email-rjui@broadcom.com>	<1418172891-19441-3-git-send-email-rjui@broadcom.com>	<5487A2D6.8070901@gmail.com>	<5487A4C9.2000604@broadcom.com>	<CAEUmHyZ+VqjzL4LkQozGJtnictPNXHYWM2qMKvD=LmfQdcT8iQ@mail.gmail.com> <CAEUmHyZ86r=7KzJzfE9_upv45vN7geW9woqMkaGaBPwfp3xbMQ@mail.gmail.com>
In-Reply-To: <CAEUmHyZ86r=7KzJzfE9_upv45vN7geW9woqMkaGaBPwfp3xbMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/9/2014 7:28 PM, Varka Bhadram wrote:
>
>
> On Wed, Dec 10, 2014 at 8:51 AM, Varka Bhadram <varkabhadram@gmail.com
> <mailto:varkabhadram@gmail.com>> wrote:
>
>     On Wed, Dec 10, 2014 at 7:11 AM, Ray Jui <rjui@broadcom.com
>     <mailto:rjui@broadcom.com>> wrote:
>
>
>
>         On 12/9/2014 5:33 PM, Varka Bhadram wrote:
>
>
>             On Wednesday 10 December 2014 06:24 AM, Ray Jui wrote:
>
>                 Add initial support to the Broadcom iProc I2C controller
>                 found in the
>                 iProc family of SoCs.
>
>                 The iProc I2C controller has separate internal TX and RX
>                 FIFOs, each has
>                 a size of 64 bytes. The iProc I2C controller supports
>                 two bus speeds
>                 including standard mode (100kHz) and fast mode (400kHz)
>
>                 Signed-off-by: Ray Jui <rjui@broadcom.com
>                 <mailto:rjui@broadcom.com>>
>                 Reviewed-by: Scott Branden <sbranden@broadcom.com
>                 <mailto:sbranden@broadcom.com>>
>                 ---
>                    drivers/i2c/busses/Kconfig         |    9 +
>                    drivers/i2c/busses/Makefile        |    1 +
>                    drivers/i2c/busses/i2c-bcm-iproc.c |  503
>                 ++++++++++++++++++++++++++++++++++++
>                    3 files changed, 513 insertions(+)
>                    create mode 100644 drivers/i2c/busses/i2c-bcm-iproc.c
>
>     (...)
>
>                 +static int bcm_iproc_i2c_probe(struct platform_device
>                 *pdev)
>                 +{
>                 +    int irq, ret = 0;
>                 +    struct bcm_iproc_i2c_dev *dev;
>                 +    struct i2c_adapter *adap;
>                 +    struct resource *res;
>                 +
>                 +    dev = devm_kzalloc(&pdev->dev, sizeof(*dev),
>                 GFP_KERNEL);
>                 +    if (!dev)
>                 +        return -ENOMEM;
>                 +
>                 +    platform_set_drvdata(pdev, dev);
>                 +    dev->device = &pdev->dev;
>                 +    init_completion(&dev->done);
>                 +
>                 +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>                 +    if (!res)
>                 +        return -ENODEV;
>
>
>             We can remove this resource check. This checking will happen
>             with
>             devm_ioremap_resource()
>
>         Don't you need to obtain a valid resource and pass it into
>         devm_ioremap_resource? Without 'res' being assigned a valid
>         resource, devm_ioremap_resource will reject with "invalid resource".
>
>     platform_get_resource() will return a resource, checking on this
>     resource is happening at
>     http://lxr.free-electrons.com/source/lib/devres.c#L115. So no need
>     to check it explicitly.
>
>     If you check here it will be duplication of check with resource. Two
>     times we are checking on
>     the resource. No point of doing like that.
>
>     Thanks.
Sorry I misunderstood what you meant. Okay I'll get rid of if (!res) 
check there. Thanks.

>
>
> See this: http://lxr.free-electrons.com/source/lib/devres.c#L102
>
> --
> Thanks and Regards,
> Varka Bhadram.
