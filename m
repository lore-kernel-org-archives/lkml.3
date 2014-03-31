Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaCaXZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:25:36 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:5693 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaCaXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:25:34 -0400
Message-ID: <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 31 Mar 2014 16:25:32 -0700
In-Reply-To: <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	 <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
	 <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 16:13 -0700, Andrew Morton wrote:
> On Mon, 31 Mar 2014 15:59:33 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > > 
> > > - Shouldn't there be a way to alter this namespace's shm_ctlmax?
> > 
> > Unfortunately this would also add the complexity I previously mentioned.
> 
> But if the current namespace's shm_ctlmax is too small, you're screwed.
> Have to shut down the namespace all the way back to init_ns and start
> again.
> 
> > > - What happens if we just nuke the limit altogether and fall back to
> > >   the next check, which presumably is the rlimit bounds?
> > 
> > afaik we only have rlimit for msgqueues. But in any case, while I like
> > that simplicity, it's too late. Too many workloads (specially DBs) rely
> > heavily on shmmax. Removing it and relying on something else would thus
> > cause a lot of things to break.
> 
> It would permit larger shm segments - how could that break things?  It
> would make most or all of these issues go away?
> 

So sysadmins wouldn't be very happy, per man shmget(2):

EINVAL A new segment was to be created and size < SHMMIN or size >
SHMMAX, or no new segment was to be created, a segment with given key
existed, but size is greater than the size of that segment.

Thanks,
Davidlohr

