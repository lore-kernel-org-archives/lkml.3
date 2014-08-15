Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaHOU2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:28:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64266 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbaHOU2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:28:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/8upOGUaebyIgc7L9XebPo
Date: Fri, 15 Aug 2014 13:28:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7] 8250-core based serial driver for OMAP + DMA
Message-ID: <20140815202826.GC9239@atomide.com>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <20140815181704.GH17769@csclub.uwaterloo.ca>
 <53EE5BF8.3010007@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EE5BF8.3010007@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140815 12:16]:
> On 08/15/2014 08:17 PM, Lennart Sorensen wrote:
> 
> > Are you saying that with the new driver you have to respond to the RX
> > irq faster than before to avoid overflows?  It is not quite clear.
> 
> Yes. The irq fires 46 bytes giving you 16 bytes buffer before overflow
> vs 63 bytes buffer the old one had.
> 
> > I do think 40000 interrupts to handle 40000 bytes of date does seem a
> > tad inefficient, so dropping to 854 looks a lot nicer.  Was the omap
> > driver not using the fifo trigger levels at all?
> 
> It configured the trigger levels to 1 for RX and 16 for TX.

Hmm that weird RX trigger level is a workaround for lost characters.

See commit 0ba5f66836 (tty: serial: OMAP: use a 1-byte RX FIFO
threshold in PIO mode :)

There's paste test in that commit, I wonder if the 8250 drivers
can deal with it any better?

Regards,

Tony
