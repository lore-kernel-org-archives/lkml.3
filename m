Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaDKP57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:57:59 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:47731 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbaDKP56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:57:58 -0400
Date: Fri, 11 Apr 2014 10:57:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, penberg@kernel.org, gthelen@google.com,
        hannes@cmpxchg.org, mhocko@suse.cz, glommer@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH -mm] slab: document kmalloc_order
In-Reply-To: <1397220736-13840-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1404111057390.13278@nuc>
References: <20140410163831.c76596b0f8d0bef39a42c63f@linux-foundation.org> <1397220736-13840-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014, Vladimir Davydov wrote:

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index cab4c49b3e8c..3ffd2e76b5d2 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -573,6 +573,11 @@ void __init create_kmalloc_caches(unsigned long flags)
>  }
>  #endif /* !CONFIG_SLOB */
>
> +/*
> + * To avoid unnecessary overhead, we pass through large allocation requests
> + * directly to the page allocator. We use __GFP_COMP, because we will need to
> + * know the allocation order to free the pages properly in kfree.
> + */
>  void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
>  {
>  	void *ret;
>

??? kmalloc_order is defined in include/linux/slab.h

