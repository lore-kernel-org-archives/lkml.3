Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaDBBRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 21:17:32 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35295 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaDBBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 21:17:30 -0400
References: <cover.1396335798.git.vdavydov@parallels.com> <031f9e2374dcb4cb6c2e7d509d1276623d5b1fba.1396335798.git.vdavydov@parallels.com>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Greg Thelen <gthelen@google.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        glommer@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        devel@openvz.org
Subject: Re: [PATCH -mm v2 1/2] sl[au]b: charge slabs to kmemcg explicitly
In-reply-to: <031f9e2374dcb4cb6c2e7d509d1276623d5b1fba.1396335798.git.vdavydov@parallels.com>
Date: Tue, 01 Apr 2014 17:49:34 -0700
Message-ID: <xr938urok129.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Apr 01 2014, Vladimir Davydov <vdavydov@parallels.com> wrote:

> We have only a few places where we actually want to charge kmem so
> instead of intruding into the general page allocation path with
> __GFP_KMEMCG it's better to explictly charge kmem there. All kmem
> charges will be easier to follow that way.
>
> This is a step towards removing __GFP_KMEMCG. It removes __GFP_KMEMCG
> from memcg caches' allocflags. Instead it makes slab allocation path
> call memcg_charge_kmem directly getting memcg to charge from the cache's
> memcg params.
>
> This also eliminates any possibility of misaccounting an allocation
> going from one memcg's cache to another memcg, because now we always
> charge slabs against the memcg the cache belongs to. That's why this
> patch removes the big comment to memcg_kmem_get_cache.
>
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Greg Thelen <gthelen@google.com>
