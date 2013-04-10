Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955Ab3DJWId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:08:33 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48847 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3DJWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:08:32 -0400
Date: Wed, 10 Apr 2013 15:08:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Toshi Kani <toshi.kani@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v3 2/3] resource: Add release_mem_region_adjustable()
In-Reply-To: <1365630585.32127.110.camel@misato.fc.hp.com>
Message-ID: <alpine.DEB.2.02.1304101505250.1526@chino.kir.corp.google.com>
References: <1365614221-685-1-git-send-email-toshi.kani@hp.com> <1365614221-685-3-git-send-email-toshi.kani@hp.com> <20130410144412.395bf9f2fb8192920175e30a@linux-foundation.org> <1365630585.32127.110.camel@misato.fc.hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Toshi Kani wrote:

> > I'll switch it to GFP_ATOMIC.  Which is horridly lame but the
> > allocation is small and alternatives are unobvious.
> 
> Great!  Again, thanks for the update!

release_mem_region_adjustable() allocates at most one struct resource, so 
why not do kmalloc(sizeof(struct resource), GFP_KERNEL) before taking 
resource_lock and then testing whether it's NULL or not when splitting?  
It unnecessarily allocates memory when there's no split, but 
__remove_pages() shouldn't be a hotpath.
