Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaBNXSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:18:06 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49588 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBNXSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:18:04 -0500
Date: Fri, 14 Feb 2014 15:18:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 2/9] slab: makes clear_obj_pfmemalloc() just return store
 masked value
In-Reply-To: <alpine.DEB.2.10.1402141225460.12887@nuc>
Message-ID: <alpine.DEB.2.02.1402141516540.13935@chino.kir.corp.google.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com> <1392361043-22420-3-git-send-email-iamjoonsoo.kim@lge.com> <alpine.DEB.2.10.1402141225460.12887@nuc>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Christoph Lameter wrote:

> > @@ -215,9 +215,9 @@ static inline void set_obj_pfmemalloc(void **objp)
> >  	return;
> >  }
> >
> > -static inline void clear_obj_pfmemalloc(void **objp)
> > +static inline void *clear_obj_pfmemalloc(void *objp)
> >  {
> > -	*objp = (void *)((unsigned long)*objp & ~SLAB_OBJ_PFMEMALLOC);
> > +	return (void *)((unsigned long)objp & ~SLAB_OBJ_PFMEMALLOC);
> >  }
> 
> I dont think you need the (void *) cast here.
> 

Yeah, you don't need it, but don't you think it makes the code more 
readable?  Otherwise this is going to be just doing

	return (unsigned long)objp & ~SLAB_OBJ_PFMEMALLOC;

and you gotta figure out the function type to understand it's returned as 
a pointer.
