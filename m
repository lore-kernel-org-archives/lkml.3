Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaAPSmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:42:17 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:54965 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAPSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:42:15 -0500
Message-ID: <52D82802.6090104@gmail.com>
Date: Thu, 16 Jan 2014 19:42:10 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Jason Cooper <jason@lakedaemon.net>, Ian Campbell <ijc@hellion.org.uk>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: orion: provide C-style interrupt handler for MULTI_IRQ_HANDLER
References: <1389775235.10695.51.camel@dagon.hellion.org.uk> <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140116164833.GH29184@titan.lakedaemon.net> <1389891087.6697.26.camel@kazak.uk.xensource.com> <20140116165347.GI29184@titan.lakedaemon.net>
In-Reply-To: <20140116165347.GI29184@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 05:53 PM, Jason Cooper wrote:
> On Thu, Jan 16, 2014 at 04:51:27PM +0000, Ian Campbell wrote:
>> On Thu, 2014-01-16 at 11:48 -0500, Jason Cooper wrote:
>>> Sebastian,
>>>
>>> On Thu, Jan 16, 2014 at 09:10:31AM +0100, Sebastian Hesselbarth wrote:
>>>> DT-enabled Marvell Kirkwood and Dove SoCs make use of an irqchip
>>>> driver. As expected for irqchip drivers, it uses a C-style
>>>> interrupt handler and therefore selects MULTI_IRQ_HANDLER.
>>>>
>>>> Now, compiling a kernel with both non-DT and DT support enabled,
>>>> selecting MULTI_IRQ_HANDLER will break ASM irq handler used by
>>>> non-DT boards.
>>>>
>>>> Therefore, we provide a C-style irq handler even for non-DT boards,
>>>> if MULTI_IRQ_HANDLER is set. By installing the C-style irq handler
>>>> in orion_irq_init this is transparent to all non-DT board files.
>>>>
>>>> While the regression report was filed on Marvell Kirkwood, also
>>>> Marvell Dove non-DT boards are affected and fixed by this patch.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>> Tested-by: Ian Campbell <ijc@hellion.org.uk>
>>>> Reported-by: Ian Campbell <ijc@hellion.org.uk>
>>>> Fixes: 2326f04321a9 ("ARM: kirkwood: convert to DT irqchip and clocksource")
>>>> Fixes: f07d73e33d0e ("ARM: dove: convert to DT irqchip and clocksource")
>>>> ---
>>>> Compared to the two patch version sent on Ian's regression report,
>>>> I cooked this down to a single patch only touching plat-orion/irq.c.
>>>> I also dropped Orion5x and MV78x00, as they not yet select MULTI_IRQ_HANDLER
>>>> at all. Instead I added a comment about taking care of them, as soon as
>>>> they move over to an irqchip driver themselves.
>>>>
>>>> I have not yet Cc'ed this patch to -stable to get some discussion and
>>>> an Acked-by from Jason or Andrew, too.
>>>>
>>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Ian Campbell <ijc@hellion.org.uk>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>   arch/arm/plat-orion/irq.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 47 insertions(+)
>>>
>>> Applied to mvebu/fixes with Andrew's Ack.  It's too late for v3.13, so
>>> it'll be the first thing sent for v3.14.
>>
>> Please can it also be tagged for stable backport to 3.12+3.13.
>
> Yes, I forgot to mention it, but that is already done. ;-)

Ok, thanks!

Out of curiosity, does that adding the Cc tag to the commit queue
it automatically as soon as it will be pulled by Linus?

@Ian: Thanks for hunting this down, please keep bothering us with
bug reports :)

Sebastian
