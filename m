Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaFRUWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:22:36 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54802 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaFRUWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:22:35 -0400
Date: Wed, 18 Jun 2014 13:22:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: slab.h: wrap the whole file with guarding macro
In-Reply-To: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.02.1406181321010.10339@chino.kir.corp.google.com>
References: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Andrey Ryabinin wrote:

> Guarding section:
> 	#ifndef MM_SLAB_H
> 	#define MM_SLAB_H
> 	...
> 	#endif
> currently doesn't cover the whole mm/slab.h. It seems like it was
> done unintentionally.
> 
> Wrap the whole file by moving closing #endif to the end of it.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: David Rientjes <rientjes@google.com>

Looks like

ca34956b804b ("slab: Common definition for kmem_cache_node")
e25839f67948 ("mm/slab: Sharing s_next and s_stop between slab and slub
276a2439ce79 ("mm/slab: Give s_next and s_stop slab-specific names")

added onto the header without the guard and it has been this way since 
Jan 10 2013.  Andrey, how did you notice that this was an issue?  Simply 
by visual inspection?
