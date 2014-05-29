Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaE2CAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:00:20 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:23205 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaE2CAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:00:16 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Mike Snitzer <snitzer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alasdair Kergon" <agk@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "Neil Brown" <neilb@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq
Thread-Topic: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq
Thread-Index: AQHPej1mNCIvQ1DpmkO6OitmsmFQxptWF2oAgAC21IA=
Date: Thu, 29 May 2014 01:58:02 +0000
Message-ID: <1267BB84A242B24E81E0C0C8955CFFC061A18542@G9W0343.americas.hpqcorp.net>
References: <1401258172-17381-1-git-send-email-zhen-hual@hp.com>
 <20140528150314.GB25249@redhat.com>
In-Reply-To: <20140528150314.GB25249@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested it on 3.14-rc5.
I will checkout the latest kernel and test it on my system for this bug.

Thanks
Zhenhua

-----Original Message-----
From: Mike Snitzer [mailto:snitzer@redhat.com] 
Sent: Wednesday, May 28, 2014 11:03 PM
To: Li, Zhen-Hua
Cc: linux-kernel@vger.kernel.org; Alasdair Kergon; dm-devel@redhat.com; Neil Brown; linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq

On Wed, May 28 2014 at  2:22am -0400,
Li, Zhen-Hua <zhen-hual@hp.com> wrote:

> This patch is trying to fix a kernel crash bug.
> 
> When kernel boots on a HP large system, it crashes.
> The reason is when blk_rq_init is called, the second parameter rq , which
> is a member as q->flush_rq, is NULL. Kernel does not allocate space for it.
> 
> This fix adds an alloc for flush_rq member when request_queue is created in
> struct mapped_device *alloc_dev(int minor);
> 
> Bug Details:
> Error message:
> 
> [   62.931942] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   62.931949] IP: [<ffffffff812b3f30>] blk_rq_init+0x40/0x160^M
> [   62.931949] PGD 0 ^M
> [   62.931951] Oops: 0002 [#1] SMP

You didn't specify which kernel you're running.  But this was fixed for
v3.15-rc6 via linux.git commit 7982e90c3a5 ("block: fix q->flush_rq NULL
pointer crash on dm-mpath flush").  And then there was the follow-on fix
from linux.git commit 708f04d2ab ("block: free q->flush_rq in
blk_init_allocated_queue error paths")

So all this is to say: Nack to your patch, we've already fixed the issue
differently.
