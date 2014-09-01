Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaIARsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:48:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:60649 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaIARsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:48:01 -0400
Message-ID: <5404B149.6010400@linutronix.de>
Date: Mon, 01 Sep 2014 19:47:53 +0200
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
References: <20140815210211.GD9239@atomide.com> <53F5AF0D.5060409@linutronix.de> <20140821184416.GF10066@atomide.com> <53FE3779.5090908@linutronix.de> <20140827202313.GF16006@atomide.com> <20140828082348.GA5413@linutronix.de> <20140828164645.GG16006@atomide.com> <53FF84DF.7080406@linutronix.de> <20140828225454.GM16006@atomide.com> <540048B4.7010807@linutronix.de> <20140829161221.GO16006@atomide.com>
In-Reply-To: <20140829161221.GO16006@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 06:12 PM, Tony Lindgren wrote:
> Looks like the paste bug is there for sure, doing off idle and pasting
> 240 characters to the console can hang the UART RX after few attempts,
> and pasting 16 charactes won't show up at all if the system is idling.
> So you may want to play with that too a bit :)

One character wakes it up. After that you can send 16, 64 and you see
them. Right away. No delay.

If you send "a lot" data in one-go it takes approx 152 characters until
the first one is displayed properly at 115200,8N1. That is approx 13ms.
Could it take that long to get up and be ready?

Comparing it with serial-omap I see the same thing: I takes approx the
same amount of data until the first one is displayed. After a lot of
"long" writes which wake the chip up from idle I manage to freeze both,
the serial-omap driver and mine driver.

One thing that is probably a dumb idea is that printk in
omap_8250_mdr1_errataset().
Would it be possible that when I hit a printk in the resume path that I
may deadlock and box will freeze?

> 
> Regards,
> 
> Tony
> 

Sebastian
