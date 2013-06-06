Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3FFKJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:09:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42398 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628Ab3FFKJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:09:08 -0400
Message-ID: <51B05FAE.60508@ti.com>
Date: Thu, 6 Jun 2013 13:08:46 +0300
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
        <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 1/2] spi: spi-omap2-mcspi.c: Add dts for slave device
 configuration.
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com> <1370432398-7796-2-git-send-email-illia.smyrnov@ti.com> <20130605115734.GY31367@sirena.org.uk>
In-Reply-To: <20130605115734.GY31367@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 02:57 PM, Mark Brown wrote:
> On Wed, Jun 05, 2013 at 02:39:57PM +0300, Illia Smyrnov wrote:
>
>> +SPI Controller specific data in SPI slave nodes:
>> +- The spi slave nodes can provide the following information which is used
>> +  by the spi controller:
>> +  - ti,spi-turbo-mode: Set turbo mode for this device.
>> +
>
> What is turb mode and

According to OMAP TRM [1] MCSPI turbo mode improves the throughput of 
the SPI interface when a single channel is enabled by allowing transfers 
until the shift register and the MCSPI_RXx register are full.

I tested turbo mode using KS8851 SPI Ethernet controller on Blaze with 
OMAP4460 and nuttcp tool with -r for RX throughput measuring. Enabling 
turbo mode was increased throughput form 7.5538 Mbps to 8.3848 Mbps

> why would we not want to just enable it all the
> time?

Turbo mode gives the expected results not for all cases. There are some 
limitations:
- works only if a single channel is enabled (no effect when several 
channels are enable);
- improves the throughput on RX direction only;
- effective only when a transfer exceeds two words. For single SPI
word transfers OMAP TRM [1] recommends deactivate turbo mode.

So it is useful to have the property in DT, that allow us to switch 
turbo mode off/on for certain slave.

> Based on this documentation it's not really possible to tell...
>
I will add turbo mode description to documentation in the next patch version

[1]: http://www.ti.com/lit/ug/swpu235z/swpu235z.pdf
