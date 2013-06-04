Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3FDJsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:48:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53703 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3FDJsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:48:13 -0400
Message-ID: <51ADB7D5.8070708@ti.com>
Date: Tue, 4 Jun 2013 12:48:05 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <swarren@nvidia.com>
Subject: Re: [PATCH 1/1] USB: ehci-omap: Reset dma_mask pointer on probe
References: <Pine.LNX.4.44L0.1305231009230.1459-100000@iolanthe.rowland.org> <519E2BD4.9020906@ti.com> <20130603175108.GA11188@kroah.com>
In-Reply-To: <20130603175108.GA11188@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 08:51 PM, Greg KH wrote:
> On Thu, May 23, 2013 at 05:46:44PM +0300, Roger Quadros wrote:
>> On 05/23/2013 05:11 PM, Alan Stern wrote:
>>> On Thu, 23 May 2013, Roger Quadros wrote:
>>>
>>>> Device tree probed devices don't get dma_mask set. Previously
>>>> we were setting the dma_mask pointer only if it was NULL.
>>>> However, the address of 'omap_ehci_dma_mask' would change
>>>> each time the module is unloaded and loaded back thus causing
>>>> the devices dma_mask pointer to be invalid on the next load.
>>>>
>>>> This will cause page faults if any driver tries to access the
>>>> old dma_mask pointer.
>>>>
>>>> Unconditionally re-setting the dma_mask pointer fixes this problem.
>>>
>>>> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
>>>> index 3d1491b..b33e306 100644
>>>> --- a/drivers/usb/host/ehci-omap.c
>>>> +++ b/drivers/usb/host/ehci-omap.c
>>>> @@ -146,8 +146,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>>>>  	 * Since shared usb code relies on it, set it here for now.
>>>>  	 * Once we have dma capability bindings this can go away.
>>>>  	 */
>>>> -	if (!pdev->dev.dma_mask)
>>>> -		pdev->dev.dma_mask = &omap_ehci_dma_mask;
>>>> +	pdev->dev.dma_mask = &omap_ehci_dma_mask;
>>>
>>> Is this the solution that people have agreed on?  There has been a lot 
>>> of discussion on this topic.  In particular, there has been talk about 
>>> fixing it in the DT core.
>>
>> Fixing it in DT core would be best.
> 
> Then please do that.
>

It seems [1] went into 3.10-rc3 so this issue is fixed for 3.10.

[1] https://patchwork.kernel.org/patch/2537021/

cheers,
-roger
