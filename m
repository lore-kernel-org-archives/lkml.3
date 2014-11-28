Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaK1Ltl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:49:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43911 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaK1Ltj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:49:39 -0500
Message-ID: <5478611A.5060404@ti.com>
Date: Fri, 28 Nov 2014 13:48:42 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <vinod.koul@intel.com>, <linux-mmc@vger.kernel.org>, <nsekhar@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <khilman@deeprootsystems.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, <chris@printf.net>,
        <dmaengine@vger.kernel.org>, <ulf.hansson@linaro.org>,
        <linux-spi@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter
 function definition
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <4859328.eEV7jzKEaA@wuerfel> <54782148.6040108@ti.com> <6448422.mtUnef24Xp@wuerfel>
In-Reply-To: <6448422.mtUnef24Xp@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 12:51 PM, Arnd Bergmann wrote:
> On Friday 28 November 2014 09:16:24 Peter Ujfalusi wrote:
>> On 11/27/2014 11:52 PM, Arnd Bergmann wrote:
>>> On Thursday 27 November 2014 20:46:12 Peter Ujfalusi wrote:
>>>>
>>>> I see. With this series I did not planed to fix all edma related issues, just
>>>> as a start clean up the related header files. I would rather not add fixes to
>>>> mmc, spi, etc drivers since while you have valid point it is not in the scope
>>>> of this series.
>>>> Can we do the changes you are suggesting in an incremental manner?
>>>
>>> Sure, but I'd leave the existing filter function declaration alone then
>>> and not move it, since we wouldn't want to keep it in the long run.
>>
>> but if you want to reference the filter function (which is in
>> drivers/dma/edma.c) in arch/arm/mach-davinci/ directory, we will need it.
>> Don't we?
> 
> Yes, unless you move the definition of the filter function into
> arch/arm/common/edma.c or arch/arm/mach-davinci/devices.c, but that
> would require other changes.

At the end the aim is to get rid of the edma code form arch/arm and have only
dmaengine API towards eDMA. The ASoC davinci-pcm is the only user of the
legacy API AFAIK. It has a mode called ping-pong which is not possible with
the dmaeingine at all. This is to overcome underflow situations on parts where
the audio IP does not have FIFO.
My edma-pcm (which is using dmaengine) should be able to handle this
situation, but I need to verify it before I can remove the davinci-pcm and
then we can get rid of the direct eDMA API and code.

>> If I leave the header as it is, then how would we clean up the edma headers? I
>> would not put the API definitions for the arch code into the same file as we
>> have the filter definition.
> 
> Ok, just go ahead with your current patch then, we can always follow up.
> The most important cleanup for edma is elsewhere anyway, so once the asoc
> drivers can use the dmaengine interface, this should be easier.
> 
> 	Arnd
> 


-- 
Péter
