Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaAETFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 14:05:14 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:43836 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaAETFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 14:05:11 -0500
MIME-Version: 1.0
X-Originating-IP: [212.255.119.130]
In-Reply-To: <201401051952.07355.arnd@arndb.de>
References: <52C5A6A3.8000405@koalo.de>
	<201401051506.03481.arnd@arndb.de>
	<CABDT8WyUVbPu60qwMbAxKS=2m2akskybZQS3-+rehuUD+3oBXQ@mail.gmail.com>
	<201401051952.07355.arnd@arndb.de>
Date: Sun, 5 Jan 2014 20:05:10 +0100
Message-ID: <CABDT8Wx-jRKQYS+pvPcy7OVBvy_qSkqZmvEMmagT7dFisKmpCQ@mail.gmail.com>
Subject: Re: [PATCHv9] dmaengine: Add support for BCM2835
From: Florian Meier <florian.meier@koalo.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vinod Koul <vinod.koul@intel.com>,
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

On 05.01.2014 19:52, Arnd Bergmann wrote:
> On Sunday 05 January 2014, Florian Meier wrote:
>> On 05.01.2014 15:06, Arnd Bergmann wrote:
>>>>
>>>> Sigh, the API is developing faster than I can keep track with updating
>>>> this patch. I hope some day I will be faster....
>>>> When Russell told me about the second one before, it hoped that I can
>>>> avoid merging different trees on my own, but it seems that you want me
>>>> to do that ;-)
>>>
>>> The dma_get_any_slave_channel() change is probably my fault. I suggested
>>> both the initial dma_get_slave_channel() API and this one because the
>>> original approach turned out too complicated. If dma_set_mask_and_coherent().
>>>
>>> I don't think you have to merge other trees, to get both APIs, they should
>>> already be part of the dma-slave tree that your patch would get merged
>>> into. If not, we can probably come up with a different solution. The
>>> dma_set_mask_and_coherent() suggestion is not as important as the
>>> dma_get_any_slave_channel() one, if you have to choose between them.
>>
>> Both changes are in the slave-dma tree, but I need patches from the
>> bcm2835 tree and the asoc tree, too. Although, it shouldn't be too
>> complicated to merge them, I hope.
>
> Why do you need the bcm2835 and asoc changes? The addition of the
> dmaengine driver should be self-contained as far as I can tell,
> except that the audio driver won't work unless both are merged.
>
> This wouldn't be considered a strict dependency since you are not
> breaking anything that used to work prior to the patches, and you
> don't create a kernel version that doesn't build. Note that this
> would be different if you had a dependency on a platform_data
> definition.

You are right! I just have to merge them for testing the driver.
