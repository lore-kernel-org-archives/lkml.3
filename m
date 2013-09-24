Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3IXWSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:18:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3IXWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:18:03 -0400
Date: Tue, 24 Sep 2013 15:18:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Tull <atull@altera.com>
Cc: Michal Simek <monstr@monstr.eu>, Pavel Machek <pavel@denx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20130924221802.GC3837@kroah.com>
References: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <20130919100833.GC19346@amd.pavel.ucw.cz>
 <523AD9C5.8060006@monstr.eu>
 <1379710523.21515.4.camel@atx-linux-37>
 <1380038126.13235.12.camel@atx-linux-37>
 <5241B6BC.1010301@monstr.eu>
 <1380039774.14129.6.camel@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380039774.14129.6.camel@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 11:22:54AM -0500, Alan Tull wrote:
> Yes, I could see /sys/class/fpga/fpga0/image.rbf/loading and 'data' and
> a few others (If I was requesting to load 'image.rbf').  It's a nice
> interface.
> 
> I just used the linux/Documentation/firmware_class/hotplug-script
> without modifications.
> 
> To enable it:
> 
>  * cp linux/Documentation/firmware_class/hotplug-script /lib/udev/
> 
>  * chmod 755 /lib/udev/hotplug-script
> 
>  * Add this udev rule:
>    SUBSYSTEM=="firmware", ACTION=="add", RUN+="/lib/udev/hotplug-script"
> 
>  * Check that there aren't other 'firmware' udev rules to get in the
> way.

Hm, don't do that, all "modern" distros will not do firmware loading
through udev anymore, so please don't try to add it back in.  The kernel
handles the loading of the firmware directly, with no need to call any
usermodehelper program at all.

>  * Add your firmware files to /usr/lib/hotplug/firmware/ or change that
>    path in hotplug-script to point to where your firmware files.
> 
> The default hotplug-script doesn't do anything special (that the kernel
> couldn't do by itself).  What's great is that it could call another
> script that adds headers or does whatever other special un-gzipping or
> other massaging that the firmware image needs before it gets loaded.

Only if you need to do something "special" like this could it justify
not using the in-kernel firmware loader.  Also note that I think future
versions of udev will have the udev firmware loader removed entirely, so
watch out for that.

thanks,

greg k-h
