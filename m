Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab3GWQ3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:29:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45574 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:29:35 -0400
Message-ID: <51EEAF32.4040905@ti.com>
Date: Tue, 23 Jul 2013 21:58:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <broonie@kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org> <51EE9EC0.6060905@ti.com> <20130723161846.GD2486@kroah.com>
In-Reply-To: <20130723161846.GD2486@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday 23 July 2013 09:48 PM, Greg KH wrote:
> On Tue, Jul 23, 2013 at 08:48:24PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 23 July 2013 08:07 PM, Alan Stern wrote:
>>> On Tue, 23 Jul 2013, Tomasz Figa wrote:
>>>
>>>> On Tuesday 23 of July 2013 09:29:32 Tomasz Figa wrote:
>>>>> Hi Alan,
>>>
>>> Thanks for helping to clarify the issues here.
>>>
>>>>>> Okay.  Are PHYs _always_ platform devices?
>>>>>
>>>>> They can be i2c, spi or any other device types as well.
>>>
>>> In those other cases, presumably there is no platform data associated
>>> with the PHY since it isn't a platform device.  Then how does the
>>> kernel know which controller is attached to the PHY?  Is this spelled
>>> out in platform data associated with the PHY's i2c/spi/whatever parent?
.
.
<snip>
.
.
>>
>> 	static struct phy *phy_lookup(void *priv) {
>> 		.
>> 		.
>> 		if (phy->priv==priv) //instead of string comparison, we'll use pointer
>> 			return phy;
>> 	}
>>
>> PHY driver should be like
>> 	phy_create((dev, ops, pdata->info);
>>
>> The controller driver would do
>> 	phy_get(dev, NULL, pdata->info);
>>
>> Now the PHY framework will check for a match of *priv* pointer and return the PHY.
>>
>> I think this should be possible?
> 
> Ick, no.  Why can't you just pass the pointer to the phy itself?  If you
> had a "priv" pointer to search from, then you could have just passed the
> original phy pointer in the first place, right?
> 
> The issue is that a string "name" is not going to scale at all, as it
> requires hard-coded information that will change over time (as the
> existing clock interface is already showing.)
> 
> Please just pass the real "phy" pointer around, that's what it is there
> for.  Your "board binding" logic/code should be able to handle this, as
> it somehow was going to do the same thing with a "name".

The problem is the board file won't have the *phy* pointer. *phy* pointer is
created at a much later time when the phy driver is probed.

Thanks
Kishon
