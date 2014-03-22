Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaCVHTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:19:08 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:47620 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbaCVHTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:19:03 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.287
Date: Sat, 22 Mar 2014 15:18:52 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: gxt@mprc.pku.edu.cn, linux-kernel@vger.kernel.org
Message-ID: <1015271230.2160.1395472732347.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53225217.3070205@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch/unicore?=
 =?utf-8?Q?32/kernel/module.c:_use_=5F?=
 =?utf-8?Q?=5Fvmalloc=5Fnode=5Frange()_instead_of_=5F=5Fvmalloc=5Farea()?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Chen.

Cc: Zhichuang Sun <sunzhichuang@mprc.pku.edu.cn>
Tested-by: Zhichuang Sun <sunzhichuang@mprc.pku.edu.cn>
Acked-by: Xuetao Guan <gxt@pku.edu.cn>


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> __vmalloc_area() has already been removed from upstream kernel, need
> use __vmalloc_node_range() instead of.
> 
> The related commit: "d0a2126 mm: unify module_alloc code for vmalloc".
> 
> The related error (allmodconfig for unicore32):
> 
>     CC      arch/unicore32/kernel/module.o
>   arch/unicore32/kernel/module.c: In function ‘module_alloc’:
>   arch/unicore32/kernel/module.c:34: error: implicit declaration of function ‘__vmalloc_area’
>   arch/unicore32/kernel/module.c:34: warning: return makes pointer from integer without a cast
>   make[1]: *** [arch/unicore32/kernel/module.o] Error 1
>   make: *** [arch/unicore32/kernel] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/kernel/module.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/unicore32/kernel/module.c b/arch/unicore32/kernel/module.c
> index 16bd149..dc41f6d 100644
> --- a/arch/unicore32/kernel/module.c
> +++ b/arch/unicore32/kernel/module.c
> @@ -24,14 +24,9 @@
>  
>  void *module_alloc(unsigned long size)
>  {
> -	struct vm_struct *area;
> -
> -	size = PAGE_ALIGN(size);
> -	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
> -	if (!area)
> -		return NULL;
> -
> -	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
> +	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
> +				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
> +				__builtin_return_address(0));
>  }
>  
>  int
> -- 
> 1.7.9.5

