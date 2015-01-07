Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbbAGDQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:16:55 -0500
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:46200 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105AbbAGDQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:16:54 -0500
Date: Tue, 6 Jan 2015 21:16:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Bryton Lee <brytonlee01@gmail.com>
cc: iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "vger.linux-kernel.cn" <kernel@vger.linux-kernel.cn>
Subject: Re: [PATCH] mm: move MACRO SLAB_NEVER_MERGE and SLAB_MERGE_SAME to
 file linux/slab.h
In-Reply-To: <CAC2pzGe9Q+19LpyFPwr8+TZ02XfCqwrQzsEsJA8WWB6XhuJyeQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501062114240.5674@gentwo.org>
References: <CAC2pzGe9Q+19LpyFPwr8+TZ02XfCqwrQzsEsJA8WWB6XhuJyeQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Bryton Lee wrote:

> move MACRO SLAB_NEVER_MERGE and SLAB_MERGE_SAME from file mm/slab_common.c
> to file linux/slab.h.
> let other kernel code create slab can use these flags.

This does not make sense. The fact that a slab has been merged is
available from a field in the kmem_cache structure (aliases).


These two macros are criteria for the slab allocators to perform merges.
The merge decision is the slab allocators decision and not the decision of
other kernel code.


