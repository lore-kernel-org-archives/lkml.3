Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab3ENOun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab3ENOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:50:40 -0400
Date: Tue, 14 May 2013 10:50:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        Rik Van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v5 3/8] vmalloc: make find_vm_area check in range
Message-ID: <20130514145003.GC16772@redhat.com>
References: <20130514015622.18697.77191.stgit@localhost6.localdomain6>
 <20130514015723.18697.34468.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514015723.18697.34468.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 10:57:23AM +0900, HATAYAMA Daisuke wrote:
> Currently, __find_vmap_area searches for the kernel VM area starting
> at a given address. This patch changes this behavior so that it
> searches for the kernel VM area to which the address belongs. This
> change is needed by remap_vmalloc_range_partial to be introduced in
> later patch that receives any position of kernel VM area as target
> address.
> 
> This patch changes the condition (addr > va->va_start) to the
> equivalent (addr >= va->va_end) by taking advantage of the fact that
> each kernel VM area is non-overlapping.
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

This will require ack from mm folks. CCing some of them. 

Thanks
Vivek

> ---
> 
>  mm/vmalloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d365724..3875fa2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -292,7 +292,7 @@ static struct vmap_area *__find_vmap_area(unsigned long addr)
>  		va = rb_entry(n, struct vmap_area, rb_node);
>  		if (addr < va->va_start)
>  			n = n->rb_left;
> -		else if (addr > va->va_start)
> +		else if (addr >= va->va_end)
>  			n = n->rb_right;
>  		else
>  			return va;
