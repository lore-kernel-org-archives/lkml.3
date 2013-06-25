Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3FYNhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:37:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36582 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3FYNhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:37:39 -0400
Message-ID: <51C99D07.6030307@ti.com>
Date: Tue, 25 Jun 2013 16:37:11 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Chao Xie <xiechao.mail@gmail.com>,
        Chao Xie <chao.xie@marvell.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
References: <20130620121749.GF9817@arwen.pp.htv.fi> <Pine.LNX.4.44L0.1306201319580.2063-100000@iolanthe.rowland.org> <20130624193643.GC11815@arwen.pp.htv.fi>
In-Reply-To: <20130624193643.GC11815@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 10:36 PM, Felipe Balbi wrote:
> On Thu, Jun 20, 2013 at 01:25:31PM -0400, Alan Stern wrote:
>> On Thu, 20 Jun 2013, Felipe Balbi wrote:
>>
>>>> In fact, the PHY setting and handling is related to platform or SOC,
>>>> and for different SOC they can
>>>> have same EHCI HCD but they PHY handling can be different.
>>>> Omap'a case is the example, and i think some other vendors may have
>>>> silimar cases.
>>>> From above point, It is better to leave the PHY initialization and
>>>> shutdown to be done by each echi-xxx driver.
>>>>
>>>> So Alan and Felipe
>>>> What are your ideas about it?
>>>
>>> If we have so many exceptions, then sure. But eventually, the common
>>> case should be added generically with a flag so that non-generic cases
>>> (like OMAP) can request to handle the PHY by themselves.
>>>
>>> Alan ?
>>
>> I don't have very strong feelings about this; Felipe has much more
>> experience with these things.
>>
>> However, when the common case is added into the core, the simplest way
>> to indicate that the HCD wants to handle the PHY(s) by itself will be
>> to leave hcd->phy set to NULL or an ERR_PTR value.
>>
>> One important thing that hasn't been pointed out yet: When we move
>> these calls into the core, the same patch must also remove those calls
>> from the glue drivers that currently do set hcd->phy.  And it must make
>> sure that the glue drivers which handle the PHY by themselves do not
>> set hcd->phy.
> 
> perfect summary. Perhaps Roger could already work on private PHY handle
> for ehci-omap.c and later we can start moving generic case to usbcore
> without having to touch ehci-omap.c at all. Roger, any commetns ?
> 

This looks fine to me. I don't have anything to add.

cheers,
-roger
