Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3BEPiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:38:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60936 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab3BEPh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:37:59 -0500
Message-ID: <51112749.10603@ti.com>
Date: Tue, 5 Feb 2013 10:37:45 -0500
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <balbi@ti.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        "Nair, Sandeep" <sandeep_n@ti.com>, Chris Ball <cjb@laptop.org>,
        Matt Porter <mporter@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <510C2A47.1090607@mvista.com> <20130204203358.GX4720@opensource.wolfsonmicro.com> <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com> <201302042147.38407.arnd@arndb.de> <20130205123828.GB17852@n2100.arm.linux.org.uk>
In-Reply-To: <20130205123828.GB17852@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 07:38 AM, Russell King - ARM Linux wrote:
> On Mon, Feb 04, 2013 at 09:47:38PM +0000, Arnd Bergmann wrote:
>> On Monday 04 February 2013, Linus Walleij wrote:
>>> So I think the above concerns are moot. The callback we can
>>> set on cookies is entirely optional, and it's even implemented by
>>> each DMA engine, and some may not even support it but require
>>> polling, and then it won't even be implemented by the driver.
>>
>> Just to ensure that everybody is talking about the same thing here:
>> Is it just the callback that is optional, or also the interrupt
>> coming from the hardware?
>
> If everyone implements stuff correctly, both.  The callback most certainly
> is optional as things stand.  The interrupt - that depends on the DMA
> engine.
>
> Some DMA engines you can't avoid it because you need to reprogram the
> hardware with the next+1 transfer upon completion of an existing transfer.
> Others may allow you to chain transfers in hardware.  That's all up to
> how the DMA engine driver is implemented and how the hardware behaves.
>
> Now, there's another problem here: that is, people abuse the API.  People
> don't pass DMA_CTRL_ACK | DMA_PREP_INTERRUPT into their operations by
> default.  People like typing '0'.
>
> The intention of the "DMA_PREP_INTERRUPT" is significant here: it means
> "ask the hardware to send an interrupt upon completion of this transfer".
>
> Because soo many people like to type '0' instead in their DMA engine
> clients, it means that this flag is utterly useless today - you have to
> ignore it.  So there's _no_ way for client drivers to actually tell the
> a DMA engine driver which _doesn't_ need to signal interrupts at the end
> of every transfer not to do so.
>
> So yes, the DMA engine API supports it.  Whether the _implementations_
> themselves do is very much hit and miss (and in reality is much more
> miss than hit.)
>

Don't these assume that the driver can determine the need for an 
interrupt upfront at prep/submit time?  AFAICT, this assumption doesn't 
hold true with NAPI.

Thanks
-- Cyril.
