Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3CSTfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:35:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3CSTfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:35:33 -0400
Date: Tue, 19 Mar 2013 12:35:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 07/21] vmcore, procfs: introduce a flag to
 distinguish objects copied in 2nd kernel
Message-Id: <20130319123531.9777a366ff0e1611727405cd@linux-foundation.org>
In-Reply-To: <20130316040126.15064.67305.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040126.15064.67305.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 13:01:26 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> The part of dump target memory is copied into the 2nd kernel if it
> doesn't satisfy mmap()'s page-size boundary requirement. To
> distinguish such copied object from usual old memory, a flag
> MEM_TYPE_CURRENT_KERNEL is introduced. If this flag is set, the object
> is considered being copied into buffer on the 2nd kernel.
> 

I don't understand this description at all :( Perhaps we can have a
lengthier version which expands on the concepts a bit further?

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -97,11 +97,17 @@ struct kcore_list {
>  	int type;
>  };
>  
> +#define MEM_TYPE_CURRENT_KERNEL 0x1

A comment describing this would be useful.

>  struct vmcore {
>  	struct list_head list;
> -	unsigned long long paddr;
> +	union {
> +		unsigned long long paddr;
> +		char *buf;
> +	};

This change wasn't described in the changelog?

>  	unsigned long long size;
>  	loff_t offset;
> +	unsigned int flag;

Presumably this is the place where we put MEM_TYPE_CURRENT_KERNEL? 
That's unobvious from reading the code.  Add the text "vmcore.flag
fields:" above the MEM_TYPE_CURRENT_KERNEL definition.


>  };
>  
>  #ifdef CONFIG_PROC_FS
