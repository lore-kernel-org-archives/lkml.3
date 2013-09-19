Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3ISPO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:14:56 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:9512
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab3ISPOs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:14:48 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zzbb2dI98dI9371I936eI1dbaI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1379603677.3297.4.camel@atx-linux-37>
Subject: Re: /sys rules Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Greg KH <greg@kroah.com>
CC: Michal Simek <monstr@monstr.eu>, Pavel Machek <pavel@denx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Thu, 19 Sep 2013 10:14:37 -0500
In-Reply-To: <20130919141850.GA21568@kroah.com>
References: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <20130918191517.GQ19937@titan.lakedaemon.net>
	 <20130918203247.GA11181@obsidianresearch.com>
	 <1379539063.31417.23.camel@atx-linux-37> <523AD814.1060406@monstr.eu>
	 <20130919111719.GA26246@amd.pavel.ucw.cz> <523ADE58.2070103@monstr.eu>
	 <20130919125237.GA7125@amd.pavel.ucw.cz> <20130919140633.GC19943@kroah.com>
	 <523B05E6.90605@monstr.eu> <20130919141850.GA21568@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 07:18 -0700, Greg KH wrote:
> On Thu, Sep 19, 2013 at 04:10:46PM +0200, Michal Simek wrote:
> > On 09/19/2013 04:06 PM, Greg KH wrote:
> > > On Thu, Sep 19, 2013 at 02:52:37PM +0200, Pavel Machek wrote:
> > >> On Thu 2013-09-19 13:22:00, Michal Simek wrote:
> > >>> On 09/19/2013 01:17 PM, Pavel Machek wrote:
> > >>
> > >>>>> Status is just there and for my zynq devcfg driver I do export some status
> > >>>>> bits.
> > >>>>>
> > >>>>> root@petalinux:~# cat /sys/class/fpga/fpga0/status
> > >>>>> partial_bitstream_status: 0
> > >>>>> prog_done_status: 1
> > >>>>> dbg_lock_status: 0
> > >>>>> seu_lock_status: 0
> > >>>>> aes_en_lock_status: 0
> > >>>>> aes_status: 0
> > >>>>> seu_status: 0
> > >>>>> spniden_status: 1
> > >>>>> spiden_status: 1
> > >>>>> niden_status: 1
> > >>>>> dbgen_status: 1
> > >>>>> dap_en_status: 7
> > >>>>
> > >>>> This is single file? If so, it needs to be changed. Greg is rather
> > >>>> clear about that.
> > >>>
> > >>> Don't you have a link to these rules? I have seen any paragraph from Greg
> > >>> about it but I forget where was it.
> > >>
> > >> "one value per file" and "there must be documentation in
> > >> Documentation/ for each file" are the rules, iirc.
> > >>
> > >> There's Documentation/sysfs-rules.txt, but it does not seem too
> > >> relevant.
> > > 
> > > Documentation/filesystems/sysfs.txt says it.  It probably should be
> > > added to sysfs-rules.txt as well, but the odds that anyone ever reads
> > > the documentation is so low I doubt it's even worth it.
> > > 
> > > Also, all sysfs files have to be documented in Documentation/ABI/ which
> > > this patch does not do :(
> > > 
> > > And yes, multiple values in a single sysfs file is not allowed at all.
> > > 
> > 
> > ok. I will read that. This is output from my fpga end driver - nothing
> > what I have sent for review.
> > Can you please look at origin patch and tell me what you think about it?
> 
> When I return from LinuxCon/Plumbers and catch up on my pending patch
> queue, I will.  It seems that others have already provided good code
> review, so I suggest sending out a new version with their changes
> integrated and not wait for me.

Michal,

I am currently porting my altera fpga driver to work with your changes.
Please go ahead and post your xilinx fpga driver patch, that would help
accelerate my testing and give us a chance to give more feedback quickly
and arrive a satisfactory solution that will work for more of the key
players here.

Thanks,
ALan

> 
> thanks,
> 
> greg k-h
> 


