Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3FQJD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:03:57 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:60523 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3FQJDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:03:55 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: Joe Perches <joe@perches.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v4] ethernet/arc/arc_emac - Add new driver
Thread-Topic: [PATCH v4] ethernet/arc/arc_emac - Add new driver
Thread-Index: AQHOagXe8tugec+MDUSro7F/hI5nuQ==
Date: Mon, 17 Jun 2013 09:03:50 +0000
Message-ID: <4881796E12491D4BB15146FE0209CE643F5EC000@DE02WEMBXB.internal.synopsys.com>
References: <1371327652-9368-1-git-send-email-abrodkin@synopsys.com>
	 <1371328671.2117.6.camel@joe-AO722>
	 <4881796E12491D4BB15146FE0209CE643F5E7779@DE02WEMBXB.internal.synopsys.com>
 <1371368491.2116.0.camel@joe-AO722>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 11:41 AM, Joe Perches wrote:
> On Sat, 2013-06-15 at 20:47 +0000, Alexey Brodkin wrote:
>> On 06/16/2013 12:37 AM, Joe Perches wrote:
>>> On Sun, 2013-06-16 at 00:20 +0400, Alexey Brodkin wrote:
> []
>>>> +static int arc_emac_rx(struct net_device *ndev, int budget)
>>> []
>>>> +		/* Prepare the BD for next cycle */
>>>> +		rx_buff->skb = netdev_alloc_skb_ip_align(ndev, buflen);
>>>> +		if (unlikely(!rx_buff->skb)) {
>>>> +			if (net_ratelimit())
>>>> +				netdev_err(ndev, "cannot allocate skb\n");
>>>
>>> Unnecessary OOM message, might as well remove it.
>>> rx_dropped gives the same info.
>>
>> With all those error messages I wanted to make life easier (especially
>> for me) if errors appear. User will immediately know where problem
>> happened. Indeed "rx_dropped" (when it is used only once in driver) may
>> show where issue happened, but if later at some point "rx_dropped" will
>> be incremented in other locations then user won't understand immediately
>> where error happened.
>
> Alloc errors emit a dump_stack() already so this is redundant.

Makes sense. Will remove this comment.

-Alexey
