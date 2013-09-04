Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460Ab3IDIdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:33:09 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50176 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab3IDIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:33:07 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-2d-5226f0415ebd
Date: Wed, 4 Sep 2013 17:33:05 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] slab: implement byte sized indexes for the freelist
 of a slab
Message-ID: <20130904083305.GC16355@lge.com>
References: <CAAmzW4N1GXbr18Ws9QDKg7ChN5RVcOW9eEv2RxWhaEoHtw=ctw@mail.gmail.com>
 <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140e42dcd61-00e6cf6a-457c-48bd-8bf7-830133923564-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140e42dcd61-00e6cf6a-457c-48bd-8bf7-830133923564-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 02:15:42PM +0000, Christoph Lameter wrote:
> On Mon, 2 Sep 2013, Joonsoo Kim wrote:
> 
> > This patchset implements byte sized indexes for the freelist of a slab.
> >
> > Currently, the freelist of a slab consist of unsigned int sized indexes.
> > Most of slabs have less number of objects than 256, so much space is wasted.
> > To reduce this overhead, this patchset implements byte sized indexes for
> > the freelist of a slab. With it, we can save 3 bytes for each objects.
> >
> > This introduce one likely branch to functions used for setting/getting
> > objects to/from the freelist, but we may get more benefits from
> > this change.
> >
> > Below is some numbers of 'cat /proc/slabinfo' related to my previous posting
> > and this patchset.
> 
> You  may also want to run some performance tests. The cache footprint
> should also be reduced with this patchset and therefore performance should
> be better.

Yes, I did a hackbench test today, but I'm not ready for posting it.
The performance is improved for my previous posting and futher improvement is
founded by this patchset. Perhaps I will post it tomorrow.

Thanks.
