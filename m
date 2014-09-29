Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaI2Jyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:54:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:49849 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2Jyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:54:51 -0400
Date: Mon, 29 Sep 2014 11:54:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140929095440.GB13142@linutronix.de>
References: <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <20140922092853.GH20438@ci00147.xsens-tech.local>
 <20140925151403.GH19396@linutronix.de>
 <20140929085042.GA13952@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140929085042.GA13952@ci00147.xsens-tech.local>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frans Klaver | 2014-09-29 10:50:42 [+0200]:

>This version fixes the console things for us. It also increases the
>amount of data we can push over the serial port. If I push the data
>towards our requirements, we're not there yet. I get the "too much work
>for irq" notice still. However, I don't think you'd need to be fixing
>that in this series (or at all). We had similar issues there with
>omap-serial as well.
>
>As far as I'm concerned, this is
>
>Tested-by: Frans Klaver <frans.klaver@xsens.com>

Thanks a lot.
There is a patch named "ARM: edma: unconditionally ack the error
interrupt". I have the feeling that this is not really required once we
delay set_termios. I couldn't reproduce the bug with beagleblack with my
usual test case.

For your "too much work for irq" problem: Could you add trace_printk()
in tx/rx dma start/complete, and irq routine? The interresting part is
what is the irq routine doing once entered. It might be a condition that
is ignored at first and "acked" later while serving another event. Or it
is really doing something and this is more or less "legal".

>Thanks,
>Frans

Sebastian
