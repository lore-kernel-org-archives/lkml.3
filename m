Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3ISKIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:08:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38499 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3ISKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:08:35 -0400
Date: Thu, 19 Sep 2013 12:08:33 +0200
From: Pavel Machek <pavel@denx.de>
To: Alan Tull <atull@altera.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130919100833.GC19346@amd.pavel.ucw.cz>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379539063.31417.23.camel@atx-linux-37>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The firmware approach is interesting.  It might be less flexible
> compared with my original code (see link to git below) that this is

On the other hand... that's the interface world wants, right? To most
users, fpga bitstream is just a firmware.

> Is there some way a per-device userspace helper can be added that can
> handle adding the headers?  Such that different fpga types get different
> helpers?

https://www.kernel.org/doc/Documentation/firmware_class/README

 4), userspace:
     - hotplug: cat appropriate_firmware_image > \
       		    			       /sys/class/firmware/xxx/data

I assume udev's firmware.sh could be modified to add headers.

But... if same bitstream is expected to work across multiple FPGAs (is
it?) maybe kernel should hide that difference and provide headers
itself.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
