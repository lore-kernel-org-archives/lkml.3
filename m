Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3IWXSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:18:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3IWXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:18:07 -0400
Date: Mon, 23 Sep 2013 16:18:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, iamjoonsoo.kim@lge.com,
        rientjes@google.com, zhangyanfei@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 1/4] mm/vmalloc: don't set area->caller twice
Message-Id: <20130923161805.4b4b570241224b673e5c3b1b@linux-foundation.org>
In-Reply-To: <5237946f.4815440a.094e.ffff8c29SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1379202342-23140-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<5237617F.6010107@jp.fujitsu.com>
	<5237946f.4815440a.094e.ffff8c29SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 07:29:41 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:

> >> to set it again in __vmalloc_area_node.
> >> 
> >> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> >> ---
> >>  mm/vmalloc.c | 1 -
> >>  1 file changed, 1 deletion(-)
> >> 
> >> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >> index 1074543..d78d117 100644
> >> --- a/mm/vmalloc.c
> >> +++ b/mm/vmalloc.c
> >> @@ -1566,7 +1566,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >>  		pages = kmalloc_node(array_size, nested_gfp, node);
> >>  	}
> >>  	area->pages = pages;
> >> -	area->caller = caller;
> >>  	if (!area->pages) {
> >>  		remove_vm_area(area->addr);
> >>  		kfree(area);
> >
> >Then, __vmalloc_area_node() no longer need "caller" argument. It can use area->caller instead.
> >
> 
> Thanks for pointing out, I will update it in next version. 

I've seen so many versions of this patchset that my head has spun right
off.  I'm not at all confident that I have the latest version and I'm
certainly not confident that I've kept up with the ack/nack trail.

So I think I'll drop everything and will await that "next version". 
Please be careful to Cc everyone who was involved and that the
acked/reviewed-by paperwork is up to date.

Thanks.
