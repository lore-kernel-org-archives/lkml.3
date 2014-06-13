Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaFMNgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:36:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58240 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaFMNgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:36:03 -0400
Message-ID: <539AFE18.3020706@ti.com>
Date: Fri, 13 Jun 2014 09:35:20 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Sricharan R <r.sricharan@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>, <rnayak@ti.com>,
        <linux@arm.linux.org.uk>, <tglx@linutronix.de>
Subject: Re: [PATCH V2 03/19] irqchip: crossbar: Skip some irqs from getting
 mapped to crossbar
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com> <1402574007-13987-4-git-send-email-r.sricharan@ti.com> <20140612125134.GS8664@titan.lakedaemon.net> <20140612135715.GE17845@atomide.com> <20140612140508.GC8664@titan.lakedaemon.net> <539AA08A.7010001@ti.com> <20140613131005.GF8664@titan.lakedaemon.net>
In-Reply-To: <20140613131005.GF8664@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2014 09:10 AM, Jason Cooper wrote:
> On Fri, Jun 13, 2014 at 12:26:10PM +0530, Sricharan R wrote:
>> On Thursday 12 June 2014 07:35 PM, Jason Cooper wrote:
> ...
>>> Do you have other changes outside of irqchip depending on this series?
>>> If so, I can set up a topic branch for you guys to base off of.
>>> Otherwise, I'll just apply them to irqchip/core when they're ready.
>>>
>>  There are dts changes which are dependent upon this series.
>>
>>   http://www.spinics.net/lists/linux-omap/msg108116.html
> 
> In general, dts changes shouldn't depend on code changes or vice-versa.
> If they do, that's an indicator that we're breaking compatibility with
> older dtbs.
>
Thats true. The case with cross-bar though is the feature wasn't
completly supported so far before this series. Perhaps the the initial
bindings should have been marked unstable. 
 
> Looking at the dra7.dtsi changes, we're redefining the interrupt
> property, which can't be good. :(
>
> Perhaps a better solution would be to add a property, say 'ti,cross-irq'
> that is the exact same format as 'interrupts', but is used by the
> crossbar driver?
>
We have gone over those earlier and it was agreed to re-use interrupt
properties and for special cases, define a cross-bar property to describe
it.
 
> I'm not convinced of this yet, I suspect we may not actually have a
> dependency between the dtsi changes and the code changes.  We would have
> the ugly "if you have the crossbar node, 'interrupts' means X, if not it
> means Y" in the binding docs.  But the absence of the node prevents the
> crossbar driver from re-interpreting the interrupts property.
> 
In ideal cross-bar hardware you don't need the assumption "if you have the
crossbar node, 'interrupts' means X, if not it means Y"

It is purely because the cross-bar irq router hardware has few nasty
bugs which needs those special handling. And thats the reason, the
property was added.

> Have you tried booting all the different scenarios?  eg:
> 
>   old dtb, new driver
>   new dtb, old driver
>   old dtb, old driver
>   new dtb, new driver
> 
Old driver wasn't complete as mentioned and hence the above
combinations becomes bit irrelevant.

Regards,
Santosh


