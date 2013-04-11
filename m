Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431Ab3DKMnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:43:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45925 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934158Ab3DKMnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:43:03 -0400
Message-ID: <5166AFD2.4070108@ti.com>
Date: Thu, 11 Apr 2013 15:42:58 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
References: <5166856C.3080906@ti.com> <20130411100435.GB14394@arwen.pp.htv.fi> <516695A4.2050804@ti.com> <20130411105557.GE14394@arwen.pp.htv.fi>
In-Reply-To: <20130411105557.GE14394@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:55 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Apr 11, 2013 at 01:51:16PM +0300, Roger Quadros wrote:
>> On 04/11/2013 01:04 PM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Thu, Apr 11, 2013 at 12:42:04PM +0300, Roger Quadros wrote:
>>>> Hi Greg,
>>>>
>>>> The following patch gets rid of Kbuild warnings when USB_EHCI_HCD_OMAP
>>>> is enabled.
>>>>
>>>> Patch is based on your usb-next branch and is needed for 3.10.
>>>>
>>>> From: Roger Quadros <rogerq@ti.com>
>>>> Date: Thu, 11 Apr 2013 12:08:19 +0300
>>>> Subject: [PATCH] USB: ehci-omap: Select USB_PHY
>>>>
>>>> As we need NOP_USB_XCEIV which depends on USB_PHY
>>>> we need to select USB_PHY as well.
>>>>
>>>> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
>>>> is enabled.
>>>>
>>>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
>>>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
>>>>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>
>>> Ideally, however, we wouldn't select any PHY in particular as different
>>> boards might need a different PHY driver, even on OMAP ;-)
>>>
>> Right, but we need to select USB_PHY here as the driver uses
>> the USB_PHY APIs.
>>
>> The NOP_USB_XCEIV selection could be done by the board config.
> 
> I would avoid 'select' completely and just update omap2plus_defconfig
> adding those two as modules.
> 

OK, makes sense. I will update the patch to remove "select NOP_USB_XCEIV".

cheers,
-roger

