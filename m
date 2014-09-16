Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaIPIwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:52:10 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:35120 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaIPIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:52:02 -0400
X-ASG-Debug-ID: 1410857505-0759e77ab4014a0003-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 16 Sep 2014 10:50:37 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tty: omap-serial: use threaded interrupt handler
Message-ID: <20140916085037.GI28458@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 3/4] tty: omap-serial: use threaded interrupt handler
References: <1410789610-23059-1-git-send-email-frans.klaver@xsens.com>
 <1410789610-23059-4-git-send-email-frans.klaver@xsens.com>
 <54170823.7040801@hurleysoftware.com>
 <5417228C.5070503@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5417228C.5070503@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410857508
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9541
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:31:56PM -0400, Peter Hurley wrote:
> On 09/15/2014 11:39 AM, Peter Hurley wrote:
> > On 09/15/2014 10:00 AM, Frans Klaver wrote:
> >> At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 uart
> >> rx buffer overflows within 30 seconds. Threading the interrupt handling reduces
> >> this to about 170 overflows in 10 minutes.
> > 
> > Why is the threadirqs kernel boot option not sufficient?
> > Or conversely, shouldn't this be selectable?
> 

I wasn't aware of the threadirqs boot option. I also wouldn't know if
this should be selectable. What would be a reason to favor the
non-threaded irq over the threaded irq?

> Also, do you see the same performance differential when you implement this
> in the 8250 driver (that is, on top of Sebastian's omap->8250 conversion)?
> 

I haven't gotten Sebastian's driver to work properly yet on the console.
There was no reason for me yet to throw my omap changes on top of
Sebastian's queue.

> > PS - To overflow the 64 byte RX FIFO at those data rates means interrupt
> > latency in excess of 250us?

At 3686400 baud it should take about 174 us to fill a 64 byte buffer. I
haven't done any measurements on the interrupt latency though. If you
consider that we're sending about 1kB of data, 240 times a second, we're
spending a lot of time reading data from the uart. I can imagine the
system has other work to do as well.

This doesn't mean that we're not interested in Sebastian's driver
anymore though. We really want that dma support.

Thanks,
Frans
