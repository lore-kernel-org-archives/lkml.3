Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaISLZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:25:35 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47049 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753558AbaISLZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:25:32 -0400
Message-ID: <541C12A4.8020901@hurleysoftware.com>
Date: Fri, 19 Sep 2014 07:25:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5419B825.5000201@linutronix.de> <20140919102212.GA31784@xps8300> <541C0C64.5010206@linutronix.de>
In-Reply-To: <541C0C64.5010206@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 06:58 AM, Sebastian Andrzej Siewior wrote:
> On 09/19/2014 12:22 PM, Heikki Krogerus wrote:
>> Couldn't you just replace the handle_irq with a custom irq routine in
>> the omap driver like you did with set_termios? Where you would do
>> those tricks and/or call serial8250_handle_irq()?
> 
> Tricks within serial8250_handle_irq(), see [0]. It is not a lot but
> still. I could provide my own handle irq, just asking what you would
> prefer.
> 
> [0]
> http://git.breakpoint.cc/cgit/bigeasy/linux.git/commit/?h=uart_v10_pre2&id=f26f161d998ee4a84a0aa6ddff69a435c25f204d
> 
>> The 8250_core changes in that patch #10 only modify
>> serial8250_handle_irg right?
> 
> Correct. However there is another change due to the RX_DMA_BUG. A while
> ago you said that this RX_DMA_BUG thing might be something that other
> SoC could use, too.
> If you ask me now for my own irq routine it would make sense to move RX
> bug handling into omap specific code as well.

I'm not excited at the prospect of an omap-specific irq handler, especially
if this is just a silicon bug. I think it will create and encourage
unnecessary code variation in the 8250 driver. The inertia of an
omap-specific irq handler will mean it will probable stay forever. Suppose
this tx dma bug is later discovered to be fixable inline (rather than by
state), then we'll be stuck with an irq handler that no one will want to
integrate.

Regards,
Peter Hurley
