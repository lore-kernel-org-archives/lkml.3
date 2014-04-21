Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDUTTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 15:19:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDUTTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 15:19:52 -0400
Message-ID: <53556EB2.80503@ti.com>
Date: Mon, 21 Apr 2014 15:17:06 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Gregory_Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>
Subject: Re: [PATCH v2 0/7] of: setup dma parameters using dma-ranges and
 dma-coherent
References: <1397917972-6293-1-git-send-email-santosh.shilimkar@ti.com>	<20140419182528.414b9b2e@skate>	<53551E9D.9080107@ti.com> <20140421201911.10783191@skate>
In-Reply-To: <20140421201911.10783191@skate>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2014 02:19 PM, Thomas Petazzoni wrote:
> Dear Santosh Shilimkar,
> 
> On Mon, 21 Apr 2014 09:35:25 -0400, Santosh Shilimkar wrote:
> 
>>> In mach-mvebu, what we do is that we register a bus notifier on the
>>> platform bus, so that we can set our custom DMA operations for all
>>> platform devices in the system. Should this be done in a different way
>>> after your series?
>>>
>> Nope. Since you have a very custom SOC specific case, you can continue
>> what you are doing.
> 
> True, but as you said, the goal is to remove machine code. So instead
> of having just a 'dma-coherent' property, shouldn't we have a
> dma-method property, which could be dma-method = "coherent" or
> dma-method = "marvell,io-coherent" and therefore allow the DT binding
> to cover more use cases than just the default non-coherent and coherent
> DMA operations?
> 
Please remember the infrastructure we are adding is not really for machines
(sub arch's) but for architectures. I don't think its worth adding methods
The whole reason of dma_ops being exported is take care of cases like yours
so we are just fine with that. If we see more cases likes your, we can
think about that.

regards,
Santosh

