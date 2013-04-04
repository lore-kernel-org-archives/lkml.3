Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab3DDI5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:57:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34326 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab3DDI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:57:41 -0400
Message-ID: <515D4050.7090506@ti.com>
Date: Thu, 4 Apr 2013 14:26:48 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <swarren@wwwdotorg.org>, <sylvester.nawrocki@gmail.com>,
        <rob@landley.net>, <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <mchehab@redhat.com>, <santosh.shilimkar@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/6] drivers: phy: add generic PHY framework
References: <1364993634-6378-1-git-send-email-kishon@ti.com> <1364993634-6378-2-git-send-email-kishon@ti.com> <20130403134102.GC14680@arwen.pp.htv.fi> <515C3A42.4020404@ti.com> <20130403142747.GK14680@arwen.pp.htv.fi> <515C3D94.1060000@ti.com> <20130403154704.GD19093@arwen.pp.htv.fi>
In-Reply-To: <20130403154704.GD19093@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 03 April 2013 09:17 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Apr 03, 2013 at 08:02:52PM +0530, Kishon Vijay Abraham I wrote:
>>>>>> +		ret = -EINVAL;
>>>>>> +		goto err0;
>>>>>> +	}
>>>>>> +
>>>>>> +	if (!phy_class)
>>>>>> +		phy_core_init();
>>>>>
>>>>> why don't you setup the class on module_init ? Then this would be a
>>>>> terrible error condition here :-)
>>>>
>>>> This is for the case where the PHY driver gets loaded before the PHY
>>>> framework. I could have returned EPROBE_DEFER here instead I thought
>>>> will have it this way.
>>>
>>> looks a bit weird IMO. Is it really possible for PHY to load before ?
>>
>> yeah. it actually happened when I tried with beagle and had all the
>> modules as built-in. Because twl4030 has subsys_initcall(), it loads
>> before PHY framework.
>
> that's a bug in twl4030.

right. Will fix it.

Thanks
Kishon
