Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab3BOPbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:31:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935780Ab3BOPbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:31:02 -0500
Date: Fri, 15 Feb 2013 10:30:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/13] vmcore: modify ELF32 code according to new type
Message-ID: <20130215153048.GD27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101210.22466.36330.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101210.22466.36330.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 07:12:10PM +0900, HATAYAMA Daisuke wrote:
> On elf32 mmap() is not supported. All vmcore objects are in old
> memory.

This is odd. Why can't we support mmap() when 32bit headers have been
prepared?

Thanks
Vivek

> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
> 
>  fs/proc/vmcore.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 43d338a..7e3f922 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -389,6 +389,7 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
>  			kfree(notes_section);
>  			return -ENOMEM;
>  		}
> +		new->type = VMCORE_OLD_MEMORY;
>  		new->paddr = phdr_ptr->p_offset;
>  		new->size = real_sz;
>  		list_add_tail(&new->list, vc_list);
> @@ -486,6 +487,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
>  		new = get_new_element();
>  		if (!new)
>  			return -ENOMEM;
> +		new->type = VMCORE_OLD_MEMORY;
>  		new->paddr = phdr_ptr->p_offset;
>  		new->size = phdr_ptr->p_memsz;
>  		list_add_tail(&new->list, vc_list);
