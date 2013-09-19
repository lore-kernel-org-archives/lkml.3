Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3ISWsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:48:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3ISWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:48:23 -0400
Date: Fri, 20 Sep 2013 00:48:21 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg KH <greg@kroah.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Michal Simek <monstr@monstr.eu>,
        Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Message-ID: <20130919224821.GA20481@amd.pavel.ucw.cz>
References: <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <523AD814.1060406@monstr.eu>
 <20130919111719.GA26246@amd.pavel.ucw.cz>
 <523ADE58.2070103@monstr.eu>
 <20130919125237.GA7125@amd.pavel.ucw.cz>
 <20130919140633.GC19943@kroah.com>
 <523B05E6.90605@monstr.eu>
 <20130919142048.GS19937@titan.lakedaemon.net>
 <20130919143715.GA22928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919143715.GA22928@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-09-19 07:37:15, Greg KH wrote:
> On Thu, Sep 19, 2013 at 10:20:48AM -0400, Jason Cooper wrote:
> > On Thu, Sep 19, 2013 at 04:10:46PM +0200, Michal Simek wrote:
> > > On 09/19/2013 04:06 PM, Greg KH wrote:
> > > > On Thu, Sep 19, 2013 at 02:52:37PM +0200, Pavel Machek wrote:
> > > >> On Thu 2013-09-19 13:22:00, Michal Simek wrote:
> > > >>> On 09/19/2013 01:17 PM, Pavel Machek wrote:
> > > >>
> > > >>>>> Status is just there and for my zynq devcfg driver I do export some status
> > > >>>>> bits.
> > > >>>>>
> > > >>>>> root@petalinux:~# cat /sys/class/fpga/fpga0/status
> > > >>>>> partial_bitstream_status: 0
> > > >>>>> prog_done_status: 1
> > > >>>>> dbg_lock_status: 0
> > > >>>>> seu_lock_status: 0
> > > >>>>> aes_en_lock_status: 0
> > > >>>>> aes_status: 0
> > > >>>>> seu_status: 0
> > > >>>>> spniden_status: 1
> > > >>>>> spiden_status: 1
> > > >>>>> niden_status: 1
> > > >>>>> dbgen_status: 1
> > > >>>>> dap_en_status: 7
> > > >>>>
> > > >>>> This is single file? If so, it needs to be changed. Greg is rather
> > > >>>> clear about that.
> > > >>>
> > > >>> Don't you have a link to these rules? I have seen any paragraph from Greg
> > > >>> about it but I forget where was it.
> > > >>
> > > >> "one value per file" and "there must be documentation in
> > > >> Documentation/ for each file" are the rules, iirc.
> > > >>
> > > >> There's Documentation/sysfs-rules.txt, but it does not seem too
> > > >> relevant.
> > > > 
> > > > Documentation/filesystems/sysfs.txt says it.  It probably should be
> > > > added to sysfs-rules.txt as well, but the odds that anyone ever reads
> > > > the documentation is so low I doubt it's even worth it.
> > > > 
> > > > Also, all sysfs files have to be documented in Documentation/ABI/ which
> > > > this patch does not do :(
> > > > 
> > > > And yes, multiple values in a single sysfs file is not allowed at all.
> > > > 
> > > 
> > > ok. I will read that. This is output from my fpga end driver - nothing
> > > what I have sent for review.
> > 
> > If this is useful to you (and others), you could use debugfs for this.
> > The rules there are intentionally a lot more lax.
> 
> Yes, there is only one rule in debugfs, "There is no rules".

Yeah. OTOH, depending on debugfs for normal operation would be
ugly. Don't do that (tm).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
