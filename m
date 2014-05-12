Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaELHgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:36:48 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:52687 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751652AbaELHgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:36:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.322
Date: Mon, 12 May 2014 15:36:29 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Message-ID: <744838721.16786.1399880189408.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53644114.9000201@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_arch/uni?=
 =?utf-8?Q?core32/include/asm/io?=
 =?utf-8?Q?.h:_add_readl=5Frelaxed()_generic_definition?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Need generic definition for readl_relaxed(), like other architectures
> have done. Or can not pass compiling with allmodconfig, the related
> error:
> 
>     CC [M]  drivers/message/fusion/mptbase.o
>   drivers/message/fusion/mptbase.c: In function ‘mpt_send_handshake_request’:
>   drivers/message/fusion/mptbase.c:1224: error: implicit declaration of function ‘readl_relaxed’
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/unicore32/include/asm/io.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
> index ae327e4..cb1d8fd 100644
> --- a/arch/unicore32/include/asm/io.h
> +++ b/arch/unicore32/include/asm/io.h
> @@ -39,6 +39,10 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
>  #define ioremap_nocache(cookie, size)	__uc32_ioremap(cookie, size)
>  #define iounmap(cookie)			__uc32_iounmap(cookie)
>  
> +#define readb_relaxed readb
> +#define readw_relaxed readw
> +#define readl_relaxed readl
> +
>  #define HAVE_ARCH_PIO_SIZE
>  #define PIO_OFFSET		(unsigned int)(PCI_IOBASE)
>  #define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
> -- 
> 1.9.2.459.g68773ac

