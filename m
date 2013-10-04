Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3JDNjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:39:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:41362 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3JDNjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:39:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1033,1371106800"; 
   d="scan'208";a="369811237"
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
Thread-Index: AQHOv4QLcKrfhiX4106LS7dZ0ASSH5nhidXggAB3bQCAAo3gUA==
Date: Fri, 4 Oct 2013 13:39:03 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B0123@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AEF75@FMSMSX107.amr.corp.intel.com>
 <20131002152811.GC32181@quack.suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
 <20131002153842.GD32181@quack.suse.cz>
In-Reply-To: <20131002153842.GD32181@quack.suse.cz>
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
> Sent: Wednesday, October 02, 2013 11:39 AM
> To: Marciniszyn, Mike
> Cc: Jan Kara; LKML; linux-mm@kvack.org; infinipath; Roland Dreier; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH 23/26] ib: Convert qib_get_user_pages() to
> get_user_pages_unlocked()
> 
> On Wed 02-10-13 15:32:47, Marciniszyn, Mike wrote:
> > > > The risk of GUP fast is the loss of the "force" arg on GUP fast,
> > > > which I don't see as significant give our use case.
> > >   Yes. I was discussing with Roland some time ago whether the force
> > > argument is needed and he said it is. So I kept the arguments of
> > > get_user_pages() intact and just simplified the locking...
> >
> > The PSM side of the code is a more traditional use of GUP (like direct
> > I/O), so I think it is a different use case than the locking for IB
> > memory regions.
>   Ah, I see. Whatever suits you best. I don't really care as long as
> get_user_pages() locking doesn't leak into IB drivers :)
> 
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
