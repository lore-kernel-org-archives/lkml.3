Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaA3VJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:09:55 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62901 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3VJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:09:54 -0500
Date: Thu, 30 Jan 2014 13:09:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on memcg_create_kmem_cache
 fail path
In-Reply-To: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.02.1401301301000.15271@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Vladimir Davydov wrote:

> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Some changelog would be helpful since this fixes an issue already in 
Linus's tree.

Commit 842e2873697e ("memcg: get rid of kmem_cache_dup()") introduced a 
mutex for memcg_create_kmem_cache() to protect the tmp_name buffer that 
holds the memcg name.  It failed to unlock the mutex if this buffer could 
not be allocated.

This patch fixes the issue by appropriately unlocking the mutex if the 
allocation fails.

Acked-by: David Rientjes <rientjes@google.com>


That said, this tmp_name stuff seems totally unnecessary.  
kmem_cache_create_memcg() already does the kstrdup() so why not just pass 
in a pointer to already allocated memory for s->name rather than having 
this mutex or global buffer at all?
