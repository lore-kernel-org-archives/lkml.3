Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaDUQ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:29:32 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:55654 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166AbaDUQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:29:23 -0400
Date: Mon, 21 Apr 2014 11:29:20 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Glauber Costa <glommer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>, devel@openvz.org
Subject: Re: [RFC] how should we deal with dead memcgs' kmem caches?
In-Reply-To: <5353A3E3.4020302@parallels.com>
Message-ID: <alpine.DEB.2.10.1404211128450.28094@gentwo.org>
References: <5353A3E3.4020302@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2014, Vladimir Davydov wrote:

> * Way #1 - prevent dead kmem caches from caching slabs on free *
>
> We can modify sl[au]b implementation so that it won't cache any objects
> on free if the kmem cache belongs to a dead memcg. Then it'd be enough
> to drain per-cpu pools of all dead kmem caches on css offline - no new
> slabs will be added there on further frees, and the last object will go
> away along with the last slab.

You can call kmem_cache_shrink() to force slab allocators to drop cached
objects after a free.
