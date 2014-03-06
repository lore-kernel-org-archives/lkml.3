Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaCFPrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:47:51 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753234AbaCFPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:47:49 -0500
Message-ID: <53189892.5090502@free-electrons.com>
Date: Thu, 06 Mar 2014 16:47:30 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
References: <1394107868-26094-1-git-send-email-gregory.clement@free-electrons.com> <20140306131429.GJ4780@lunn.ch> <5318779C.8030901@free-electrons.com> <20140306142117.GL4780@lunn.ch> <531886B4.2070002@free-electrons.com> <20140306144600.GM4780@lunn.ch> <53188B73.4000109@free-electrons.com>
In-Reply-To: <53188B73.4000109@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 15:51, Gregory CLEMENT wrote:
> On 06/03/2014 15:46, Andrew Lunn wrote:
>>>>>> I think you can use aliases to get the order correct, independent of
>>>>>> how you list them in DT. That should be a lot safer than assuming
>>>>>> things are instantiated from top to bottom.
>>>>>
>>>>> It sounds interesting, how would you do this?
>>>>
>>>> As there already is in armada-370-xp.dtsi
>>>>
>>>>         aliases {
>>>>                 eth0 = &eth0;
>>>>                 eth1 = &eth1;
>>>>         };
>>>>
>>>>
>>>> 	eth0: ethernet@70000 {
>>>> 	}
>>>>         eth1: ethernet@74000 {
>>>> 	}
>>>>
>>>> This at least works for i2c devices. The pdev->id is set using the
>>>> alias number.
>>>
>>> Well I think it doesn't work with ethernet devices because we already do
>>> this in aramda-38x.dtsi:
>>>
>>> 	aliases {
>>> 		gpio0 = &gpio0;
>>> 		gpio1 = &gpio1;
>>> 		eth0 = &eth0;
>>> 		eth1 = &eth1;
>>> 		eth2 = &eth2;
>>> 	};
>>>
>>> 	eth1: ethernet@30000 {
>>> 	}
>>> 	eth2: ethernet@34000 {
>>> 	}
>>> 	eth0: ethernet@70000 {
>>> 	}
>>
>> Ah, Erm, O.K. 
>>
>> It seems to be an i2c thing. Take a look at i2c_add_adapter().
>>
>>         if (dev->of_node) {
>>                 id = of_alias_get_id(dev->of_node, "i2c");
>>  
>> You could put something similar into the ethernet driver.
>>
> 
> 
> Actually even what I did, didn't work as I expected. The order should have been changed in
> the dsi file.
> 
> I will have a look on the ethernet driver.

Well the naming is done in __dev_alloc_name() and it depends on
the probe order.

So I really wonder if we should not put the ethernet@70000 before the othe
Ethernet node in the armada-38x.dts file. Otherwise it is very misleading to
have eth0 for the second interface, eth1 for the third one, and eth2 for
the first one.


Thanks,

Gregory

> 
> 
> Thanks,
> 
> Gregory
> 
> 
>>     Andrew
>>
> 
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
