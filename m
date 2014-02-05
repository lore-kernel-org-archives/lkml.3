Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaBEA5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:57:49 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56939 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaBEA5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:57:46 -0500
Date: Tue, 4 Feb 2014 16:57:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <alpine.DEB.2.10.1402041444140.11222@nuc>
Message-ID: <alpine.DEB.2.02.1402041657030.26056@chino.kir.corp.google.com>
References: <1391517397-6142-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.10.1402041444140.11222@nuc>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Christoph Lameter wrote:

> > Although this cannot actually result in a race, because on cache
> > destruction there should not be any concurrent frees or allocations from
> > the cache, let's add spin_lock/unlock to free_partial() just to keep
> > lockdep happy.
> 
> Please add a comment that says this in the source so we know why this was
> added.
> 

Makes sense since there is a comment there already saying we don't need 
the lock, then with this patch we end up taking it away.  The nice thing 
is that there should be no lock contention here :)

I'm not sure we need to disable irqs as in the patch, though.
