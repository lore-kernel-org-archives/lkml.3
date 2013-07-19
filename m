Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab3GSF4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:56:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41851 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3GSF41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:56:27 -0400
Message-ID: <51E8D4E0.8060200@ti.com>
Date: Fri, 19 Jul 2013 11:25:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <kyungmin.park@samsung.com>, <balbi@ti.com>, <jg1.han@samsung.com>,
        <s.nawrocki@samsung.com>, <kgene.kim@samsung.com>,
        <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <1374129984-765-1-git-send-email-kishon@ti.com> <1374129984-765-2-git-send-email-kishon@ti.com> <20130718072004.GA16720@kroah.com> <51E7AE88.3050007@ti.com> <20130718154954.GA31961@kroah.com> <51E8D086.809@ti.com> <20130719054311.GA14638@kroah.com>
In-Reply-To: <20130719054311.GA14638@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 19 July 2013 11:13 AM, Greg KH wrote:
> On Fri, Jul 19, 2013 at 11:07:10AM +0530, Kishon Vijay Abraham I wrote:
>>>>>> +	ret = dev_set_name(&phy->dev, "%s.%d", dev_name(dev), id);
>>>>>
>>>>> Your naming is odd, no "phy" anywhere in it?  You rely on the sender to
>>>>> never send a duplicate name.id pair?  Why not create your own ids based
>>>>> on the number of phys in the system, like almost all other classes and
>>>>> subsystems do?
>>>>
>>>> hmm.. some PHY drivers use the id they provide to perform some of their
>>>> internal operation as in [1] (This is used only if a single PHY provider
>>>> implements multiple PHYS). Probably I'll add an option like PLATFORM_DEVID_AUTO
>>>> to give the PHY drivers an option to use auto id.
>>>>
>>>> [1] ->
>>>> http://archive.arm.linux.org.uk/lurker/message/20130628.134308.4a8f7668.ca.html
>>>
>>> No, who cares about the id?  No one outside of the phy core ever should,
>>> because you pass back the only pointer that they really do care about,
>>> if they need to do anything with the device.  Use that, and then you can
>>
>> hmm.. ok.
>>
>>> rip out all of the "search for a phy by a string" logic, as that's not
>>
>> Actually this is needed for non-dt boot case. In the case of dt boot, we use a
>> phandle by which the controller can get a reference to the phy. But in the case
>> of non-dt boot, the controller can get a reference to the phy only by label.
> 
> I don't understand.  They registered the phy, and got back a pointer to
> it.  Why can't they save it in their local structure to use it again
> later if needed?  They should never have to "ask" for the device, as the

One is a *PHY provider* driver which is a driver for some PHY device. This will
use phy_create to create the phy.
The other is a *PHY consumer* driver which might be any controller driver (can
be USB/SATA/PCIE). The PHY consumer will use phy_get to get a reference to the
phy (by *phandle* in the case of dt boot and *label* in the case of non-dt boot).
> device id might be unknown if there are multiple devices in the system.

I agree with you on the device id part. That need not be known to the PHY driver.

Thanks
Kishon
