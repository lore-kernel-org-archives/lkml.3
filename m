Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaADP2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 10:28:03 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49827 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaADP16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 10:27:58 -0500
MIME-Version: 1.0
X-Originating-IP: [212.255.127.39]
In-Reply-To: <1964639.FVztRK0HBK@wuerfel>
References: <52C5A6A3.8000405@koalo.de>
	<1964639.FVztRK0HBK@wuerfel>
Date: Sat, 4 Jan 2014 16:27:57 +0100
Message-ID: <CABDT8WzhpH2yX=HD9wsx+bN17Qp0hLX45-VMF0a3RAiwWx7F4Q@mail.gmail.com>
Subject: Re: [PATCHv9] dmaengine: Add support for BCM2835
From: Florian Meier <florian.meier@koalo.de>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.01.2014 19:03, Arnd Bergmann wrote:
> On Thursday 02 January 2014 18:49:23 Florian Meier wrote:
>> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
>> Currently it only supports cyclic DMA.
>
> Looks very nice. Just a few details I noticed:
>
>> +#if defined(CONFIG_OF)
>> +static const struct of_device_id bcm2835_dma_of_match[] = {
>> + { .compatible = "brcm,bcm2835-dma", },
>> + {},
>> +};
>> +MODULE_DEVICE_TABLE(of, bcm2835_dma_of_match);
>> +#endif
>
> I doubt we are going to see non-DT versions of this driver, so the #ifdef
> can just get removed here.

As already explained in previous versions of this patch thread, there is
a non-DT version in a downstream kernel and the more I make this patch
incompatible with non-DT, the harder it gets to upstream the remaining
stuff. I hope this is not something that blocks this driver from getting
accepted.

> [...]
> This can now be simplified using the dma_get_any_slave_channel() interface
> taht Stephen Warren introduced.
> [...]
> dma_set_mask_and_coherent()

Sigh, the API is developing faster than I can keep track with updating
this patch. I hope some day I will be faster....
When Russell told me about the second one before, it hoped that I can
avoid merging different trees on my own, but it seems that you want me
to do that ;-)

>> + if (pdev->dev.of_node) {
>> + /* Device-tree DMA controller registration */
>> + rc = of_dma_controller_register(pdev->dev.of_node,
>> + bcm2835_dma_xlate, od);
>> + if (rc) {
>> + dev_err(&pdev->dev, "Failed to register DMA controller\n");
>> + goto err_no_dma;
>> + }
>> + }
>
> If pdev->dev.of_node isn't set, you didn't get here, so the if() can be removed.

Why not? (In the case of non-DT initialization)

Greetings,
Florian
