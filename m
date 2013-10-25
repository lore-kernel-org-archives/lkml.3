Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3JYXKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:10:14 -0400
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:34665 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3JYXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:10:12 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 19:10:12 EDT
Message-ID: <526AF842.4070006@jolla.com>
Date: Sat, 26 Oct 2013 02:01:22 +0300
From: Philippe De Swert <philippe.deswert@jolla.com>
Reply-To: philippe.deswert@jolla.com
Organization: Jolla Oy
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>,
        Philippe De Swert <philippe.deswert@jollamobile.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power:power_supply_syfs : Treat PROP_TYPE as a regular
 attribute first
References: <1376521798-16985-1-git-send-email-philippe.deswert@jollamobile.com> <20131025221504.GA31842@teo>
In-Reply-To: <20131025221504.GA31842@teo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/10/13 01:15, Anton Vorontsov wrote:
> On Thu, Aug 15, 2013 at 02:09:58AM +0300, Philippe De Swert wrote:
>> These days we often have USB powered devices. This means that often the
>> type is variable. Common examples are smartphones which can be charged
>> through a normal USB port on a PC/laptop, a dedicated charger, etc...
 >
> I would guess that a lot of userland code assumes that the type is fixed.
> We can't break this assumption. Plus I don't think we really need the
> changing types.

That is a fair assumption, but that does not work anymore with 
smartphones, GPS devices, tablets etc.. Moreover why is it the only 
property that would be fixed? Also we have the power supply name to 
identify it, and I expect most userland code uses that.

>> Userspace sometimes needs to behave differently based on the type of charger
>> connected to such devices.
>
> A system with several charger should either:
>
> 1. Register all of them (mains, usb, etc.) as a separate power supply
> device, and then use PROP_ONLINE to specify whether something is connected
> to the port or not.
> 2. Register only the charger type that is currently connected to the
> system.

I think I did not make myself very clear. Well there are actually no 
different chargers here. It is one USB charger input, however its 
properties are different depending on the actual connected "charger 
device/type". It is the same charging controller however when a usb 
cable is connected and power comes from a PC it is very different
from when it is a dedicated USB charger.

Constantly register/unregister the current "charger type" makes it very 
difficult to monitor. Having a separate power_supply device per possible 
connected charger type is pretty tedious. We are talking USB_DCP, 
USB_ACA, USB_CDP, USB already, and new ones probably in the future. Not 
to mention that at some point we would have to deal with OTG also were 
we might actually supply power. In any case a lot harder than having a 
changing type property.

One of the main reasons to monitor this is to have the device react 
differently depending on what gets plugged in. Pure charging when 
charger gets connected or mass-storage gadget mode, mtp, ... when a 
cable is connected. Or eventually switch to a totally different device 
mode to support things like terminal mode (in cars).

> This is how we've been doing things from the very start.

Well a number of upstream charging drivers and non-upstreamed android 
drivers already change the charger type  like for example the isp1704. 
The patch I proposed just changes the inconsistency with the charger 
type property as it is the only one that gets treated differently, to
avoid confusion with it.

But I am sure open to better ideas for handling this.

Thanks,

Philippe

