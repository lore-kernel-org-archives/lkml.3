Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3GVVsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:48:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53692 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab3GVVr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:47:59 -0400
Message-ID: <51EDA80F.7060606@ti.com>
Date: Mon, 22 Jul 2013 16:45:51 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] dmaengine: add dma_get_slave_sg_limits()
References: <1374166001-31340-1-git-send-email-joelf@ti.com> <1374166001-31340-2-git-send-email-joelf@ti.com> <20130718161658.GW16653@intel.com>
In-Reply-To: <20130718161658.GW16653@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:16 AM, Vinod Koul wrote:> On Thu, Jul 18, 2013 at
11:46:39AM -0500, Joel Fernandes wrote:
>> From: Matt Porter <mporter@ti.com>
>>
>> Add a dmaengine API to retrieve slave SG transfer limits.
>>
>> The API is optionally implemented by dmaengine drivers and when
>> unimplemented will return a NULL pointer. A client driver using
>> this API provides the required dma channel, address width, and
>> burst size of the transfer. dma_get_slave_sg_limits() returns an
>> SG limits structure with the maximum number and size of SG segments
>> that the given channel can handle.
> Hi Joel,
>
> I have already resurrected this and generalized the API to get the slave
> capablities.
> https://lkml.org/lkml/2013/7/15/147

Hi Vinod,

get_caps and get_sg_limits are 2 different things, looks like this was
already discussed earlier, and this patch series is a separate API that
adds support for SG limits.

Infact, you can already see here that he changed the name of the
function from caps to dma_get_slave_sg_limits:
http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2013-March/026601.html

Considering this, what is the way forward? Can this patch series be
merged as it is a different API as discussed above?

Summarizing:
* get_caps API cannot be used for this same purpose, as get_caps is done
_before_ the DMA channel can be configured from what it looks like:
* get_sg_limits, on the other hand is supposed to already have the
parameters required for configuring the DMA channel before hand.

Are there any other changes to the get_sg_limits series you would like
before it can be applied? Any other suggestions?

Thanks,

-Joel

