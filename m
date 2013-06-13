Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3FMPgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:36:36 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27032 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3FMPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:36:33 -0400
Message-ID: <1371137776.21540.13.camel@misato.fc.hp.com>
Subject: Re: cpu hotplug: possible_cpus broken (again?) next-20130607
From: Toshi Kani <toshi.kani@hp.com>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>,
        Youquan Song <youquan.song@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 13 Jun 2013 09:36:16 -0600
In-Reply-To: <20130613013609.GA6348@linux-youquan.bj.intel.com>
References: <51B79BE5.80804@sr71.net>
	 <20130612123248.GA23978@linux-youquan.bj.intel.com>
	 <CAE9FiQXWi7mn6AM=A2qrHO=3S_oLT7wBRLm19rP987hGzwdqKA@mail.gmail.com>
	 <4005805.V3phb1agMs@vostro.rjw.lan>
	 <20130613013609.GA6348@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 21:36 -0400, Youquan Song wrote:
> > > Interesting, you are changing long standing meaning of maxcpus=
> > > 
> > > We always use maxcpus=1 to have one cpu up, and later in user space
> > > to online other cpus like
> > > echo 1 > /sys/devices/system/cpuX/online.
> > > 
> > > aka maxcpus= is a soft limit or initial online nr.
> > > 
> > > we already have nr_cpus= for hard limit.
> > > 
> > > So need to drop
> > >  commit 3e275a5ba367ab74b3a4e49114307baed989fcac
> > >  Author: Youquan Song <youquan.song@intel.com>
> > >  Date:   Fri Jun 7 10:07:08 2013 +1000
> > > 
> > >      drivers/base/cpu.c: fix maxcpus boot option
> > 
> > Agreed.
> 
> Yes. I also agree to drop it and the fix need more consideration.

Agreed.

> I try use maxcpus to limit cpu number to debug a well known applition 
> because it fail to run when cpu number is larger to > 69. 
> When I use maxcpus at to limit the boot CPUs number, but udev will 
> enable all of the CPUs at 3.10 kernel automatically. 
> I also try maxcpus at 3.0 kernel, it does not show the maxcpus issue. 

I tested Linus's 3.10-rc5 kernel on Fedora 18, but I did not see such
behavior.  Could this be related with your environment?

> I have digged out recently, it is the commit at 3.2 kernel
> 8a25a2fd126c621f44f3aeaef80d51f00fc11639 "cpu: convert 'cpu' and
> 'machinecheck' sysdev_class to a regular subsystem" result in udev
> automatically enable all of CPUs though maxcpus has been provided.
> 
> So the next, I need look at udev try to enable all of CPUs though
> maxcpus provided.  Possibly, it can also fix it in udev daemon.
> 
> Secondly, I think that the maxcpus= option description is too confused in
> Documentation/kernel-parameters.txt. The maxcpus and nr_cpus option need
> switch their name.

I am fine with the clarification.

> Currently:
> 
> 	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
> 			should make use of.  maxcpus=n : n >= 0 limits the
> 			kernel to using 'n' processors.  n=0 is a special case,
> 			it is equivalent to "nosmp", which also disables
> 			the IO APIC.
> 
> How about change to 
> 
> 	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
> 			bring up during booting.  maxcpus=n : n >= 0 limits the

bring -> brings

> 			kernel to using 'n' processors.  n=0 is a special case,
> 			it is equivalent to "nosmp", which also disables
> 			the IO APIC.


Thanks,
-Toshi

