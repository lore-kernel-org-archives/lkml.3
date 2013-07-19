Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379Ab3GSIpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:45:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49059 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab3GSIpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:45:39 -0400
Message-ID: <51E8FC8E.7090302@ti.com>
Date: Fri, 19 Jul 2013 14:15:02 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <tony@atomide.com>, <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] usb: musb: fix USB enumeration issue in OMAP3
 platform
References: <1373282057-20181-1-git-send-email-kishon@ti.com> <51E4DFA6.2010501@ti.com> <20130716124227.GC15036@arwen.pp.htv.fi>
In-Reply-To: <20130716124227.GC15036@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Tuesday 16 July 2013 06:12 PM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jul 16, 2013 at 11:22:38AM +0530, Kishon Vijay Abraham I wrote:
>> Tony,
>>
>> On Monday 08 July 2013 04:44 PM, Kishon Vijay Abraham I wrote:
>>> This series fixes the USB enumeration issue caused because of the controller
>>> not able to get a reference to the PHY because of incorrect binding in the
>>> board file.
>>>
>>> In the case of non-dt boot, the platform specific initialization file
>>> (board file) will do usb_bind_phy that binds the usb controller with the
>>> PHY using device names. After the device names are created using 
>>> PLATFORM_DEVID_AUTO, our original method of binding by device names doesn't
>>> work reliably (since the device name changes). Hence the usb controller
>>> is made to use labels for getting the PHY.
>>>
>>> Here the PHY name is added in the plat data of USB controller device which
>>> should be used by the controller driver to get the PHY.
>>> Two new APIs usb_get_phy_by_name and devm_usb_get_phy_by_name are added to
>>> be used by the controller to get the PHY by name.
>>
>> You haven't picked this patch series?
> 
> yeah and now it's too much to send during the -rc series. Here's what we
> can do, we can to minimum fix for -rc series (patching the names again)

There are a lot of different boards available using OMAP3 and the device names
(PHY and MUSB) vary across each board (apparently). It will be difficult to
find the device names (for PHY and MUSB) for all the different boards available
(partly because of non-availability of all the boards) and test it.

Thanks
Kishon
