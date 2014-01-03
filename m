Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaACQAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:00:15 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:60939 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaACQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:00:14 -0500
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jan 2014 11:00:14 EST
Date: Fri, 3 Jan 2014 11:48:20 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: David Vrabel <david.vrabel@citrix.com>, stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com
Subject: Re: [Xen-devel] [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver (v2)
Message-ID: <20140103154820.GA20976@andromeda.dapyr.net>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com> <52C59483.5030607@citrix.com> <20140102185023.GG3021@pegasus.dumpdata.com> <52C6A4E5.3080904@citrix.com> <20140103144409.GC27019@phenom.dumpdata.com> <52C6DA3F.7070509@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C6DA3F.7070509@citrix.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 03:41:51PM +0000, David Vrabel wrote:
> On 03/01/14 14:44, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jan 03, 2014 at 11:54:13AM +0000, David Vrabel wrote:
> >> On 02/01/14 18:50, Konrad Rzeszutek Wilk wrote:
> >>> On Thu, Jan 02, 2014 at 04:32:03PM +0000, David Vrabel wrote:
> >>>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> >>>>> @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
> >>>>>  	return gnttab_init();
> >>>>>  }
> >>>>>  
> >>>>> -core_initcall(__gnttab_init);
> >>>>> +core_initcall_sync(__gnttab_init);
> >>>>
> >>>> Why has this become _sync?
> >>>
> >>> It needs to run _after_ the xen_pvh_gnttab_setup has run (which is
> >>> at gnttab_init):
> >>
> >>
> >> The use of core_initcall_sync() doesn't imply any ordering to me.  Can't
> > 
> > It has a clear ordering property.
> 
> This really isn't obvious to me.  Can you point to the docs/code the
> guarantee this?  I couldn't find it.

include/linux/init.h
> 
> >> you call xen_pvh_gnttab_setup() from within __gnttab_init() ?
> > 
> > No. That is due to the fact that __gnttab_init() is in drivers/xen and is
> > also used by the ARM code.
> > 
> > Stefano in his previous review mentioned he would like PVH specific
> > code in arch/x86:
> > 
> > https://lkml.org/lkml/2013/12/18/507
> 
> Call it xen_arch_gnttab_setup() and add weak stub for other architectures?

Stefano, thoughts?

> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
