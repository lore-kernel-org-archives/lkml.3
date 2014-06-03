Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaFCBfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:35:07 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33897 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaFCBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:35:05 -0400
Date: Mon, 2 Jun 2014 18:35:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm] slab: delete cache from list after __kmem_cache_shutdown
 succeeds
In-Reply-To: <1400159291-5330-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.02.1406021834500.13072@chino.kir.corp.google.com>
References: <1400159291-5330-1-git-send-email-vdavydov@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Vladimir Davydov wrote:

> Currently, on kmem_cache_destroy we delete the cache from the slab_list
> before __kmem_cache_shutdown, inserting it back to the list on failure.
> Initially, this was done, because we could release the slab_mutex in
> __kmem_cache_shutdown to delete sysfs slub entry, but since commit
> 41a212859a4d ("slub: use sysfs'es release mechanism for kmem_cache") we
> remove sysfs entry later in kmem_cache_destroy after dropping the
> slab_mutex, so that no implementation of __kmem_cache_shutdown can ever
> release the lock. Therefore we can simplify the code a bit by moving
> list_del after __kmem_cache_shutdown.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: David Rientjes <rientjes@google.com>
