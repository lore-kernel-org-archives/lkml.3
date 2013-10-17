Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284Ab3JQTBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:01:40 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:48442 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758867Ab3JQTBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:01:39 -0400
Date: Thu, 17 Oct 2013 19:01:38 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/5] slab: restrict the number of objects in a slab
In-Reply-To: <1381989797-29269-4-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c7cb668b-1e2528ea-ce87-4380-a0dd-e5be9384cd84-000000@email.amazonses.com>
References: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com> <1381989797-29269-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Thu, 17 Oct 2013, Joonsoo Kim wrote:

> To prepare to implement byte sized index for managing the freelist
> of a slab, we should restrict the number of objects in a slab to be less
> or equal to 256, since byte only represent 256 different values.
> Setting the size of object to value equal or more than newly introduced
> SLAB_MIN_SIZE ensures that the number of objects in a slab is less or
> equal to 256 for a slab with 1 page.

Ok so that results in a mininum size object size of 2^(12 - 8) = 2^4 ==
16 bytes on x86. This is not true for order 1 pages (which SLAB also
supports) where we need 32 bytes.

Problems may arise on PPC or IA64 where the page size may be larger than
64K. With 64K we have a mininum size of 2^(16 - 8) = 256 bytes. For those
arches we may need 16 bit sized indexes. Maybe make that compile time
determined base on page size? > 64KByte results in 16 bit sized indexes?

Otherwise I like this approach. Simplifies a lot and its very cache
friendly.

