Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaL3PSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:18:54 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40570 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbaL3PSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:18:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+0JJqEY5b4uoMkE6NZS40pI1Rh5yWhnNc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6B4C363A151
Date: Tue, 30 Dec 2014 10:17:57 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Nadav Haklai <nadavh@marvell.com>, Greg Ungerer <gerg@uclinux.org>,
        Benoit Masson <yahoo@perenite.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "klightspeed @ killerwolves . net" <klightspeed@killerwolves.net>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Florian Fainelli <florian@openwrt.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ryan Press <ryan@presslab.us>, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 00/27] ARM: mvebu: armada-*: Relicense the device tree
 under GPLv2+/X11
Message-ID: <20141230151757.GJ28117@titan.lakedaemon.net>
References: <54930BBC.4060602@free-electrons.com>
 <20141221235000.GC28117@titan.lakedaemon.net>
 <20141222112933.GK19261@kw.sim.vm.gnt>
 <6219619.yRPYbqr6Sm@wuerfel>
 <20141223122233.GR19261@kw.sim.vm.gnt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223122233.GR19261@kw.sim.vm.gnt>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 01:22:33PM +0100, Simon Guinot wrote:
> On Mon, Dec 22, 2014 at 10:14:32PM +0100, Arnd Bergmann wrote:
> > On Monday 22 December 2014 12:29:33 Simon Guinot wrote:
> > > On Sun, Dec 21, 2014 at 06:50:00PM -0500, Jason Cooper wrote:
> > > > On Fri, Dec 19, 2014 at 07:16:16PM +0100, Simon Guinot wrote:
> > > > > > > Especially none of the dove files have a license.
> > > > > > 
> > > > > > Yes, we'll cross that bridge when we get there.  I suspect it then falls
> > > > > > under the over-arching license of the project.  Regardless, we'll still
> > > > > > need Acks from all contributors.
> > > > > 
> > > > > Hi Jason,
> > > > > 
> > > > > What is the problem with keeping the LaCie DTS files under GPLv2+ only ?
> > > > 
> > > > Converting armada-* to dual license is just a small part of the
> > > > overarching effort to convert *all* the devicetree files to dual
> > > > license.  So, eventually, we'll be doing the same with kirkwood, dove
> > > > and orion5x dts{i} files.  Perhaps even during this merge window.
> > > > 
> > > > In the long term, we're attempting to provide one neutral place [1] for
> > > > the bootloaders and kernels to pull devicetrees from and contribute
> > > > changes back to.
> > > 
> > > OK, let's see if I understand correctly.
> > > 
> > > If I don't agree with the GPLv2+/x11 relicensing, then support for
> > > almost all the LaCie boards will be removed from the Linux kernel (maybe
> > > during the next merge window) ? Is that correct ?
> > 
> > Definitely not during the next merge window. Eventually the plan is
> > to remove *all* dts files from the kernel, but we're a long way
> > away from that.
> > 
> > There is already a mirror of the dts files at
> > http://xenbits.xen.org/gitweb/?p=people/ianc/device-tree-rebasing.git;a=summary
> > which is hosting files that are meant to be shared with Xen, which is
> > also under the GPL, and supports a lot of the same hardware that Linux
> > supports, but also depends on passing the correct (modified) dtb blobs
> > to the Dom0 kernel.
> > 
> > The current setup works ok for Xen, but occasionally there are requests
> > for having the files shared more broadly, e.g. with FreeBSD and with boot
> > loaders that might be non-GPL but are used to boot Linux and that want
> > to ship with a default dtb for a platform they run on.
> 
> Minus some details you just provided, that's what I understood in a
> first place.
> 
> > 
> > > Since all the LaCie boards DTS are at least based on my work (except for
> > > the Orion ED Mini v2), I think there is 12 files concerned here. See the
> > > command output: grep -l lacie *.dts | wc -l.
> > > 
> > > The oldest of this boards have been supported by the Linux kernel since
> > > the 2.6.32 release. Also some of this boards are still widely used...
> > > 
> > > You know, it is quite a statement you are sending here: The GPLv2+
> > > licences are not good enough to get an ARM-based board supported by
> > > the Linux kernel, while it has always been the case until now. Are all
> > > the maintainers SoC, ARM SoC, ARM and Linux well aligned with that ?
> > 
> > I think you just misunderstood.
> 
> Jason said:
> 
> "Regrettably, we'll have to revert Simon's dts contributions".
> 
> This words changed my understanding. Then, you confirm I don't have to
> worry about that ?

Yup.  To be clear, this is the part I worded badly. :-/  In my mind, I
was looking at the separate devicetree repo that could be shared
broadly.  *Not* the Linux kernel repo.

> > > Is there any way we can keep the LaCie DTS files licenced under GPLv2+
> > > _and_ still distributed with the others. Anyone would be free to choose
> > > to use them (or not), in respect of the licence terms.
> > 
> > What I suspect will happen is that we end up with multiple repositories
> > for dts files, e.g. one that contains all files that are GPL-compatible
> > and another one that contains the subset that is licensed under more
> > permissive licenses such as the X11 or some BSD license. I don't see
> > a reason for Linux to stop supporting the former, but it would be nice
> > to have a larger shared subset.
> 
> I think it would be indeed a good idea to have a repository with some
> licence separations.
> 
> Thanks for the clarifications.

Thanks for sticking with a difficult conversation.  Let me know what you
think of the idea I proposed in my other email.

thx,

Jason.
