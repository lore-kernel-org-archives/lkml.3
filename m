Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaAOFF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:05:57 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:59503 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOFFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:05:54 -0500
Date: Tue, 14 Jan 2014 21:05:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 3/5] slab: restrict the number of objects in a slab
In-Reply-To: <1385974183-31423-4-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1401142105380.7751@chino.kir.corp.google.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com> <1385974183-31423-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Joonsoo Kim wrote:

> To prepare to implement byte sized index for managing the freelist
> of a slab, we should restrict the number of objects in a slab to be less
> or equal to 256, since byte only represent 256 different values.
> Setting the size of object to value equal or more than newly introduced
> SLAB_OBJ_MIN_SIZE ensures that the number of objects in a slab is less or
> equal to 256 for a slab with 1 page.
> 
> If page size is rather larger than 4096, above assumption would be wrong.
> In this case, we would fall back on 2 bytes sized index.
> 
> If minimum size of kmalloc is less than 16, we use it as minimum object
> size and give up this optimization.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: David Rientjes <rientjes@google.com>
