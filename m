Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaIOLvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:51:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:33153 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaIOLvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:51:01 -0400
Message-ID: <5416D2A0.5020407@linutronix.de>
Date: Mon, 15 Sep 2014 13:50:56 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <20140912224324.GK18849@atomide.com>
In-Reply-To: <20140912224324.GK18849@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2014 12:43 AM, Tony Lindgren wrote:
> * Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140910 12:30]:
>> the diff of v8…v9 is small:
>> - rebased on top's of Greg's tty-next branch
>> - fixed #10 where we might have THRE interrupt enabled for longer than
>>   needed
>> - re-did register setup in #10. Before this "less file" could freeze the
>>   am335x-evm.
> 
> FYI, looks like merging in your uart_v9 branch for testing
> with my hwmod changes now fails to produce RX characters on omap3.
> 
> The device wakes up just fine to the wake-up interrupt, and then
> serial8250_handle_irq() gets called, but I'm not seeing anything
> in the console getting printed out. It's like all the RX characters
> are getting lost instead of just the first one. The RX characters
> work fine when the system is running.
> 
> So it seems there's been some kind of regression since v8?

I changed the restore function the fix the am335x-evm + less "freeze".
And now we have this. So let me search…

> Regards,
> 
> Tony
> 

Sebastian
