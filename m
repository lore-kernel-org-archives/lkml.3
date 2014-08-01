Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaHAIAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:00:14 -0400
Received: from smtp-out-145.synserver.de ([212.40.185.145]:1093 "EHLO
	smtp-out-145.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHAIAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:00:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12499
Message-ID: <53DB490A.5040709@metafoo.de>
Date: Fri, 01 Aug 2014 10:00:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com> <20140730160607.GM8181@intel.com> <20140731074440.GY3952@lukather> <53DA3A48.8070900@metafoo.de> <20140731161331.GD3952@lukather> <53DA74B3.6060502@metafoo.de> <20140731173730.GH3952@lukather>
In-Reply-To: <20140731173730.GH3952@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 07:37 PM, Maxime Ripard wrote:
> On Thu, Jul 31, 2014 at 06:54:11PM +0200, Lars-Peter Clausen wrote:
>> On 07/31/2014 06:13 PM, Maxime Ripard wrote:
>> [...]
>>>  From what you're saying, and judging from the drivers that already
>>> implement it, can't it be moved directly to the framework itself ?
>>>
>>
>> What exactly do you mean by moving it directly to the framework? The
>> slave_caps API is part of the DMAengine framework.
>
> Not its implementation, which is defined by each and every driver,
> while the behaviour of device_slave_caps is rather generic.
>

Do you mean something like adding a dma_slave_caps struct field to the DMA 
channel that gets initialized when the channel is created and then remove 
the callback? That makes some sense.

I think the main reason why we use a callback right now is that in earlier 
revisions of the API it was possible to pass a slave_config and the result 
would be the capabilities of the DMA channel for this particular config. But 
this was dropped before the final version was merged upstream.

- Lars
