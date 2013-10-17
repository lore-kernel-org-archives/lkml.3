Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401Ab3JQTIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:08:51 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:37272 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758867Ab3JQTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:08:50 -0400
Date: Thu, 17 Oct 2013 19:08:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 08/15] slab: use __GFP_COMP flag for allocating slab
 pages
In-Reply-To: <1381913052-23875-9-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c7d1fae0-ff132cb2-5485-4b8f-9b22-d4da27068681-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-9-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Joonsoo Kim wrote:

> If we use 'struct page' of first page as 'struct slab', there is no
> advantage not to use __GFP_COMP. So use __GFP_COMP flag for all the cases.

Yes this is going to make the allocators behave in the same way. We could
actually put some of the page allocator related functionality in
slab_common.c

Acked-by: Christoph Lameter <cl@linux.com>
