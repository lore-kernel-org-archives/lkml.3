Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3GAIeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:34:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38194 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3GAIeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:34:18 -0400
Message-ID: <51D13EF0.6030702@ti.com>
Date: Mon, 1 Jul 2013 11:33:52 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
References: <Pine.LNX.4.44L0.1306281507020.1047-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306281507020.1047-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 10:18 PM, Alan Stern wrote:
> On Fri, 28 Jun 2013, Roger Quadros wrote:
> 
>> Just found the problem. It seems that enabling the ehci_irq _after_ the root hub is resumed
>> is the root cause of the problem. Doing so will miss events from the root hub.
> 
> This sounds like a bug in the IRQ setup.  It's the sort of thing you 
> see when a level-triggered IRQ is treated as though it were 
> edge-triggered.
> 
> In any case, the wakeup should have worked whether the IRQ was issued 
> or not.
> 
OK.
> 
> I appreciate the symmetry of putting the enable_irq call in ehci-hcd, 
> seeing as how the disable_irq is there too.  On the other hand, every 
> HCD using this mechanism is going to have to do the same thing, which 
> argues for putting the enable call in the core.  Perhaps at the start 

OK.

> of hcd_resume_work() instead of the end.
> 

We can't enable_irq at the start as the controller will only be resumed
after usb_remote_wakeup().

cheers,
-roger
