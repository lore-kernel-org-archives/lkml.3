Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab3ICOPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:15:45 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:55813 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab3ICOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:15:44 -0400
Date: Tue, 3 Sep 2013 14:15:42 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] slab: implement byte sized indexes for the freelist
 of a slab
In-Reply-To: <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140e42dcd61-00e6cf6a-457c-48bd-8bf7-830133923564-000000@email.amazonses.com>
References: <CAAmzW4N1GXbr18Ws9QDKg7ChN5RVcOW9eEv2RxWhaEoHtw=ctw@mail.gmail.com> <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.03-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013, Joonsoo Kim wrote:

> This patchset implements byte sized indexes for the freelist of a slab.
>
> Currently, the freelist of a slab consist of unsigned int sized indexes.
> Most of slabs have less number of objects than 256, so much space is wasted.
> To reduce this overhead, this patchset implements byte sized indexes for
> the freelist of a slab. With it, we can save 3 bytes for each objects.
>
> This introduce one likely branch to functions used for setting/getting
> objects to/from the freelist, but we may get more benefits from
> this change.
>
> Below is some numbers of 'cat /proc/slabinfo' related to my previous posting
> and this patchset.

You  may also want to run some performance tests. The cache footprint
should also be reduced with this patchset and therefore performance should
be better.

