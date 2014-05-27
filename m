Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaE0AOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:14:34 -0400
Received: from mx7.pku.edu.cn ([162.105.129.170]:59886 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752444AbaE0AOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:14:32 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.413
Date: Tue, 27 May 2014 08:14:21 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <1270810603.23809.1401149661357.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <5383D766.7070106@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_3/3]_arch:_uni?=
 =?utf-8?Q?core32:_ksyms:_export_'=5F=5Fc?=
 =?utf-8?Q?puc=5Fcoherent=5Fkern=5Frange'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> flush_icache_range() is '__cpuc_coherent_kern_range' under unicore32,
> and lkdtm.ko needs it. At present, '__cpuc_coherent_kern_range' is
> still used by unicore32, so export it to avoid compiling failure.
> 
> The related error (with allmodconfig under unicore32):
> 
>   ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

> ---
>  arch/unicore32/mm/proc-syms.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/unicore32/mm/proc-syms.c b/arch/unicore32/mm/proc-syms.c
> index f30071e..21c00fc 100644
> --- a/arch/unicore32/mm/proc-syms.c
> +++ b/arch/unicore32/mm/proc-syms.c
> @@ -19,5 +19,7 @@
>  EXPORT_SYMBOL(cpu_dcache_clean_area);
>  EXPORT_SYMBOL(cpu_set_pte);
>  
> +EXPORT_SYMBOL(__cpuc_coherent_kern_range);
> +
>  EXPORT_SYMBOL(__cpuc_dma_flush_range);
>  EXPORT_SYMBOL(__cpuc_dma_clean_range);
> -- 
> 1.9.2.459.g68773ac

