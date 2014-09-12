Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaILK2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:28:22 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:54926 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaILK2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:28:20 -0400
X-ASG-Debug-ID: 1410517697-0759e72d3e6fd320002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Fri, 12 Sep 2014 12:28:16 +0200
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
Message-ID: <20140912102816.GF28458@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <20140911111721.GB17476@xps8300>
 <54118AAB.2010205@linutronix.de>
 <5411967A.6090406@hurleysoftware.com>
 <54119AAA.9080907@linutronix.de>
 <20140911151114.GD28458@ci00147.xsens-tech.local>
 <5411C810.7070906@linutronix.de>
 <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
 <54129F6C.7040508@linutronix.de>
 <20140912094010.GE28458@ci00147.xsens-tech.local>
 <5412C21A.8020203@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5412C21A.8020203@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410517697
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9398
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:51:22AM +0200, Sebastian Andrzej Siewior wrote:
> On 09/12/2014 11:40 AM, Frans Klaver wrote:
> 
> > I'm not sure. I just reproduced this on a boneblack, using your uart_v9
> > branch.
> > 
> >> This problem only pops-up if you use DMA. With disabled DMA you don't
> >> see this, right?
> > 
> > I get the lockup both with and without DMA enabled. Here's the 8250
> > config I use. Our full .config is attached in case it may provide
> > something relevant.
> 
> Hmm. I have a bone black here. Can you tell what you did to get this
> lockup? The port configuration (unless 115200 8N1) and what you did to
> get this lockup.

port config is 115200 8N1. I don't recall doing anything special. I
boot, login, less file and get a lock.


> > Something that may also help: when I have a lockup on the boneblack, dma
> > is enabled and something is written to console like I described earlier,
> > I get the following bad irq:
> 
> > Full dmesg is also attached.
> 
> This one should be stuffed by this:
> 	"[RFC] ARM: edma: unconditionally ack the error interrupt"
> 	https://lkml.org/lkml/2014/9/10/714

OK, that makes the console usable again after I write something to kmsg.

> > Hope you find something useful in there.
> 
> > Thanks,
> > Frans
> 
> Sebastian
