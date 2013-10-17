Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514Ab3JQTNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:13:40 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:55627 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762224Ab3JQTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:13:39 -0400
Date: Thu, 17 Oct 2013 19:13:38 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 13/15] slab: use struct page for slab management
In-Reply-To: <1381913052-23875-14-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000141c7d66282-aa92b1f2-2a69-424b-9498-8e5367304d32-000000@email.amazonses.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <1381913052-23875-14-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Joonsoo Kim wrote:

> -					 * see PAGE_MAPPING_ANON below.
> -					 */
> +	union {
> +		struct address_space *mapping;	/* If low bit clear, points to
> +						 * inode address_space, or NULL.
> +						 * If page mapped as anonymous
> +						 * memory, low bit is set, and
> +						 * it points to anon_vma object:
> +						 * see PAGE_MAPPING_ANON below.
> +						 */
> +		void *s_mem;			/* slab first object */
> +	};

The overloading of mapping has caused problems in the past since slab
pages are (or are they no longer?) used for DMA to disk. At that point the
I/O subsystem may be expecting a mapping in the page struct if this field
is not NULL.

