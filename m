Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3DKKvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:51:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3DKKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:51:21 -0400
Message-ID: <516695A4.2050804@ti.com>
Date: Thu, 11 Apr 2013 13:51:16 +0300
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
References: <5166856C.3080906@ti.com> <20130411100435.GB14394@arwen.pp.htv.fi>
In-Reply-To: <20130411100435.GB14394@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:04 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Apr 11, 2013 at 12:42:04PM +0300, Roger Quadros wrote:
>> Hi Greg,
>>
>> The following patch gets rid of Kbuild warnings when USB_EHCI_HCD_OMAP
>> is enabled.
>>
>> Patch is based on your usb-next branch and is needed for 3.10.
>>
>> From: Roger Quadros <rogerq@ti.com>
>> Date: Thu, 11 Apr 2013 12:08:19 +0300
>> Subject: [PATCH] USB: ehci-omap: Select USB_PHY
>>
>> As we need NOP_USB_XCEIV which depends on USB_PHY
>> we need to select USB_PHY as well.
>>
>> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
>> is enabled.
>>
>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
>> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Ideally, however, we wouldn't select any PHY in particular as different
> boards might need a different PHY driver, even on OMAP ;-)
> 
Right, but we need to select USB_PHY here as the driver uses
the USB_PHY APIs.

The NOP_USB_XCEIV selection could be done by the board config.

cheers,
-roger
