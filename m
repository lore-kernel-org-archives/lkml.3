Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaHUOO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:14:28 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:39686
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbaHUOO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:14:26 -0400
Date: Thu, 21 Aug 2014 09:14:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mm/slab_common: move kmem_cache definition to internal
 header
In-Reply-To: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1408210913370.32524@gentwo.org>
References: <1408608562-20339-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Joonsoo Kim wrote:

> We don't need to keep kmem_cache definition in include/linux/slab.h
> if we don't need to inline kmem_cache_size(). According to my
> code inspection, this function is only called at lc_create() in
> lib/lru_cache.c which may be called at initialization phase of something,
> so we don't need to inline it. Therfore, move it to slab_common.c and
> move kmem_cache definition to internal header.
>
> After this change, we can change kmem_cache definition easily without
> full kernel build. For instance, we can turn on/off CONFIG_SLUB_STATS
> without full kernel build.

Wow. I did not realize that we were already at that point.

Acked-by: Christoph Lameter <cl@linux.com>
