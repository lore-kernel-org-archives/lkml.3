Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaENVz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:55:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaENVzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:55:21 -0400
Date: Wed, 14 May 2014 14:55:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140514145520.f010e4593071cf5a756ddc5b@linux-foundation.org>
In-Reply-To: <20140514174749.1ec4d37f@canb.auug.org.au>
References: <20140514174749.1ec4d37f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 17:47:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> mm/memcontrol.c: In function 'mem_cgroup_write':
> mm/memcontrol.c:5088:45: error: 'buffer' undeclared (first use in this function)
>    ret = res_counter_memparse_write_strategy(buffer, &val);
>                                              ^
> mm/memcontrol.c: At top level:
> /scratch/sfr/next/mm/memcontrol.c:6029:3: error: unknown field 'write_string' specified in initializer
>    .write_string = mem_cgroup_write,
>    ^
> 
> Caused by commit a4bf584ed8c2 ("memcg: allow setting low_limit")
> interacting with commit 451af504df0c ("cgroup: replace
> cftype->write_string() with cftype->write()") from the cgroup tree.
> (I love API changes and unnecessary variable renaming :-()
> 
> ...
>
> @@ -6026,7 +6026,7 @@ static struct cftype mem_cgroup_files[] = {
>  	{
>  		.name = "low_limit_in_bytes",
>  		.private = MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
> -		.write_string = mem_cgroup_write,
> +		.write = mem_cgroup_write,
>  		.read_u64 = mem_cgroup_read_u64,
>  	},

Renaming buffer to buf was rather unneeded.

I have 24 patches here against mm/memcontrol.c.  Go gently, please.
