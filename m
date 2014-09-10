Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaIJQ4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:56:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:34360 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaIJQ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:56:48 -0400
Message-ID: <541082C5.7040608@linutronix.de>
Date: Wed, 10 Sep 2014 18:56:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: linux-serial@vger.kernel.org, tony@atomide.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de> <20140908144616.GA22315@ci00147.xsens-tech.local> <20140908151501.GA22584@linutronix.de> <20140908183353.GB4686@ci00147.xsens-tech.local> <540F57E0.8030404@linutronix.de> <20140910141554.GC22315@ci00147.xsens-tech.local>
In-Reply-To: <20140910141554.GC22315@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 04:15 PM, Frans Klaver wrote:
> On Tue, Sep 09, 2014 at 09:41:20PM +0200, Sebastian Andrzej Siewior wrote:
>> On 09/08/2014 08:33 PM, Frans Klaver wrote:
>>> Thanks. I'll give it a spin on Wednesday.
>>
>> Could you please pull the upcoming v9 first?
>>
>>  git://git.breakpoint.cc/bigeasy/linux.git uart_v9_pre1
>>
>> This solves a few of my am335x related issues.
> 
> Using v9_pre1, I get a kernel panic in edma_dma_pause() on echan->edesc
> being NULL. I do get data before this happens. This is at high speed,
> high rate. No mention of the irq having too much to do, though. The more
> data I transmit, the more likely this is to occur.

Hmm. This shouldn't happen because if dma->rx_running is set, then
there should be a descriptor to pause.
Could check how this could happen? (and which event tries to do so)

In the meantime, the lower part of [0] should fix the NULL bug.

[0] https://lkml.org/lkml/2014/7/29/506

> I don't currently have the setup to lower the baudrate. I would probably
> need to reproduce this on a beaglebone, instead of our custom board.
> I'll see if I can do that.
> 
> If you need more info, just let me know.

I just pushed uart_v9_pre2 and I will post it once I rebased it on top
Greg's latest.
There was a bug where THRE could be active longer than needed caused a
few not needed interrupts until the FIFO was empty again.

My "less on file" test case did not fail anymore with this.

> Thanks,
> Frans

Sebastian
