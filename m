Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaI2UCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:02:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44639 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaI2UCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:02:53 -0400
Message-ID: <5429BAD0.1050101@ti.com>
Date: Mon, 29 Sep 2014 16:02:24 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <sandeep_n@ti.com>, <joe@perches.com>
Subject: Re: [PATCH v5 2/3] net: Add Keystone NetCP ethernet driver
References: <1411667317-1163-1-git-send-email-santosh.shilimkar@ti.com>	<1411667317-1163-3-git-send-email-santosh.shilimkar@ti.com> <20140929.155200.2231132602322345812.davem@davemloft.net>
In-Reply-To: <20140929.155200.2231132602322345812.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 03:52 PM, David Miller wrote:
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Thu, 25 Sep 2014 13:48:36 -0400
> 
>> +static inline int gbe_phy_link_status(struct gbe_slave *slave)
>> +{
>> +	if (!slave->phy)
>> +		return 1;
>> +
>> +	if (slave->phy->link)
>> +		return 1;
>> +
>> +	return 0;
>> +}
> 
> Please use 'bool' as the return type and return 'true' or 'false'.
> 
ok

> Do not use 'inline' in foo.c files, let the compiler decide.  Please
> audit this entire submission for this problem.
>
ok.
 
>> +static int gbe_port_reset(struct gbe_slave *slave)
>> +{
>> +	u32 i, v;
>> +
>> +	/* Set the soft reset bit */
>> +	writel_relaxed(SOFT_RESET, GBE_REG_ADDR(slave, emac_regs, soft_reset));
> 
> This driver seems to use relaxed readl and writel for almost everything.
> 
> That absolutely cannot be right.  For example, here, you depend upon the
> ordering of this writel_relaxed() to reset the chip relative to the
> real_relaxed() you subsequently do to check ths bits.
> 
> I seriously think that *_relaxed() should only be done in very special
> circumstances where 1) the performance matters and 2) the validity of
> the usage has been put under a microscope and fully documented with huge
> comments above the *_relaxed() calls.
> 
> If you cannot reduce and properly document the really necessary *_relaxed()
> uses, just convert them all to non-_relaxed() for now.
> 
We can stick to non-*relaxed() versions. No problems here.

> I'm also warning you ahead of time that since nobody else seems to feel
> like reviewing this enormous submission, you are going to have to get used
> to me pushing back on these changes over and over for small things like
> coding style and structural/API issues until some reviews it on a higher
> level.
>
> I really don't want to apply this series until someone thinks seriously
> about the driver's design and the long term ramifications of having a
> driver like this in the tree with so many random TX etc. hooks.
> 
The driver has been on the list. Jamal and you have given your comments,
suggestion and we have incorporated that. What else we can do ?

We are badly missing mainline network driver support for the Keystone
and hence I request you to help here.

regards,
Santosh
