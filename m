Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3BBR2E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 12:28:04 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:34055 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3BBR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 12:28:01 -0500
Message-ID: <510D4C8A.4050305@mvista.com>
Date: Sat, 02 Feb 2013 21:27:38 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <2077c13e12314dc3adc8e5b653855da0@DFLE72.ent.ti.com> <20130201185959.GQ2244@beef> <20130202124533.GA2637@n2100.arm.linux.org.uk>
In-Reply-To: <20130202124533.GA2637@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-02-2013 16:45, Russell King - ARM Linux wrote:

> Now, CPPI is brand new code to arch/arm - always has been.  It post-dates
> the DMA engine API.  And it's been said many times about moving it to
> drivers/dma.  The problem is Sergei doesn't want to do it - he's anti the

    I *can't* do it, and I have denied all further responibility for it.

> DMA engine API for whatever reasons he can dream up.  He professes no

    I'm not dreaming anything up. Please understand that CPPI 4.1 is not just 
a normal DMA controller -- it's a complex of several devices with DMA 
controller being only one of them, and one that can't work autonomously but 
only thru the proxy of the queue manager. That queue manager stuff I found 
hard to fit into drivers/dma/ infrastructure. Myabe it was a honest mistake, 
of course.

> knowledge of my dislike for having it in arch/arm, yet there's emails
> from years back showing that he knew about it.  TI knows about it; Ajay
> about it.  Yet... well... history speaks volumes about this.

    Some details have slipped rom my memory after that many years. Im sorry 
for that.

> Now, there may be a new problem with CPPI.  That being we're now requiring
> DT support.  _Had_ this been done prior to the push for DT, then it would
> not have been a concern, because then the problem becomes one for DT.
> But now that OMAP is being converted to DT, and DT is The Way To Go now,
> that's an additional problem that needs to be grappled with - or it may
> make things easier.

    DaVinci is also being converted to device tree. However, that support 
remains optional for now. Not sure it will make things easier, as we still 
have two distinct devices to declare in the device tree: DMA controller and 
queue manager, and we'll have to describe the interconnect between them too 
(as a props of DMA controller I guess)...

WBR, Sergei

