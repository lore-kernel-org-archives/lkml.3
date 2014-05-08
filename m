Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaEHAoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 20:44:54 -0400
Received: from ns.horizon.com ([71.41.210.147]:23589 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751469AbaEHAox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 20:44:53 -0400
Date: 7 May 2014 20:44:52 -0400
Message-ID: <20140508004452.27923.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rientjes@google.com
Subject: Re: [PATCH v2 03/10] slab: move up code to get kmem_cache_node in free_block()
Cc: cl@linux.com, iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.02.1405071502040.25024@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A function called clear_obj_pfmemalloc() doesn't indicate it's returning 
> anything, I think the vast majority of people would believe that it 
> returns void just as it does.  There's no complier generated code 
> optimization with this patch and

> I'm not sure it's even correct since 
> you're now clearing after doing recheck_pfmemalloc_active().

I thought this through before rearranging the code.
recheck_pfmemalloc_active() checks global lists, but __ac_get_obj()
is doing clear_obj_pfmemalloc on a local variable.

I think it does make sense to remove the pointless "return;" in 
set_obj_pfmemalloc(), however.  Not sure it's worth asking someone to 
merge it, though.

