Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaGaMpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:45:00 -0400
Received: from smtp-out-062.synserver.de ([212.40.185.62]:1058 "EHLO
	smtp-out-057.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751255AbaGaMo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:44:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7330
Message-ID: <53DA3A48.8070900@metafoo.de>
Date: Thu, 31 Jul 2014 14:44:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
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
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com> <20140730160607.GM8181@intel.com> <20140731074440.GY3952@lukather>
In-Reply-To: <20140731074440.GY3952@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 09:44 AM, Maxime Ripard wrote:
[...]
>    - Having to set device_slave_caps or not?

Yes. This should in my opinion be mandatory for new drivers. One of the 
issues with the DMAengine API is that it is really hard to write generic 
drivers that do not already know about the capabilities of the DMA 
controller. E.g. if you have a peripheral that is used on SoC A it assumes 
that the DMA controller it is connected to has the capabilities of the DMA 
controller in SoC A. If the same peripheral is now used on SoC B with a DMA 
controller with different capabilities this often ends up with ugly ifdefery 
in the peripheral driver. The peripheral driver shouldn't have to know which 
specific DMA controller it is connected to (It's a bit as if a GPIO consumer 
needed to know which GPIO controller is connected to). We got away with the 
current approach since there is not that much diversity in the mixing of 
peripherals and DMA controllers (each vendor pretty has their own DMA 
controller which it uses for their own peripherals). But with more recent 
code consolidation we are on a path to generic DMA support within subsystem 
frameworks (there is generic DMA support for audio, there is generic DMA 
support for SPI and I also have a (currently) out of tree patch for generic 
DMA support for IIO). Also these generic drivers need to be able to discover 
the capabilities of the DMA controller to be able to make the right decisions.

- Lars
