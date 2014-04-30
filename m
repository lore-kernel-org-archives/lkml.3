Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaD3C4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:56:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32845 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaD3C4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:56:08 -0400
Message-ID: <5360662A.50106@ti.com>
Date: Tue, 29 Apr 2014 21:55:38 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>, Joel Fernandes <agnel.joel@gmail.com>
CC: Nishanth Menon <nm@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP5: Switch to THUMB mode if needed on secondary
 CPU
References: <1398191506-3741-1-git-send-email-joelf@ti.com> <20140428164348.GA14354@e103592.cambridge.arm.com> <535E8DC2.4010504@ti.com> <535E8E2D.1020708@ti.com> <20140429091725.GA3582@e103592.cambridge.arm.com> <D49C397D-1ABD-4882-B3F5-94F359D7552B@gmail.com> <20140429183131.GF3582@e103592.cambridge.arm.com>
In-Reply-To: <20140429183131.GF3582@e103592.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 01:31 PM, Dave Martin wrote:
> On Tue, Apr 29, 2014 at 05:36:30PM +0100, Joel Fernandes wrote:
> 
> [...]
> 
>>>> Sorry what I meant is, say its of Type function. What tells the firmware
>>>> to switch to THUMB?
>>>>
>>>> What's typically done is a boot address register is written by the
>>>> kernel, and the firmware jumps to it after WFE.
>>>
>>> Using ENTRY(x) ... ENDPROC(x) causes the symbol seen by the linker
>>> for x to have the Thumb bit set if the code is Thumb.
>>>
>>> This means that any reference the linker fixes up for that symbol
>>> will have the Thumb bit set appropriately.  This applies to any kind
>>> of reference, so code in another file that takes the address of the
>>> symbol and then passes that address to the firmware should result in the
>>> firmware getting an address with the Thumb bit.
>>>
>>> From the firmware's point of view it just gets a raw address, but
>>> the Thumb bit will now be set.  The firmware still needs to handle
>>> this correctly when jumping, but from the look of the code this may
>>> already work on omap3/4.  It would be interesting to know whether it
>>> works on omap5.
>>
>> Thanks a lot for the explanation. That makes perfect sense. I will try it and let you know if it works on OMAP5.
> 
> ARM/thumb interworking making perfect sense?  I'll have to frame that
> and put it on the wall :)
> 
> objdump and nm conveniently mask off the Thumb bit from all function
> addresses they print out, but if you show the symbols using readelf
> instead you'll see addresses with bit 0 set for Thumb functions.
> 
> It's possible that the firmware still doesn't handle branching to Thumb
> correctly, but if it does it would be nice to remove the requirement to
> build an odd piece of a Thumb-2 kernel in ARM.

Sure, it works great! thanks, I sent out a patch that applies on top of
the first one. Thanks for spotting it.

Regards,
-Joel

