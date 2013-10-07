Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3JGPUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:20:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:2271 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab3JGPUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:20:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1050,1371106800"; 
   d="scan'208";a="412792254"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Topic: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Index: AQHOv3vIHe5gOhmSsEGBHPLZHDmcI5nkkbDAgADFEYCABAvHUA==
Date: Mon, 7 Oct 2013 15:20:28 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B079B@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211B0176@FMSMSX107.amr.corp.intel.com>
 <20131004183315.GA19557@quack.suse.cz>
In-Reply-To: <20131004183315.GA19557@quack.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz]
> Sent: Friday, October 04, 2013 2:33 PM
> To: Marciniszyn, Mike
> Cc: Jan Kara; LKML; linux-mm@kvack.org; infinipath; Roland Dreier; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH 23/26] ib: Convert qib_get_user_pages() to
> get_user_pages_unlocked()
> 
> On Fri 04-10-13 13:52:49, Marciniszyn, Mike wrote:
> > > Convert qib_get_user_pages() to use get_user_pages_unlocked().  This
> > > shortens the section where we hold mmap_sem for writing and also
> > > removes the knowledge about get_user_pages() locking from ipath
> > > driver. We also fix a bug in testing pinned number of pages when
> changing the code.
> > >
> >
> > This patch and the sibling ipath patch will nominally take the mmap_sem
> > twice where the old routine only took it once.   This is a performance
> > issue.
>   It will take mmap_sem only once during normal operation. Only if
> get_user_pages_unlocked() fail, we have to take mmap_sem again to undo
> the change of mm->pinned_vm.
> 
> > Is the intent here to deprecate get_user_pages()?
>   Well, as much as I'd like to, there are really places in mm code which need
> to call get_user_pages() while holding mmap_sem to be able to inspect
> corresponding vmas etc. So I want to reduce get_user_pages() use as much
> as possible but I'm not really hoping in completely removing it.
> 
> > I agree, the old code's lock limit test is broke and needs to be fixed.
> > I like the elimination of the silly wrapper routine!
> >
> > Could the lock limit test be pushed into another version of the
> > wrapper so that there is only one set of mmap_sem transactions?
>   I'm sorry, I don't understand what you mean here...
> 
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
