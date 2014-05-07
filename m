Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaEGWF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:05:29 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36807 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEGWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:05:24 -0400
Date: Wed, 7 May 2014 15:05:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: George Spelvin <linux@horizon.com>
cc: cl@linux.com, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 03/10] slab: move up code to get kmem_cache_node in
 free_block()
In-Reply-To: <20140507215012.11213.qmail@ns.horizon.com>
Message-ID: <alpine.DEB.2.02.1405071502040.25024@chino.kir.corp.google.com>
References: <20140507215012.11213.qmail@ns.horizon.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, George Spelvin wrote:

> > I think this unnecessarily obfuscates the code.
> 
> Thanks for the feedback!  (Even if it's negative, I appreciate it.)
> 
> To me, the confusing thing is the whole passing-a-pointer-to-a-pointer
> business.  How about the following, which makes set_obj_pfmemalloc and
> clear_obj_pfmemalloc take void *, not void **?  Is this better, or worse?
> 

A function called clear_obj_pfmemalloc() doesn't indicate it's returning 
anything, I think the vast majority of people would believe that it 
returns void just as it does.  There's no complier generated code 
optimization with this patch and I'm not sure it's even correct since 
you're now clearing after doing recheck_pfmemalloc_active().

I think it does make sense to remove the pointless "return;" in 
set_obj_pfmemalloc(), however.  Not sure it's worth asking someone to 
merge it, though.
