Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3ISOGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:06:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38815 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab3ISOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:06:40 -0400
X-Sasl-enc: C1tRr+TmanP8NEfNjBnX5FVS/QyBf7bU4RxxyKcwQsJC 1379599598
Date: Thu, 19 Sep 2013 07:06:33 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@denx.de>
Cc: Michal Simek <monstr@monstr.eu>, Alan Tull <atull@altera.com>,
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
Subject: Re: /sys rules Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130919140633.GC19943@kroah.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <523AD814.1060406@monstr.eu>
 <20130919111719.GA26246@amd.pavel.ucw.cz>
 <523ADE58.2070103@monstr.eu>
 <20130919125237.GA7125@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919125237.GA7125@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 02:52:37PM +0200, Pavel Machek wrote:
> On Thu 2013-09-19 13:22:00, Michal Simek wrote:
> > On 09/19/2013 01:17 PM, Pavel Machek wrote:
> 
> > >> Status is just there and for my zynq devcfg driver I do export some status
> > >> bits.
> > >>
> > >> root@petalinux:~# cat /sys/class/fpga/fpga0/status
> > >> partial_bitstream_status: 0
> > >> prog_done_status: 1
> > >> dbg_lock_status: 0
> > >> seu_lock_status: 0
> > >> aes_en_lock_status: 0
> > >> aes_status: 0
> > >> seu_status: 0
> > >> spniden_status: 1
> > >> spiden_status: 1
> > >> niden_status: 1
> > >> dbgen_status: 1
> > >> dap_en_status: 7
> > > 
> > > This is single file? If so, it needs to be changed. Greg is rather
> > > clear about that.
> > 
> > Don't you have a link to these rules? I have seen any paragraph from Greg
> > about it but I forget where was it.
> 
> "one value per file" and "there must be documentation in
> Documentation/ for each file" are the rules, iirc.
> 
> There's Documentation/sysfs-rules.txt, but it does not seem too
> relevant.

Documentation/filesystems/sysfs.txt says it.  It probably should be
added to sysfs-rules.txt as well, but the odds that anyone ever reads
the documentation is so low I doubt it's even worth it.

Also, all sysfs files have to be documented in Documentation/ABI/ which
this patch does not do :(

And yes, multiple values in a single sysfs file is not allowed at all.

thanks,

greg k-h
