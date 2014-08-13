Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaHMQVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:21:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:46923 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaHMQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:21:03 -0400
Message-ID: <53EB9066.3060208@linutronix.de>
Date: Wed, 13 Aug 2014 18:20:54 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de> <1405521903-5877-6-git-send-email-bigeasy@linutronix.de> <20140717070859.GD18374@atomide.com> <20140717074219.GA29193@linutronix.de> <20140717081232.GH18374@atomide.com> <53C7A01C.50107@linutronix.de> <20140718062456.GJ18374@atomide.com> <20140721093528.GS18374@atomide.com>
In-Reply-To: <20140721093528.GS18374@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 11:35 AM, Tony Lindgren wrote:

> Looks like the following is needed to avoid the error, no idea why..
> But this is what we also do in omap-serial.c. It may be needed in
> other places too?

Yes, there was a third one on shutdown.

> Also, no luck yet on runtime PM. If the console is enabled omap won't
> idle, and if no serial console is enabled, it just hangs. Will try
> to debug this part further, it may be also related to the above.

My beaglebone xm won't do idle:

| omap3_pm_off_mode_enable: Core OFF disabled due to errata i583

but it would if it could, right? That means that I can't test the wake
via UART on this one?

So I will try to fix the tx-pm, fold patches and then prepare another
batch.
And I could verify that DMA works on that omap3 :)

> Regards,
> 
> Tony

Sebastian
