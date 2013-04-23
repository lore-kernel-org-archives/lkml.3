Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3DWEWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:22:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57124 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3DWEWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:22:44 -0400
Date: Tue, 23 Apr 2013 12:22:34 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, rientjes@google.com
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130423042234.GH2672@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org, mhocko@suse.cz,
	rientjes@google.com
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
 <20130417141909.GA24912@dhcp22.suse.cz>
 <20130418101541.GC2672@localhost.localdomain>
 <20130418175513.GA12581@dhcp22.suse.cz>
 <20130419023345.GE2672@localhost.localdomain>
 <20130419164310.GA29871@dhcp22.suse.cz>
 <20130422031849.GG2672@localhost.localdomain>
 <20130422114052.GB18286@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422114052.GB18286@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042304-3620-0000-0000-000002249577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 01:40:52PM +0200, Michal Hocko wrote:
> >  CONFIG_PPC_BOOK3S_64=y
> >  # CONFIG_PPC_BOOK3E_64 is not set
> > -CONFIG_GENERIC_CPU=y
> > +# CONFIG_GENERIC_CPU is not set
> >  # CONFIG_CELL_CPU is not set
> >  # CONFIG_POWER4_CPU is not set
> >  # CONFIG_POWER5_CPU is not set
> >  # CONFIG_POWER6_CPU is not set
> > -# CONFIG_POWER7_CPU is not set
> > +CONFIG_POWER7_CPU=y
> 
> Wow, so the two configs are for different architectures? Not very much
> helpful. Could you stick with a single machine and do just small updates
> to the config to the point where the problem is no longer present,
> please?
> 
No, both configs are for power system. I changed it to
'CONFIG_POWER7_CPU' by myself in the good one. I think this difference
doesn't matter here. 
> [...]
> > -CONFIG_SLUB_DEBUG=y
> > -# CONFIG_COMPAT_BRK is not set
> > -# CONFIG_SLAB is not set
> > -CONFIG_SLUB=y
> > +CONFIG_COMPAT_BRK=y
> > +CONFIG_SLAB=y
> 
> I would start with the bad config and SLUB changed to SLAB in the first
> step, though.
> 
Yep, after I changed bad config to use SLAB, the problem disppears after
using the new kernel. Looks like something wrong in SLUB?

Thanks.
> [...]
> -- 
> Michal Hocko
> SUSE Labs

