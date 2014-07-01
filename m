Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306AbaGAWPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:15:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaGAWPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:15:48 -0400
Date: Tue, 1 Jul 2014 15:15:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3 5/9] slab: introduce alien_cache
Message-Id: <20140701151547.fa67354878399575c8eb4647@linux-foundation.org>
In-Reply-To: <1404203258-8923-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1404203258-8923-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1404203258-8923-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 17:27:34 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> -static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
> +static struct alien_cache *__alloc_alien_cache(int node, int entries,
> +						int batch, gfp_t gfp)
> +{
> +	int memsize = sizeof(void *) * entries + sizeof(struct alien_cache);

nit: all five memsizes in slab.c have type `int'.  size_t would be more
appropriate.

> +	struct alien_cache *alc = NULL;
> +
> +	alc = kmalloc_node(memsize, gfp, node);
> +	init_arraycache(&alc->ac, entries, batch);
> +	return alc;
> +}
