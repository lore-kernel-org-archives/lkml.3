Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaEUXrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:47:18 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:56771 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751366AbaEUXrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:47:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.374
Date: Thu, 22 May 2014 07:47:00 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <916967662.45671.1400716020952.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <537D31E7.4030307@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH_v2]_arch/unic?=
 =?utf-8?Q?ore32/kernel/setup.c:_add?=
 =?utf-8?Q?_generic_'screen=5Finfo'_to_avoid_compiling_failure?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

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
>  arch/unicore32/kernel/setup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
> index 87adbf5..3fa317f 100644
> --- a/arch/unicore32/kernel/setup.c
> +++ b/arch/unicore32/kernel/setup.c
> @@ -53,6 +53,10 @@ struct stack {
>  
>  static struct stack stacks[NR_CPUS];
>  
> +#ifdef CONFIG_VGA_CONSOLE
> +struct screen_info screen_info;
> +#endif
> +
>  char elf_platform[ELF_PLATFORM_SIZE];
>  EXPORT_SYMBOL(elf_platform);
>  
> -- 
> 1.9.2.459.g68773ac

