Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaH2Jcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:32:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:45232 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaH2Jcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:32:43 -0400
Message-ID: <540048B4.7010807@linutronix.de>
Date: Fri, 29 Aug 2014 11:32:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de> <1408124563-31541-16-git-send-email-bigeasy@linutronix.de> <20140815210211.GD9239@atomide.com> <53F5AF0D.5060409@linutronix.de> <20140821184416.GF10066@atomide.com> <53FE3779.5090908@linutronix.de> <20140827202313.GF16006@atomide.com> <20140828082348.GA5413@linutronix.de> <20140828164645.GG16006@atomide.com> <53FF84DF.7080406@linutronix.de> <20140828225454.GM16006@atomide.com>
In-Reply-To: <20140828225454.GM16006@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 12:54 AM, Tony Lindgren wrote:
> * Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140828 12:37]:
>> On 08/28/2014 06:46 PM, Tony Lindgren wrote:
>>>
>>> Sounds like there should be some way to clear that state.. I wonder
>>> if omap-serial.c had something before it's DMA support was removed?
>>
>> Its DMA was removed? Like there was DMA support?
> 
> Yeah see commit 494574304711a333386e7dd5fd3ebbc3b7024994...

Interesting. I've been browsing that file and checking other trees and
never noticed that it was there at some point. I only saw the pieces
which looked it was there.

> OK thanks, I'm seeing the same issue as you. And the idlest registers
> don't show any blockers. Looking at the errata docs, seems like
> "Usage Note 2.7" in sprz318f.pdf says:
> 
>  Details When configured for DMA operations using smartidle mode (SYSC[4:3].IDLEMODE =
>  0x2), the UART module will not acknowledge incoming idle requests. As a consequence,
>  it can prevent L4 from going to idle.
>  When there are additional expected transfers, the UART should be placed in force-idle
>  mode.

Ehm. So I haven't found an errata document for omap3630, there is
nothing like that in that one I have for am335x or dra7. The document
you mentioned is for AM3715. Interesting…

> So I've added also Paul to Cc, he may have better suggestions for the
> hwmod flags to use. The experimental patch below seems to allow idling
> for me, care to give it a try?

Yep, this one works. And I see DMA transfers (for RX side) after the
core hit idle so it seems to look good :)

> 
> Regards,
> 
> Tony

Sebastian
