Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3GULI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 07:08:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60403 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab3GULIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 07:08:22 -0400
Message-ID: <51EBC0F5.70601@ti.com>
Date: Sun, 21 Jul 2013 16:37:33 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <20130720220006.GA7977@kroah.com> <Pine.LNX.4.44L0.1307202223430.8250-100000@netrider.rowland.org> <20130721025910.GA23043@kroah.com> <3839600.WiC1OLF35o@flatron>
In-Reply-To: <3839600.WiC1OLF35o@flatron>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 21 July 2013 04:01 PM, Tomasz Figa wrote:
> Hi,
>
> On Saturday 20 of July 2013 19:59:10 Greg KH wrote:
>> On Sat, Jul 20, 2013 at 10:32:26PM -0400, Alan Stern wrote:
>>> On Sat, 20 Jul 2013, Greg KH wrote:
>>>>>>> That should be passed using platform data.
>>>>>>
>>>>>> Ick, don't pass strings around, pass pointers.  If you have
>>>>>> platform
>>>>>> data you can get to, then put the pointer there, don't use a
>>>>>> "name".
>>>>>
>>>>> I don't think I understood you here :-s We wont have phy pointer
>>>>> when we create the device for the controller no?(it'll be done in
>>>>> board file). Probably I'm missing something.
>>>>
>>>> Why will you not have that pointer?  You can't rely on the "name" as
>>>> the device id will not match up, so you should be able to rely on
>>>> the pointer being in the structure that the board sets up, right?
>>>>
>>>> Don't use names, especially as ids can, and will, change, that is
>>>> going
>>>> to cause big problems.  Use pointers, this is C, we are supposed to
>>>> be
>>>> doing that :)
>>>
>>> Kishon, I think what Greg means is this:  The name you are using must
>>> be stored somewhere in a data structure constructed by the board file,
>>> right?  Or at least, associated with some data structure somehow.
>>> Otherwise the platform code wouldn't know which PHY hardware
>>> corresponded to a particular name.
>>>
>>> Greg's suggestion is that you store the address of that data structure
>>> in the platform data instead of storing the name string.  Have the
>>> consumer pass the data structure's address when it calls phy_create,
>>> instead of passing the name.  Then you don't have to worry about two
>>> PHYs accidentally ending up with the same name or any other similar
>>> problems.
>>
>> Close, but the issue is that whatever returns from phy_create() should
>> then be used, no need to call any "find" functions, as you can just use
>> the pointer that phy_create() returns.  Much like all other class api
>> functions in the kernel work.
>
> I think there is a confusion here about who registers the PHYs.
>
> All platform code does is registering a platform/i2c/whatever device,
> which causes a driver (located in drivers/phy/) to be instantiated. Such
> drivers call phy_create(), usually in their probe() callbacks, so
> platform_code has no way (and should have no way, for the sake of
> layering) to get what phy_create() returns.

right.
>
> IMHO we need a lookup method for PHYs, just like for clocks, regulators,
> PWMs or even i2c busses because there are complex cases when passing just
> a name using platform data will not work. I would second what Stephen said
> [1] and define a structure doing things in a DT-like way.
>
> Example;
>
> [platform code]
>
> static const struct phy_lookup my_phy_lookup[] = {
> 	PHY_LOOKUP("s3c-hsotg.0", "otg", "samsung-usbphy.1", "phy.2"),

The only problem here is that if *PLATFORM_DEVID_AUTO* is used while 
creating the device, the ids in the device name would change and 
PHY_LOOKUP wont be useful.

Thanks
Kishon
