Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbaKDQlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:41:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:21445 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaKDQlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:41:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="602083918"
Message-ID: <1415119296.26199.12.camel@theros.lm.intel.com>
Subject: Re: [PATCH 1/4] pmem: Initial version of persistent memory driver
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Boaz Harrosh <boaz@plexistor.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>,
        "Kani, Toshimitsu" <toshi.kani@hp.com>,
        "Knippers, Linda" <linda.knippers@hp.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Date: Tue, 04 Nov 2014 09:41:36 -0700
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295936C4B1@G4W3202.americas.hpqcorp.net>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	 <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
	 <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>
	 <5458AC75.3030207@plexistor.com>
	 <94D0CD8314A33A4D9D801C0FE68B40295936C4B1@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 16:26 +0000, Elliott, Robert (Server Storage)
wrote:
> 
> > -----Original Message-----
> > From: Boaz Harrosh [mailto:boaz@plexistor.com]
> > Sent: Tuesday, 04 November, 2014 4:38 AM
> > To: Wilcox, Matthew R; Elliott, Robert (Server Storage); Ross
> > Zwisler; Jens Axboe; Nick Piggin; Kani, Toshimitsu; Knippers, Linda;
> > linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> > nvdimm@lists.01.org; Matthew Wilcox
> > Subject: Re: [PATCH 1/4] pmem: Initial version of persistent memory
> > driver
> > 
> > On 11/03/2014 06:19 PM, Wilcox, Matthew R wrote:
> ...
> > 
> > I wish you guys would actually review the correct code.
> > 
> > In the actual good driver that has any shape of proper code all these
> > issue are gone.
> > 
> > * config defaults gone, multiple-devices multiple-memory ranges fully
> >    supported hot plug style.
> > * above shifts cruft completely gone it is left overs from brd.c and
> >   its page usage.
> > * getgeo fixed to do what we realy want by the only application on earth
> >   that still uses it, fdisk. All other partitioners do not call it at
> >   all.
> > 
> > Why are we reviewing dead code ?
> > 
> > Cheers
> > Boaz
> 
> Ross, what's the status of Boaz' patches (available in
> git://git.open-osd.org/pmem.git)?
> 
> https://github.com/01org/prd.git doesn't include any of 
> them yet.

Hey Robert,

The UEFI organization is in the process of defining a generic specification
for platform non-volatile memory resources.  Essentially the thought was to
wait until that was publicly available before adding any new device discovery
capabilities to pmem.

What Boaz has suggested and coded up is certainly useful, but the worry is
that it will end up being incompatible with what comes out of UEFI.  If we
stay with the dead-simple module parameter method, we will have less code to
unwind later.

Thanks,
- Ross


