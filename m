Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbbAWH1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:27:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48142 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbbAWH1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:27:05 -0500
Message-ID: <54C1F7C0.4020505@ti.com>
Date: Fri, 23 Jan 2015 09:26:56 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <tony@atomide.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <george.cherian@ti.com>, <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] extcon: usb: Introduce USB GPIO extcon driver. Fix
 DRA7 USB.
References: <1421689942-10201-1-git-send-email-rogerq@ti.com> <20150120190237.GG15169@saruman> <54C0FBDC.6040803@ti.com> <54C10FF4.5030503@ti.com> <20150122202907.GC22288@saruman.tx.rr.com>
In-Reply-To: <20150122202907.GC22288@saruman.tx.rr.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On 22/01/15 22:29, Felipe Balbi wrote:
> On Thu, Jan 22, 2015 at 04:57:56PM +0200, Roger Quadros wrote:
>>
>> On 22/01/15 15:32, Roger Quadros wrote:
>>> Felipe,
>>>
>>> On 20/01/15 21:02, Felipe Balbi wrote:
>>>> On Mon, Jan 19, 2015 at 07:52:17PM +0200, Roger Quadros wrote:
>>>>> Hi,
>>>>>
>>>>> On DRA7 EVMs the USB ID pin is connected to a GPIO line. The USB drivers
>>>>> (dwc3 + dwc3-omap) depend on extcon framework to get the USB cable state
>>>>> (USB or USB-Host) to put the controller in the right mode.
>>>>>
>>>>> There were earlier attempts [1] to get this working by trying to patch up
>>>>> the existing GPIO extcon driver.
>>>>>
>>>>> This series attemts to take a different approach by introducing a new
>>>>> USB specific extcon driver to handle the USB ID GPIO pin and
>>>>> interpret a right USB cable state.
>>>>>
>>>>> The reasoning to introduce this new driver is:
>>>>> 1) The existing GPIO extcon driver doesn't understand USB cable states
>>>>> and it can't handle more than one cable per instance.
>>>>>    
>>>>> For the USB case we need to handle at least 2 cable states.
>>>>>     a) USB (attach/detach)
>>>>>     b) USB-Host (attach/detach)
>>>>> and could possible include more states like
>>>>>     c) Fast-charger (attach/detach)
>>>>>     d) Slow-charger (attach/detach)
>>>>>     
>>>>> 2) This USB specific driver can be easily updated in the future to
>>>>> handle VBUS events, or charger detect events, in case it happens
>>>>> to be available on GPIO for any platform.
>>>>>
>>>>> 3) The DT implementation is very easy. You just need one extcon node per USB
>>>>> instead of one extcon node per cable state as in case of [1].
>>>>>
>>>>> 4) The cable state string doesn't need to be encoded in the device tree
>>>>> as in case of [1].
>>>>>
>>>>> 5) With only ID event available, you can simulate a USB-peripheral attach
>>>>> when USB-Host is detacted instead of hacking the USB driver to do the same.
>>>>>
>>>>> Tested on DRA7-evm and DRA72-evm.
>>>>
>>>> while at that, you might want to patch X15 too.
>>>>
>>> USB2 port is meant for peripheral use only. ID pin from USB port is not connected to GPIO.
>>>
>>
>> OK answering myself here :).
>> Peripheral mode doesn't work on x15-bb as the USB driver (dwc3-omap)
>> doesn't set the mailbox correctly even when dwc3 node is set as otg = "peripheral".
>>
>> Looks like we need to implement usb-gpio-extcon for x15 even though ID is hard coded.
> 
> right, another option is to have dwc3-omap read the child's DTS to check
> dr_mode and hardcode things based on that.
> 
I think that option is better as it doesn't require a GPIO line to be reserved
for ID when USB is not meant for dual-role use.

cheers,
-roger
