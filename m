Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3CUUan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:30:43 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:32111 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752156Ab3CUUam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:30:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19hrjHFxQGoNfPfN6+2ea1cWivdkOYWJbI=
Date: Thu, 21 Mar 2013 16:30:26 -0400
From: Jason Cooper <jason@lakedaemon.net>
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
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64
 bits
Message-ID: <20130321203026.GF13280@titan.lakedaemon.net>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
 <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com>
 <20130321201533.GN21478@lunn.ch>
 <20130321212236.1015295d@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321212236.1015295d@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:22:36PM +0100, Thomas Petazzoni wrote:
> Dear Andrew Lunn,
> 
> On Thu, 21 Mar 2013 21:15:33 +0100, Andrew Lunn wrote:
> 
> > Could you recommend a document which introduces LPAE.
> > 
> > Only being able to address 7GB seems a bit odd to me. I kind of
> > expected you set up the translation tables to map a page in the 32 bit
> > address range to any arbitrary page in the 40 bit address range. So
> > leaving 0xC0000000 to 0xffffffff in the 32bit address range clear is
> > easy. But why do you loose space in the 40bit address range?
> 
> translation tables convert virtual addresses to physical addresses.
> Here, we are only talking about physical addresses. There is an overlap
> between the physical addresses used by the RAM, and the physical
> addresses at which I/O devices are visible.
> 
> And I'm not sure the SDRAM address decoding windows allows to split the
> first 4 GB of RAM into two areas, one that would be mapped starting at
> physical address 0x0, and another area that would be mapped at a
> different address (above 4 GB).
> 
> However, I'm unsure why 0xC0000000 was chosen. Why not 0xD0000000,
> where the internal registers currently start?

I had the same question earlier but got distracted by other things.
Thanks for bringing it up.  Gregory, shouldn't this be 0xD0000000?

thx,

Jason.
