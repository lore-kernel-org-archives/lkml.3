Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3CFQD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:03:59 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:48156 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3CFQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130302083622.31252.38843.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083622.31252.38843.stgit@localhost6.localdomain6>
Date: Wed, 6 Mar 2013 23:55:58 +0800
Message-ID: <CANBD6kF=B7UqxaoxY_Uhua2m7nQnXf2Xk_hWMCZcP6_0vcLpsQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/20] vmcore, procfs: introduce a flag to distinguish
 objects copied in 2nd kernel
From: Yanfei Zhang <zhangyanfei.yes@gmail.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/2 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>:
> The part of dump target memory is copied into the 2nd kernel if it
> doesn't satisfy mmap()'s page-size boundary requirement. To
> distinguish such copied object from usual old memory, a flag
> MEM_TYPE_CURRENT_KERNEL is introduced. If this flag is set, the object
> is considered being copied into buffer on the 2nd kernel.

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>
>  include/linux/proc_fs.h |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 8307f2f..11dd592 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -97,11 +97,17 @@ struct kcore_list {
>         int type;
>  };
>
> +#define MEM_TYPE_CURRENT_KERNEL 0x1
> +
>  struct vmcore {
>         struct list_head list;
> -       unsigned long long paddr;
> +       union {
> +               unsigned long long paddr;
> +               char *buf;
> +       };
>         unsigned long long size;
>         loff_t offset;
> +       unsigned int flag;
>  };
>
>  #ifdef CONFIG_PROC_FS
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
