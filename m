Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3GIMc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:32:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36130 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab3GIMc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:32:57 -0400
Message-ID: <51DC02EB.8070905@ti.com>
Date: Tue, 9 Jul 2013 07:32:43 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com> <1373290980-17883-3-git-send-email-sourav.poddar@ti.com> <20130708203330.GA28322@kahuna> <20130709065143.GC5552@arwen.pp.htv.fi> <20130709100525.GR27646@sirena.org.uk>
In-Reply-To: <20130709100525.GR27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 05:05 AM, Mark Brown wrote:
> On Tue, Jul 09, 2013 at 09:51:43AM +0300, Felipe Balbi wrote:
>
>>> Looks like a case to use regmap?
>>> Dumb q: why cant we use regmap_spi? worst case, you should be able to
>
>> read regmap-spi and you'll see why it can't be used in this case.
>
>> regmap-spi is for SPI clients who want to read their register map
>> through SPI commands. This is a driver for the SPI master which has its
>> registers memory mapped.
>
> Indeed, regmap-spi would be a client of this driver.  Though there is
> regmap-mmio which may be helpful, on the other hand it's relatively
> heavyweight and SPI can be a bit performance sensitive so perhaps it's
> not awesome here.  Russell did mention the idea of some helpers along a
> similar style though, they may be a good idea but nobody wrote them yet.
>
Fair enough. I am starting to see at least a second driver (internally 
for DRA7 IRQ/DMA crossbar) doing the same handling for different bit 
sized registers. maybe now is the time for us to create a lighter 
version of mmio. mmio at least the last I looked uses spinlocks and is 
fairly fast. But, I agree, when the client of regmap uses locks to 
protect operations of their own, regmap might be a bit of an overhead. 
that said, replicating regmap logic in the driver looks a bit weird and 
might allow the basis for other drivers to do the same as well as some 
users of mmio would consider themselves performance sensitive :(.

-- 
Regards,
Nishanth Menon
