Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaEUIBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:01:18 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:47556 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751991AbaEUIBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:01:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.443
Date: Wed, 21 May 2014 16:01:06 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <902561559.40766.1400659266944.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537BFA6F.9010309@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch/unicor?=
 =?utf-8?Q?e32/kernel/setup.c:_add_?=
 =?utf-8?Q?generic_'screen=5Finfo'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Add generic 'screen_info' just like another architectures have done
> (e.g. tile, sh, score, ia64, hexagon, and cris).
> 
> The related error (with allmodconfig under unicore32):
> 
>     LD      init/built-in.o
>   drivers/built-in.o: In function `vgacon_save_screen':
>   powercap_sys.c:(.text+0x21788): undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_resize':
>   powercap_sys.c:(.text+0x21b54): undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_switch':
>   powercap_sys.c:(.text+0x21cb4): undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_init':
>   powercap_sys.c:(.text+0x2296c): undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_startup':
>   powercap_sys.c:(.text+0x22e80): undefined reference to `screen_info'
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/kernel/setup.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
> index 87adbf5..94bc4bc 100644
> --- a/arch/unicore32/kernel/setup.c
> +++ b/arch/unicore32/kernel/setup.c
> @@ -53,6 +53,8 @@ struct stack {
>  
>  static struct stack stacks[NR_CPUS];
>  
> +struct screen_info screen_info;
> +

could be as following if it's only used by vga console:

+#ifdef CONFIG_VGA_CONSOLE
+struct screen_info screen_info;
+#endif

>  char elf_platform[ELF_PLATFORM_SIZE];
>  EXPORT_SYMBOL(elf_platform);
>  
> -- 
> 1.9.2.459.g68773ac
