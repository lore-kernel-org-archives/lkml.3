Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaILWn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:43:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13503 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaILWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:43:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+g1D5K8hfeI8N+NDsA/NR6
Date: Fri, 12 Sep 2014 15:43:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
Message-ID: <20140912224324.GK18849@atomide.com>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140910 12:30]:
> the diff of v8…v9 is small:
> - rebased on top's of Greg's tty-next branch
> - fixed #10 where we might have THRE interrupt enabled for longer than
>   needed
> - re-did register setup in #10. Before this "less file" could freeze the
>   am335x-evm.

FYI, looks like merging in your uart_v9 branch for testing
with my hwmod changes now fails to produce RX characters on omap3.

The device wakes up just fine to the wake-up interrupt, and then
serial8250_handle_irq() gets called, but I'm not seeing anything
in the console getting printed out. It's like all the RX characters
are getting lost instead of just the first one. The RX characters
work fine when the system is running.

So it seems there's been some kind of regression since v8?

Regards,

Tony
