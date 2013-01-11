Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3AKLGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:06:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53930 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3AKLGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:06:53 -0500
Message-ID: <50EFF244.30001@ti.com>
Date: Fri, 11 Jan 2013 13:06:44 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if required
References: <Pine.LNX.4.44L0.1301101544140.1178-100000@iolanthe.rowland.org> <50EFF075.5090203@ti.com>
In-Reply-To: <50EFF075.5090203@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 12:59 PM, Roger Quadros wrote:
> On 01/10/2013 10:48 PM, Alan Stern wrote:
>> On Thu, 10 Jan 2013, Roger Quadros wrote:
>>
>>> If the OMAP's Host controller is in PHY mode then we instantiate
>>> a platform device for the PHY (one for each port in PHY mode) and
>>> hold a reference to it so that we can use the usb_phy API, e.g.
>>> while suspend/resume.
>>>
>>> The platform data for the PHY must be supplied in the newly added
>>> .phy_config parameter in struct usbhs_omap_platform_data.
>>>
>>> The end goal is to move the PHY's reset and power handling code
>>> out of the ehci-omap driver and into the phy driver.
>>
>> As mentioned in another thread, I would prefer to have these changes to 
>> ehci-omap.c made after the driver is converted to the new "ehci-hcd is 
>> a library" scheme.  The patch below does the conversion; it is meant to 
>> apply on top of the similar patch for ehci-mxc posted recently on the 
>> linux-usb mailing list.
>>
>> After this conversion, the omap_ehci_hcd private data structure doesn't 
>> have to be allocated specifically.  It can be handled in the same way 
>> as the private data structure in the ehci-mxc patch.
>>
>> I haven't even tried to compile this.  Please let me know how it works.
>>
> 
> Alan,
> 
> Thanks for the patch. I've pasted the version that builds and works and
> put you as the Author of the patch, hope it is fine.
> 
> I could not find the equivalent ehci-mxc implementation though. Any
> pointers to that? Thanks.

OK I found it. Previously I was searching in the archives :P.

cheers,
-roger

