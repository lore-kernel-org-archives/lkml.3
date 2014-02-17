Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaBQPfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:35:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34553 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaBQPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:35:52 -0500
Date: Mon, 17 Feb 2014 15:35:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140217153518.30891455@alan.etchedpixels.co.uk>
In-Reply-To: <20140214003834.GH30257@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
	<20140120100415.GX15937@n2100.arm.linux.org.uk>
	<20140213181216.GB24155@kroah.com>
	<20140213181559.GB30257@n2100.arm.linux.org.uk>
	<20140213182701.GA32578@kroah.com>
	<20140213184249.GC30257@n2100.arm.linux.org.uk>
	<20140213232606.GA27372@kroah.com>
	<20140214000717.GG30257@n2100.arm.linux.org.uk>
	<20140214001436.GA16287@kroah.com>
	<20140214003834.GH30257@n2100.arm.linux.org.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How?  What two different busses will see this same device?  The amba bus
> > code should prevent that from happening, right?  If not, there's bigger
> > problems in that bus code :)
> 
> Where is that requirement documented?  It isn't documented.  No one
> implements any kind of locking at the bus level to prevent this, not
> PCI, nor platform devices.

We don't want bus locking. There are lots of busses that can be parallel
probed and in some cases its expensive not to do so. We may well need to
do much more parallel probing in PCI bus in future and we may be parallel
probing multiple bus types at once.

The uart_register hack is simply broken. Nobody can stop you merging it
Greg but in the long term its the wrong approach.

We've identified a correct working approach which is to simply add a
CONFIG entry to the ARM tree and a few ifdefs to the problem drivers to
make the "problem" (in fact a complete fictional non-problem) go away and
to get rid of the mess over time completely as the drivers are set
dynamic and it turns out that all the userspace happens to already handle
this just fine.

Far better than botchfixes to uart registration code that will haunt us
for years.

Alan
