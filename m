Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaIBSjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:39:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:38925 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBSjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:39:36 -0400
Message-ID: <54060EDA.6060204@linutronix.de>
Date: Tue, 02 Sep 2014 20:39:22 +0200
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
References: <20140815210211.GD9239@atomide.com> <53F5AF0D.5060409@linutronix.de> <20140821184416.GF10066@atomide.com> <53FE3779.5090908@linutronix.de> <20140827202313.GF16006@atomide.com> <20140828082348.GA5413@linutronix.de> <20140828164645.GG16006@atomide.com> <53FF84DF.7080406@linutronix.de> <20140828225454.GM16006@atomide.com> <540048B4.7010807@linutronix.de> <20140829161221.GO16006@atomide.com> <5404B149.6010400@linutronix.de>
In-Reply-To: <5404B149.6010400@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 07:47 PM, Sebastian Andrzej Siewior wrote:
> Comparing it with serial-omap I see the same thing: I takes approx the
> same amount of data until the first one is displayed. After a lot of
> "long" writes which wake the chip up from idle I manage to freeze both,
> the serial-omap driver and mine driver.

So after some testing:
- it happens with omap-serial as well. Especially after disabling the
  LED trigger for both LEDs.

- it seemed that disabling the MDR1 check whether or not we lost
  context made the problem appear less often but it was a trick. Even
  with restoring the context each time I see the same problem.

- it seems to be easier to trigger with the LED trigger switched off.
  However sometimes it works for 10 minutes, sometimes it triggers
  after one.

- I see to face two kind of "deaths":
  - the LED still goes on and off and the uart just does not respond
    even if I tell the button print something on the screen (the button
    also changes the frequency of the LED so I know that the button is
    doing something).
    Also from dumping the content of /proc/interrupts it seems that a
    wake up is made, the uart should have restored the registers.

  - one where the system is dead and the LED does not blink anymore.
    Also my button is dead.

- disabling DMA makes the problem not go away.

- mdelay(25) in omap8250_lost_context() is long enough to drop the 403
  bytes I send in my testcase. That means I see only "good" characters.
  With this the box remained alive for 2h. However the uart died anyway.

>>
>> Regards,
>>
>> Tony
>>
> 

Sebastian

