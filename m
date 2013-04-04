Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514Ab3DDFps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:45:48 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36339 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3DDFpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130403114935.GA11305@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
	<1363157014-9615-3-git-send-email-ks.giri@samsung.com>
	<20130401131207.GI18636@opensource.wolfsonmicro.com>
	<CAKrE-KdWe6aCg0p99BFEeQP-P2nwvdhs2itH3XnHsJMCUjWPAA@mail.gmail.com>
	<20130403114935.GA11305@opensource.wolfsonmicro.com>
Date: Thu, 4 Apr 2013 11:15:46 +0530
Message-ID: <CAKrE-Kc-QJ1ZkAZ1jYjRy+7V+6SuVk0oytfD8_vcp3ZWf6aSPQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/5] spi: s3c64xx: added support for polling mode
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 5:19 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Apr 03, 2013 at 05:00:04PM +0530, Girish KS wrote:
>> On Mon, Apr 1, 2013 at 6:42 PM, Mark Brown
>
>> >> -     if (!sdd->pdev->dev.of_node) {
>> >> +     if (!sdd->pdev->dev.of_node && !is_polling(sdd)) {
>> >>               res = platform_get_resource(pdev, IORESOURCE_DMA,  0);
>> >>               if (!res) {
>> >>                       dev_err(&pdev->dev, "Unable to get SPI tx dma "
>
>> > It seems like it'd be sensible to also handle failure to get the DMA
>> > resource by going into polling mode.
>
>> There are 2 cases currently i have identified and handled,
>> 1. The SoC's dont have DMA support for spi controller. For such SoC's we
>>  would not add the dma resource in the spi dts node. In this case the probe
>>  would return error if failure for DMA resuorce is handled.
>
> That's not what the code currently does...
>
>> 2. The SoC has a DMA support for SPI controller, but due to some x
>> reason(H/W bug),
>>  the driver would force polling mode by enabling
>> S3C64XX_SPI_QUIRK_POLL in driver
>>  data. For such SoC's there would be a dma entry in the spi controller
>> dts node, and
>>  probe can handle failure for DMA resource successfully.
>
>> To handle above both situations successfully if
>> (!sdd->pdev->dev.of_node && !is_polling(sdd)) is used.
>
> Right, that's what the code currently does but what I'm suggesting is
> that this isn't the most helpful thing to do and that printing a big
> warning then soldiering on in polling mode might be more useful.

Ok I got it. will do it.

Thanks Mark
