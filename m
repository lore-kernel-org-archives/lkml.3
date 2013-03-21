Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3CUVlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:41:47 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56843 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3CUVlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:41:46 -0400
Date: Thu, 21 Mar 2013 15:41:32 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Lior Amsalem <alior@marvell.com>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Message-ID: <20130321214132.GB8431@obsidianresearch.com>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
 <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
 <20130321201533.GN21478@lunn.ch>
 <20130321212236.1015295d@skate>
 <20130321205545.GA8358@obsidianresearch.com>
 <20130321221523.7ede6ccc@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321221523.7ede6ccc@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:15:23PM +0100, Thomas Petazzoni wrote:
> Dear Jason Gunthorpe,
> 
> On Thu, 21 Mar 2013 14:55:45 -0600, Jason Gunthorpe wrote:
> 
> > Or, better, locate all the internal registers above 8G and use
> > contiguous DRAM mapping from 0 -> 8GB
> 
> I see two potential issues with this idea:
> 
>  *) It only works when LPAE is enabled, so we would have to have
>     different internal register addresses depending on whether LPAE is
>     enabled or not. Probably not impossible, but not very
>     straightforward either.

Ideally the internal register space address would come from the DT -
we are getting very close to that on Marvell, I think.. Things like
earlyprintk should ideally early parse the DT, harder I know :(

>  *) It would require Linux to change the internal registers address
>     (for now the kernel relies on the bootloader). The problem is that
>     we can't do it early enough to preserve the earlyprintk
>     functionality. Maybe you have suggestions on how to achieve that?

I can't forsee how Linux could do this reprogramming - not only do you
have to move the registers, you'd also have to reprogram the DRAM
bases, while running from the DRAM. Not only does that have to be done
early, but the DT would need to describe the DRAM ranks, and the code
would have to parse it.. On top of that it would have to be very
careful not to wack any DRAM that has already been touched by the
kernel.. Tricky stuff :)

Jason
