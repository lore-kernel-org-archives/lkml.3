Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3JGNmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:42:42 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42647 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3JGNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130807151316.GH28558@e106331-lin.cambridge.arm.com>
References: <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
	<1375792711-21853-1-git-send-email-jonas.jensen@gmail.com>
	<20130807151316.GH28558@e106331-lin.cambridge.arm.com>
Date: Mon, 7 Oct 2013 15:42:40 +0200
Message-ID: <CACmBeS0G=GVVZiTNEovq0PtfZrr-L7rskyGOrpY12=6fgesyWg@mail.gmail.com>
Subject: Re: [PATCH v8] dmaengine: Add MOXA ART DMA engine driver
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for the replies. Please have a look at v9.

On 7 August 2013 17:13, Mark Rutland <mark.rutland@arm.com> wrote:
>> +
>> +       ret = devm_request_irq(dev, irq, moxart_dma_interrupt, 0,
>> +                              "moxart-dma-engine", mdc);
>> +       if (ret) {
>> +               dev_err(dev, "devm_request_irq failed\n");
>
> Do you not need calls to of_dma_controller_free and
> dma_async_device_unregister here? I'm not all that familiar with the DMA
> API, so maybe you don't.

Yes. I see now, I should have moved both dma_async_device_register()
and of_dma_controller_register() to happen after devm_request_irq().
I'll include that in next version.

>> +static int moxart_remove(struct platform_device *pdev)
>> +{
>> +       struct moxart_dma_container *m = dev_get_drvdata(&pdev->dev);
>
> Similarly, do you not need to call of_dma_controller free here?

Yes, this is now done.


Best regards,
Jonas
