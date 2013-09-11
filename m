Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3IKUbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:31:03 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50935 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3IKUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:31:00 -0400
Message-ID: <5230D301.7030203@gmail.com>
Date: Wed, 11 Sep 2013 16:30:57 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Kees Cook <keescook@chromium.org>, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Jiri Kosina <jkosina@suse.cz>,
        Jan Beulich <jbeulich@suse.com>, Eldad Zack <eldad@fogrefinery.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
References: <20130911193040.GA16688@www.outflux.net>  <1378929961.4714.21.camel@joe-AO722>  <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com> <1378930822.4714.22.camel@joe-AO722>
In-Reply-To: <1378930822.4714.22.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, just found those too.
> ---
>   fs/proc/consoles.c   |  2 +-
>   fs/proc/nommu.c      | 20 ++++++++++----------
>   fs/proc/task_mmu.c   | 18 +++++++++---------
>   fs/proc/task_nommu.c | 20 ++++++++++----------
>   4 files changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
> index b701eaa..42f2bb7 100644
> --- a/fs/proc/consoles.c
> +++ b/fs/proc/consoles.c
> @@ -47,7 +47,7 @@ static int show_console_dev(struct seq_file *m, void *v)
>   			con_flags[a].name : ' ';
>   	flags[a] = 0;
>
> -	seq_printf(m, "%s%d%n", con->name, con->index, &len);
> +	len = seq_printf(m, "%s%d", con->name, con->index);
>   	len = 21 - len;
>   	if (len < 1)
>   		len = 1;
> diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
> index ccfd99b..91cfd19 100644
> --- a/fs/proc/nommu.c
> +++ b/fs/proc/nommu.c
> @@ -50,16 +50,16 @@ static int nommu_region_show(struct seq_file *m, struct vm_region *region)
>   		ino = inode->i_ino;
>   	}
>
> -	seq_printf(m,
> -		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
> -		   region->vm_start,
> -		   region->vm_end,
> -		   flags & VM_READ ? 'r' : '-',
> -		   flags & VM_WRITE ? 'w' : '-',
> -		   flags & VM_EXEC ? 'x' : '-',
> -		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
> -		   ((loff_t)region->vm_pgoff) << PAGE_SHIFT,
> -		   MAJOR(dev), MINOR(dev), ino, &len);
> +	len = seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
> +			 region->vm_start,
> +			 region->vm_end,
> +			 flags & VM_READ ? 'r' : '-',
> +			 flags & VM_WRITE ? 'w' : '-',
> +			 flags & VM_EXEC ? 'x' : '-',
> +			 flags & VM_MAYSHARE ?
> +			 flags & VM_SHARED ? 'S' : 's' : 'p',
> +			 ((loff_t)region->vm_pgoff) << PAGE_SHIFT,
> +			 MAJOR(dev), MINOR(dev), ino);
>
>   	if (file) {
>   		len = 25 + sizeof(void *) * 6 - len;
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 107d026..f84ee9f 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -286,15 +286,15 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
>   	if (stack_guard_page_end(vma, end))
>   		end -= PAGE_SIZE;
>
> -	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
> -			start,
> -			end,
> -			flags & VM_READ ? 'r' : '-',
> -			flags & VM_WRITE ? 'w' : '-',
> -			flags & VM_EXEC ? 'x' : '-',
> -			flags & VM_MAYSHARE ? 's' : 'p',
> -			pgoff,
> -			MAJOR(dev), MINOR(dev), ino, &len);
> +	len = seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
> +			 start,
> +			 end,
> +			 flags & VM_READ ? 'r' : '-',
> +			 flags & VM_WRITE ? 'w' : '-',
> +			 flags & VM_EXEC ? 'x' : '-',
> +			 flags & VM_MAYSHARE ? 's' : 'p',
> +			 pgoff,
> +			 MAJOR(dev), MINOR(dev), ino);
>
>   	/*
>   	 * Print the dentry name for named mappings, and a
> diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
> index 56123a6..1d7bbe5 100644
> --- a/fs/proc/task_nommu.c
> +++ b/fs/proc/task_nommu.c
> @@ -155,16 +155,16 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
>   		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
>   	}
>
> -	seq_printf(m,
> -		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
> -		   vma->vm_start,
> -		   vma->vm_end,
> -		   flags & VM_READ ? 'r' : '-',
> -		   flags & VM_WRITE ? 'w' : '-',
> -		   flags & VM_EXEC ? 'x' : '-',
> -		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
> -		   pgoff,
> -		   MAJOR(dev), MINOR(dev), ino, &len);
> +	len = seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
> +			 vma->vm_start,
> +			 vma->vm_end,
> +			 flags & VM_READ ? 'r' : '-',
> +			 flags & VM_WRITE ? 'w' : '-',
> +			 flags & VM_EXEC ? 'x' : '-',
> +			 flags & VM_MAYSHARE ?
> +			 flags & VM_SHARED ? 'S' : 's' : 'p',
> +			 pgoff,
> +			 MAJOR(dev), MINOR(dev), ino);
>
>   	if (file) {
>   		pad_len_spaces(m, len);

ack for mm parts.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


