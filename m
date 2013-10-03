Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3JCAF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:05:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab3JCAF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:05:27 -0400
Date: Wed, 2 Oct 2013 20:01:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>
cc: Dave Chinner <david@fromorbit.com>, devel@driverdev.osuosl.org,
        snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Akira Hayakawa <ruby.wktk@gmail.com>,
        dm-devel@redhat.com, agk@redhat.com, joe@perches.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com, ejt@redhat.com,
        cesarb@cesarb.net, m.chehab@samsung.com
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add
 dm-writeboost]
In-Reply-To: <20131001082654.GA10326@debian>
Message-ID: <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130926034325.GO26872@dastard>
 <20131001082654.GA10326@debian>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Oct 2013, Joe Thornber wrote:

> > Alternatively, delaying them will stall the filesystem because it's
> > waiting for said REQ_FUA IO to complete. For example, journal writes
> > in XFS are extremely IO latency sensitive in workloads that have a
> > signifincant number of ordering constraints (e.g. O_SYNC writes,
> > fsync, etc) and delaying even one REQ_FUA/REQ_FLUSH can stall the
> > filesystem for the majority of that barrier_deadline_ms.
> 
> Yes, this is a valid concern, but I assume Akira has benchmarked.
> With dm-thin, I delay the REQ_FUA/REQ_FLUSH for a tiny amount, just to
> see if there are any other FUA requests on my queue that can be
> aggregated into a single flush.  I agree with you that the target
> should never delay waiting for new io; that's asking for trouble.
> 
> - Joe

You could send the first REQ_FUA/REQ_FLUSH request directly to the disk 
and aggregate all the requests that were received while you processed the 
initial request. This way, you can do request batching without introducing 
artifical delays.

Mikulas
