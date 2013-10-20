Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3JTSIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 14:08:47 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:59430 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949Ab3JTSIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 14:08:46 -0400
Date: Sun, 20 Oct 2013 18:08:44 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: JoonSoo Kim <js1304@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/5] slab: restrict the number of objects in a slab
In-Reply-To: <CAAmzW4Mzx0FWP6KK7gk88c07RP46WaA9i5DePnzSWt7XP6qQNw@mail.gmail.com>
Message-ID: <00000141d70e0e22-bd66f3af-822a-47dd-bbd9-fe68ad8da2ff-000000@email.amazonses.com>
References: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com> <1381989797-29269-4-git-send-email-iamjoonsoo.kim@lge.com> <00000141c7cb668b-1e2528ea-ce87-4380-a0dd-e5be9384cd84-000000@email.amazonses.com>
 <CAAmzW4Mzx0FWP6KK7gk88c07RP46WaA9i5DePnzSWt7XP6qQNw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.20-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Oct 2013, JoonSoo Kim wrote:

> > Ok so that results in a mininum size object size of 2^(12 - 8) = 2^4 ==
> > 16 bytes on x86. This is not true for order 1 pages (which SLAB also
> > supports) where we need 32 bytes.
>
> According to current slab size calculating logic, slab whose object size is
> less or equal to 16 bytes use only order 0 page. So there is no problem.

Ok then lets add a VM_BUG_ON to detect the situation when someone tries
something different.

> > Problems may arise on PPC or IA64 where the page size may be larger than
> > 64K. With 64K we have a mininum size of 2^(16 - 8) = 256 bytes. For those
> > arches we may need 16 bit sized indexes. Maybe make that compile time
> > determined base on page size? > 64KByte results in 16 bit sized indexes?
>
> Okay. I will try it.

Again compile time. You had runtime in some earlier patches which adds new
branches to key functions.

