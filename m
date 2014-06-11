Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbaFKPcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:32:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58184 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbaFKPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:32:04 -0400
Message-ID: <5398766D.1070900@wwwdotorg.org>
Date: Wed, 11 Jun 2014 09:31:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Florian Fainelli <f.fainelli@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Jason Cooper <jason@lakedaemon.net>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [RFC] irqchip: gic: always mask interrupts during suspend
References: <1402442098-21093-1-git-send-email-computersforpeace@gmail.com> <alpine.DEB.2.10.1406110129270.5170@nanos> <20140610234826.GK3599@ld-irv-0074>
In-Reply-To: <20140610234826.GK3599@ld-irv-0074>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 05:48 PM, Brian Norris wrote:
> On Wed, Jun 11, 2014 at 01:34:39AM +0200, Thomas Gleixner wrote:
>> On Tue, 10 Jun 2014, Brian Norris wrote:
>>> Other random thought: it seems like any irqchip driver which does lazy IRQ
>>> masking ought to use IRQCHIP_MASK_ON_SUSPEND. So maybe the IRQ core should just
>>> do something like:
>>>
>>> 	if (!chip->irq_disable)
>>> 		chip->flags |= IRQCHIP_MASK_ON_SUSPEND;
>>
>> No. Lazy irq disable and the suspend logic are different beasts.
> 
> OK, fair enough. Drop that random thought then. It's not in the patch
> content anyway.
> 
>> That's up to the platform to decide this. Just for the record: there
>> is a world outside of ARM...
> 
> OK. But GIC is ARM-specific, so we can still constrain this patch and
> related topics to the world of ARM.
> 
>> But that brings me to a different question:
>>
>>     Why are you not putting that customization into the device tree
>>     instead of trying to add this to some random arch/arm/mach-foo
>>     files?
> 
> I'm not adding customization to arch/arm/mach-foo files. I'm trying to
> remove it.
> 
> This property could be added to device tree, if there was really a valid
> use case for a GIC which leaves its interrupts unmasked for suspend. My
> question in this patch is essentially: does such a use case exist?

DT should genernally only contain data that's expected to vary between
boards, or just possibly between SoCs. Anything that the kernel knows
simply because it knows what HW model it's driving has no place in DT,
since it just adds redundant work to parse the DT and end up with the
same data.

