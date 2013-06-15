Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3FOUrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:47:36 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:38596 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3FOUra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:47:30 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Joe Perches <joe@perches.com>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v4] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH v4] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHOagXe8tugec+MDUSro7F/hI5nuQ==
Date: Sat, 15 Jun 2013 20:47:25 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5E7779@DE02WEMBXB.internal.synopsys.com>
References: <1371327652-9368-1-git-send-email-abrodkin@synopsys.com>
 <1371328671.2117.6.camel@joe-AO722>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.225.15.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 12:37 AM, Joe Perches wrote:
> On Sun, 2013-06-16 at 00:20 +0400, Alexey Brodkin wrote:
>> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
>> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
>> ARCAngel4/ML50x.
>
>> diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
> []
>> +		if (DUPLEX_FULL == phy_dev->duplex)
>
> Most all kernel code uses "if (var == constant)"
> as that's how most people think.

Makes sense.

> []
>
>> +static int arc_emac_rx(struct net_device *ndev, int budget)
> []
>> +		/* Prepare the BD for next cycle */
>> +		rx_buff->skb = netdev_alloc_skb_ip_align(ndev, buflen);
>> +		if (unlikely(!rx_buff->skb)) {
>> +			if (net_ratelimit())
>> +				netdev_err(ndev, "cannot allocate skb\n");
>
> Unnecessary OOM message, might as well remove it.
> rx_dropped gives the same info.

With all those error messages I wanted to make life easier (especially 
for me) if errors appear. User will immediately know where problem 
happened. Indeed "rx_dropped" (when it is used only once in driver) may 
show where issue happened, but if later at some point "rx_dropped" will 
be incremented in other locations then user won't understand immediately 
where error happened.

-Alexey
