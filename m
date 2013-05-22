Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3EVUqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab3EVUqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:46:52 -0400
Date: Wed, 22 May 2013 16:46:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v7 7/8] vmcore: calculate vmcore file size from buffer
 size and total size of vmcore objects
Message-ID: <20130522204603.GC15738@redhat.com>
References: <20130522025410.12215.16793.stgit@localhost6.localdomain6>
 <20130522025612.12215.74462.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522025612.12215.74462.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:56:12AM +0900, HATAYAMA Daisuke wrote:

[..]
> -static u64 __init get_vmcore_size_elf64(char *elfptr, size_t elfsz)
> +static u64 __init get_vmcore_size_elf64(size_t elfsz, size_t elfnotesegsz,
> +					struct list_head *vc_list)
>  {
> -	int i;
>  	u64 size;
> -	Elf64_Ehdr *ehdr_ptr;
> -	Elf64_Phdr *phdr_ptr;
> +	struct vmcore *m;
>  
> -	ehdr_ptr = (Elf64_Ehdr *)elfptr;
> -	phdr_ptr = (Elf64_Phdr*)(elfptr + sizeof(Elf64_Ehdr));
> -	size = elfsz;
> -	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
> -		size += phdr_ptr->p_memsz;
> -		phdr_ptr++;
> +	size = elfsz + elfnotesegsz;
> +	list_for_each_entry(m, vc_list, list) {
> +		size += m->size;
>  	}
>  	return size;
>  }
>  
> -static u64 __init get_vmcore_size_elf32(char *elfptr, size_t elfsz)
> +static u64 __init get_vmcore_size_elf32(size_t elfsz, size_t elfnotesegsz,
> +					struct list_head *vc_list)
>  {
> -	int i;
>  	u64 size;
> -	Elf32_Ehdr *ehdr_ptr;
> -	Elf32_Phdr *phdr_ptr;
> +	struct vmcore *m;
>  
> -	ehdr_ptr = (Elf32_Ehdr *)elfptr;
> -	phdr_ptr = (Elf32_Phdr*)(elfptr + sizeof(Elf32_Ehdr));
> -	size = elfsz;
> -	for (i = 0; i < ehdr_ptr->e_phnum; i++) {
> -		size += phdr_ptr->p_memsz;
> -		phdr_ptr++;
> +	size = elfsz + elfnotesegsz;
> +	list_for_each_entry(m, vc_list, list) {
> +		size += m->size;


Now get_vmcore_size_elf64() and get_vmcore_size_elf32() function are same.
We can get rid of one and rename other get_vmcore_size().

Thanks
Vivek

