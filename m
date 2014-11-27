Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaK0SrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:47:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43769 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbaK0SrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:47:03 -0500
Message-ID: <54777174.4070203@ti.com>
Date: Thu, 27 Nov 2014 20:46:12 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <alsa-devel@alsa-project.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-mmc@vger.kernel.org>, <nsekhar@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <khilman@deeprootsystems.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, <chris@printf.net>,
        <dmaengine@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter
 function definition
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <8235185.7qUDHu9jso@wuerfel> <547733E3.3020408@ti.com> <3300340.ou8f7H2hIc@wuerfel>
In-Reply-To: <3300340.ou8f7H2hIc@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 04:50 PM, Arnd Bergmann wrote:
> On Thursday 27 November 2014 16:23:31 Peter Ujfalusi wrote:
>> This will only work in case of legacy boot. When booting with DT we do not
>> have pdata and after this patch in dt boot we are not going to be able to get
>> the DMA resources either.
> 
> No, when booting with DT, the filter_fn and data are not used at all,
> we get the dma channel by parsing the DT instead.

Correct.

>> I think if we want to do something like this, it has to be done within the
>> dmaengine framework. The dma controller's of_dma_filter_info already have
>> .filter_fn which could be used by the framework.
> 
> No, of_dma_filter_info/of_dma_simple_xlate was a mistake, we should never
> have even introduced that. All drivers that rely on this can simply
> provide their own xlate function that calls of_dma_get_slave_channel()
> or one of the related functions.
> 
> edma is particularly trivial, it can just use of_dma_xlate_by_chan_id()
> instead of of_dma_simple_xlate, as it looks up the channel by its number.

I see. With this series I did not planed to fix all edma related issues, just
as a start clean up the related header files. I would rather not add fixes to
mmc, spi, etc drivers since while you have valid point it is not in the scope
of this series.
Can we do the changes you are suggesting in an incremental manner?

-- 
Péter
