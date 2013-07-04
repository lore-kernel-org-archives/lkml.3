Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3GDIpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:45:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3GDIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:45:40 -0400
Date: Thu, 4 Jul 2013 01:45:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: linux-next: Tree for Jul 4
Message-Id: <20130704014544.bce5cdb6.akpm@linux-foundation.org>
In-Reply-To: <CA+icZUV8Nw2eY7aJg0qSCmg+Pk_EdRT2joUqxiL8y77rUsBGHg@mail.gmail.com>
References: <20130704160652.4f76f0ee43877a6e726d6c8b@canb.auug.org.au>
	<CA+icZUXchb2H=ZZ0Zv+vA43x0CNVSbLvPptawnBR+OUpOzqP6A@mail.gmail.com>
	<CA+icZUV8Nw2eY7aJg0qSCmg+Pk_EdRT2joUqxiL8y77rUsBGHg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013 10:21:09 +0200 Sedat Dilek <sedat.dilek@gmail.com> wrote:

> I have compared both mm/memcontrol.c files from
> next-20130703/next-20130704 - they are identical.
> 
> These hunks...
> 
> [ From Li Zefan ]
> @@ -6332,8 +6341,7 @@ static void mem_cgroup_css_free(struct cgroup *cont)
>  {
>         struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> 
> -       mem_cgroup_sockets_destroy(memcg);
> -
> +       memcg_destroy_kmem(memcg);
>         __mem_cgroup_free(memcg);
>  }
> 
> [ From mmots ]
> @@ -6399,8 +6408,7 @@ static void mem_cgroup_css_free(struct c
>  {
>         struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> 
> -       mem_cgroup_sockets_destroy(memcg);
> -
> +       memcg_destroy_kmem(memcg);
>         mem_cgroup_put(memcg);
>  }
> 
> ...seems to differ.
> 
> In both mentioned -next releases there exist no mem_cgroup_put() in
> mm/memcontrol.c.
> So the hunk in mmots seems to be wrong in my eyes.

Seems right - thanks for catching that.

--- a/mm/memcontrol.c~memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix
+++ a/mm/memcontrol.c
@@ -6409,7 +6409,7 @@ static void mem_cgroup_css_free(struct c
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
 	memcg_destroy_kmem(memcg);
-	mem_cgroup_put(memcg);
+	__mem_cgroup_free(memcg);
 }
 
 #ifdef CONFIG_MMU
_

