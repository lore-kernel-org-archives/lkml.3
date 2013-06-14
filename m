Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3FNQQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:16:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab3FNQQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:16:35 -0400
Message-ID: <51BB41CC.9080403@ti.com>
Date: Fri, 14 Jun 2013 19:16:12 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] spi: omap2-mcspi: Add FIFO buffer support
References: <1370970556-11713-1-git-send-email-illia.smyrnov@ti.com> <1370970556-11713-3-git-send-email-illia.smyrnov@ti.com> <20130612154755.GJ1403@sirena.org.uk>
In-Reply-To: <20130612154755.GJ1403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/12/2013 06:47 PM, Mark Brown wrote:
> On Tue, Jun 11, 2013 at 08:09:15PM +0300, Illia Smyrnov wrote:
>> The MCSPI controller has a built-in FIFO buffer to unload the DMA or interrupt
>> handler and improve data throughput. This patch adds FIFO buffer support for SPI
>> transfers in DMA mode.
>
>> The FIFO could be enabled for SPI module by setting up the "ti,spi-fifo-enabled"
>> configuration parameter in DT.
>> If FIFO enabled, the largest possible FIFO buffer size will be calculated and
>> setup for each SPI transfer. Even if the FIFO is enabled in DT, it won't be used
>> for the SPI transfers when: calculated FIFO buffer size is less then 2 bytes or
>> the FIFO buffer size isn't multiple of the SPI word length.
>
> Why is the default to disable the FIFO?
>

I have changed this and sent v3 patches of the MCSPI FIFO support 
implementation. In this version driver set up the FIFO (if possible) for 
all the SPI transfers in DMA mode.
