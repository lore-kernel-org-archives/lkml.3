Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaBRQVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:21:18 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:55442
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715AbaBRQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:21:13 -0500
Date: Tue, 18 Feb 2014 10:21:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] slab: remove a useless lockdep annotation
In-Reply-To: <20140217061201.GA3468@lge.com>
Message-ID: <alpine.DEB.2.10.1402181019550.28591@nuc>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-10-git-send-email-iamjoonsoo.kim@lge.com> <alpine.DEB.2.10.1402141248560.12887@nuc> <20140217061201.GA3468@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Joonsoo Kim wrote:

> > Why change the BAD_ALIEN_MAGIC?
>
> Hello, Christoph.
>
> BAD_ALIEN_MAGIC is only checked by slab_set_lock_classes(). We remove this
> function in this patch, so returning BAD_ALIEN_MAGIC is useless.

Its not useless. The point is if there is a pointer deref then we will see
this as a pointer value and know that it is realted to alien cache
processing.

> And, in fact, BAD_ALIEN_MAGIC is already useless, because alloc_alien_cache()
> can't be called on !CONFIG_NUMA. This function is called if use_alien_caches
> is positive, but on !CONFIG_NUMA, use_alien_caches is always 0. So we don't
> have any chance to meet this BAD_ALIEN_MAGIC in runtime.

Maybe it no longer serves a point. But note that caches may not be
populated because processors/nodes are not up yet.

