Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaIHRzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:55:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22413 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaIHRzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:55:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19BXX6kwuqBewsqoopX5uut
Date: Mon, 8 Sep 2014 10:55:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v8 00/18] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140908175510.GK3238@atomide.com>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <20140908174020.GI3238@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908174020.GI3238@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140908 10:41]:
> * Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140905 12:03]:
> > This is my complete queue fo the omap serial driver based on the 8250 core
> > code. I played with it on beagle bone, am335x-evm and dra7xx including DMA.
> > The runtime-pm pieces look now bug-compatible with the omap-serial driver.
> > Besides the runtime-om improvement I also fixed a few corner cases for the
> > TX-DMA problem. The DMA fixes (in edma and omap-dma) were dropped and the
> > problem has been in 8250-dma via patch #13.
> > 
> > The whole queue is available at
> >   git://git.breakpoint.cc/bigeasy/linux.git uart_v8
> 
> Gave the above branch a quick try, but it again does not idle for
> my omap3 test cases. It seems that now the cm_idlest1_core sdma
> bit is blocking deeper idle states. Is that the correct branch
> to use?

Never mind. User error. I forgot to apply my own patch for force
idling the UARTs for the omap hwmod. And the sdma bit clears if
I do sleep 5 before attempting to read the sysfs entry..

Regards,

Tony
