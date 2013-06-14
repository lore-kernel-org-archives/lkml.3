Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3FNJWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:22:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34140 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3FNJWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:22:12 -0400
Message-ID: <51BAE097.2020609@ti.com>
Date: Fri, 14 Jun 2013 14:51:27 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1368796954-3499-1-git-send-email-kishon@ti.com> <51A43E0A.8090201@ti.com> <51B9C3B6.1080707@ti.com> <51BAABB0.5060107@ti.com> <20130614054720.GL8164@atomide.com> <51BAB9EA.5090805@ti.com> <20130614073314.GA20992@atomide.com> <51BAD181.3020902@ti.com>
In-Reply-To: <51BAD181.3020902@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 14 June 2013 01:47 PM, Tomi Valkeinen wrote:
> On 14/06/13 10:33, Tony Lindgren wrote:
>
>> If we want to fix something this late in the merge window, the patches
>> must have a clear description what caused the regression and what happens
>> without the patches. These patches don't have that. And they are marked
>> RFC also. So actually I'm not applying any of them before the regression
>> descriptions are there and the patches have been reposted without RFC
>> and have sufficient acks from people.

I posted this as RFC since this series uses _label_ and initially Felipe 
din't want to find PHYs by _label_.
After the device names are created using PLATFORM_DEVID_AUTO, our 
original method of binding by device names doesn't work reliable (since 
the device name changes). And I couldn't think of any other way to find 
the PHY other than using _label_. So I just wanted to know if it's ok to 
use _label_ or if there is any other better way to find PHYs.

>
> No disagreement there.
>
> Kishon, I tested the patches on top of v3.10-rc5, booting with nfs root
> via usb gadget eth:
>
> Overo: works
> Beagle: works, but I need to reconnect the usb cable after kernel is up
> Beagle-xm: doesn't work. The cable is detected correctly, though
> Panda: works
>
> The problems with Beagles are there even without these patches, so they
> do make things better (fix Overo).

Thanks for testing this. I'll post a new version removing RFC after 
Felipe ACKs it.

Thanks
Kishon
