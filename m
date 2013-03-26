Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3CZUD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:03:27 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63382 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CZUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:03:25 -0400
Message-ID: <5151FD60.8090703@openwrt.org>
Date: Tue, 26 Mar 2013 20:56:16 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] USB: drop depends on USB and enclose everything
 into an if USB block
References: <Pine.LNX.4.44L0.1303261456400.999-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303261456400.999-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/03/2013 20:04, Alan Stern a écrit :
> On Tue, 26 Mar 2013, Florian Fainelli wrote:
>
>> This patch removes the depends on USB from all config symbols in
>> drivers/usb/host/Kconfig and replace that with an if USB / endif block
>> as suggested by Alan Stern.
>
> I'm afraid this patch is filled with errors.

Which is the reason why I stated this was a RFC, I did not meant to get 
it good for everything from the first try.

>
> For one thing, it doesn't appreciate the difference between host-side
> USB and device-side USB.  CONFIG_USB describes support for the
> host-side part of the stack, whereas CONFIG_USB_GADGET describes
> support for the device-side (or gadget-side) part.  This means you must
> not make things like drivers/usb/gadget/Kconfig dependent on
> CONFIG_USB.

Ok.

>
> For another, the patch doesn't understand the difference between && and
> ||.  As an example, putting chipidea/Kconfig inside "if USB" and then
> doing this:
>
>> --- a/drivers/usb/chipidea/Kconfig
>> +++ b/drivers/usb/chipidea/Kconfig
>> @@ -1,6 +1,6 @@
>>   config USB_CHIPIDEA
>>   	tristate "ChipIdea Highspeed Dual Role Controller"
>> -	depends on USB || USB_GADGET
>> +	depends on USB_GADGET
>>   	help
>>   	  Say Y here if your system has a dual role high speed USB
>>   	  controller based on ChipIdea silicon IP. Currently, only the
>
> effectively changes the || to an &&.  This is not what we want.
>
> You need to be a lot more careful about the distinction between hosts
> and gadgets.  The situation becomes even more complicated when you
> realize that some of the code applies to Dual-Role Devices, which can
> be either hosts or gadgets (this includes OTG).  In addition, there are
> a few things (such as gadget/dummy_hcd.c) which require _both_
> host-side and device-side support.

Ok, thanks for the hint, I will address these issues.
--
Florian
