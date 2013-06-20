Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3FTMkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:40:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44419 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3FTMkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:40:00 -0400
Message-ID: <51C2F807.1000301@ti.com>
Date: Thu, 20 Jun 2013 15:39:35 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <tony@atomide.com>, <balbi@ti.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/6] Suspend USB Host controller on bus suspend
References: <Pine.LNX.4.44L0.1306191121280.2026-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306191121280.2026-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 06:23 PM, Alan Stern wrote:
> On Wed, 19 Jun 2013, Roger Quadros wrote:
> 
>> Hi,
>>
>> This series attempts to suspend the OMAP EHCI host controller on USB
>> Bus suspend.
> 
> Why do you want to suspend the host controller during bus suspend?  
> They are two different operations and should be carried out at two 
> different times.  The controller should be suspended during controller 
> suspend, not during bus suspend.
> 

Good point. I didn't think it that way. I think it should work.

>> As the omap-ehci controller driver needs to do some additional work to put
>> itself into suspend/resume and make sure it is resumed to process an interrupt,
>> we need to be able to override irq, bus_suspend, and bus_resume handlers. This
>> provision is done in patch 3.
> 
> Do you still need to override these things if you do the controller
> suspend at the right time?
> 

At least not for bus_suspend and bus_resume. We will still need to override the irq
handler though. But, if we can take care of this generically in the ehci_irq handler (i.e. make
sure controller is not suspended while accessing it) then we don't need such override
for irq.

cheers,
-roger
