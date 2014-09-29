Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaI2Iuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:50:50 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49761 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaI2Iur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:50:47 -0400
X-ASG-Debug-ID: 1411980644-0759e74bdc521d40002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Mon, 29 Sep 2014 10:50:42 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140929085042.GA13952@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
 <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <20140922092853.GH20438@ci00147.xsens-tech.local>
 <20140925151403.GH19396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140925151403.GH19396@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411980644
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10015
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:14:03PM +0200, Sebastian Andrzej Siewior wrote:
> * Frans Klaver | 2014-09-22 11:28:54 [+0200]:
> 
> >I guess then we'd still have to answer the question why the yocto build
> >calls set_termios() so often, but that's not on you then. Did you notice
> >it even changing settings? We might want to fix this even if the kernel
> >should be able to cope.
> 
> could you please test uart_v10_pre3? I dropped a few register sets and
> delayed the register update until TX-DMA is complete. I am traveling
> currently and have only my boneblack and it passes my limited testing.
> If it solves your problems, too then I would address Heikki's latest
> comments and prepare the final v10 (and I hope I didn't break beagle
> board in between).

This version fixes the console things for us. It also increases the
amount of data we can push over the serial port. If I push the data
towards our requirements, we're not there yet. I get the "too much work
for irq" notice still. However, I don't think you'd need to be fixing
that in this series (or at all). We had similar issues there with
omap-serial as well.

As far as I'm concerned, this is

Tested-by: Frans Klaver <frans.klaver@xsens.com>

Thanks,
Frans
