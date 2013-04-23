Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3DWNQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:16:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab3DWNP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:15:59 -0400
Date: Tue, 23 Apr 2013 15:15:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130423131558.GH8001@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
 <20130418101541.GC2672@localhost.localdomain>
 <20130418175513.GA12581@dhcp22.suse.cz>
 <20130419023345.GE2672@localhost.localdomain>
 <20130419164310.GA29871@dhcp22.suse.cz>
 <20130422031849.GG2672@localhost.localdomain>
 <20130422114052.GB18286@dhcp22.suse.cz>
 <20130423042234.GH2672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423042234.GH2672@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-04-13 12:22:34, Han Pingtian wrote:
> On Mon, Apr 22, 2013 at 01:40:52PM +0200, Michal Hocko wrote:
> > >  CONFIG_PPC_BOOK3S_64=y
> > >  # CONFIG_PPC_BOOK3E_64 is not set
> > > -CONFIG_GENERIC_CPU=y
> > > +# CONFIG_GENERIC_CPU is not set
> > >  # CONFIG_CELL_CPU is not set
> > >  # CONFIG_POWER4_CPU is not set
> > >  # CONFIG_POWER5_CPU is not set
> > >  # CONFIG_POWER6_CPU is not set
> > > -# CONFIG_POWER7_CPU is not set
> > > +CONFIG_POWER7_CPU=y
> > 
> > Wow, so the two configs are for different architectures? Not very much
> > helpful. Could you stick with a single machine and do just small updates
> > to the config to the point where the problem is no longer present,
> > please?
> > 
> No, both configs are for power system. I changed it to
> 'CONFIG_POWER7_CPU' by myself in the good one. I think this difference
> doesn't matter here. 

Ohh, good, I thought it was a x86 thingy. Sorry about the confusion. No
other arch does that...

> > [...]
> > > -CONFIG_SLUB_DEBUG=y
> > > -# CONFIG_COMPAT_BRK is not set
> > > -# CONFIG_SLAB is not set
> > > -CONFIG_SLUB=y
> > > +CONFIG_COMPAT_BRK=y
> > > +CONFIG_SLAB=y
> > 
> > I would start with the bad config and SLUB changed to SLAB in the first
> > step, though.
> > 
> Yep, after I changed bad config to use SLAB, the problem disppears after
> using the new kernel. Looks like something wrong in SLUB?

It seems so or maybe there is a different issue which is just made
visible by SLUB or it is an arch specific problem.
What is the workload that triggers this behavior? Can you reduce it to a
minimum test case?

I guess that you are still testing with vanilla 3.9-rc? kernel without
any additional patches or 3rd party modules, right?

-- 
Michal Hocko
SUSE Labs
