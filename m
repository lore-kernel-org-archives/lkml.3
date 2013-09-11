Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3IKOaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:30:06 -0400
Received: from a194-81.smtp-out.amazonses.com ([199.255.194.81]:58230 "EHLO
	a194-81.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947Ab3IKOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:30:04 -0400
Date: Wed, 11 Sep 2013 14:30:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 01/16] slab: correct pfmemalloc check
In-Reply-To: <1377161065-30552-2-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <000001410d6dd2ea-858fd952-3568-44e9-ac6a-070810b732d0-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> And, therefore we should check pfmemalloc in page flag of first page,
> but current implementation don't do that. virt_to_head_page(obj) just
> return 'struct page' of that object, not one of first page, since the SLAB
> don't use __GFP_COMP when CONFIG_MMU. To get 'struct page' of first page,
> we first get a slab and try to get it via virt_to_head_page(slab->s_mem).

Maybe using __GFP_COMP would make it consistent across all allocators and
avoid the issue? We then do only have to set the flags on the first page.
