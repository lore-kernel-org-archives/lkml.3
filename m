Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaIKIEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:04:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:37801 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaIKIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:04:01 -0400
Message-ID: <5411576E.204@linutronix.de>
Date: Thu, 11 Sep 2014 10:03:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty: serial: core: Only invoke ->start_tx() if there
 is data to send
References: <1410377601-26794-1-git-send-email-bigeasy@linutronix.de> <5410AC1B.9000700@hurleysoftware.com>
In-Reply-To: <5410AC1B.9000700@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 09:52 PM, Peter Hurley wrote:
> The serial core can't assume that start_tx() does not need invoking
> because hardware that can stop_tx() with data in the transmitter
> won't restart if the ring buffer is empty but data is still in the
> transmitter. [Note that the 16C950 port type does this in the 8250 driver.]

oh, not sure how I missed this… But now that I look at this, it is also
that ->x_char that could be use for flow control which would have to be
sent even with an empty xmit buffer.
And 8250 in DMA mode does not look at x_char at all. But it would be
better if it would, right? However if the TX side does a 2 KiB transfer
not sure what should be done…

> So this has to be handled in the 8250 driver.
> 
> What is the actual issue? Are you trying not to unnecessarily wake
> the omap hardware if runtime-PM is on?

no, it is actually the extra interrupt for no reason that looked like
not needed at all. But I guess it is only during "startup" while the
init-script do fancy things and not during "normal" operations.

> Regards,
> Peter Hurley

Sebastian
