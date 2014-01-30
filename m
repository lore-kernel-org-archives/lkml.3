Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaA3WEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:04:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47308 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3WEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:04:14 -0500
Date: Thu, 30 Jan 2014 14:04:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on memcg_create_kmem_cache
 fail path
In-Reply-To: <20140130135002.22ce1c12b7136f75e5985df6@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401301403090.15271@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com> <20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org> <alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com> <20140130132939.96a25a37016a12f9a0093a90@linux-foundation.org>
 <alpine.DEB.2.02.1401301336530.15271@chino.kir.corp.google.com> <20140130135002.22ce1c12b7136f75e5985df6@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Andrew Morton wrote:

> > Yeah, it shouldn't be temporary it should be the one and only allocation.  
> > We should construct the name in memcg_create_kmem_cache() and be done with 
> > it.
> 
> Could.  That would require converting memcg_create_kmem_cache() to take 
> a va_list and call kasprintf() on it.
> 

Why?  We already construct the name in memcg_create_kmem_cache() 
appropriately, we just want to avoid the kstrdup() in 
kmem_cache_create_memcg() since it's pointless like my patch does.
