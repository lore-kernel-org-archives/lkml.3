Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaGISXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:23:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47323 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGISXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <53BA5F14.4050708@gmail.com>
References: <53BA5F14.4050708@gmail.com>
Date: Wed, 9 Jul 2014 11:23:34 -0700
X-Google-Sender-Auth: bLG9vCc6iXbcdCVRcN96OLDttcU
Message-ID: <CAMbhsRQpRhCAYrJbT5E6H3Pn6SvDRUFL6Rwq9gjkxv_gB0D-ZQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: android: ion: Kconfig: Let it also
 depend on HAS_DMA
From: Colin Cross <ccross@android.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Zavin <rebecca@android.com>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 1:49 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> ION need HAS_DMA (e.g. need DMA_SHARED_BUFFER), so it has to depend on
> HAS_DMA, or can not pass compiling with allmodconfig under score which
> NO_DMA.  And the related error:
>
>     CC      drivers/staging/android/ion/ion_cma_heap.o
>   drivers/staging/android/ion/ion_cma_heap.c: In function 'ion_cma_mmap':
>   drivers/staging/android/ion/ion_cma_heap.c:168:2: error: implicit declaration of function 'dma_mmap_coherent' [-Werror=implicit-function-declaration]
>     return dma_mmap_coherent(dev, vma, info->cpu_addr, info->handle,
>     ^
>   cc1: some warnings being treated as errors
>   make[4]: *** [drivers/staging/android/ion/ion_cma_heap.o] Error 1
>   make[3]: *** [drivers/staging/android/ion] Error 2
>   make[2]: *** [drivers/staging/android] Error 2
>   make[1]: *** [drivers/staging] Error 2
>   make: *** [drivers] Error 2
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/staging/android/ion/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
> index 0f8fec1..0a6e4d0 100644
> --- a/drivers/staging/android/ion/Kconfig
> +++ b/drivers/staging/android/ion/Kconfig
> @@ -1,6 +1,6 @@
>  menuconfig ION
>         bool "Ion Memory Manager"
> -       depends on HAVE_MEMBLOCK
> +       depends on HAVE_MEMBLOCK && HAS_DMA
>         select GENERIC_ALLOCATOR
>         select DMA_SHARED_BUFFER
>         ---help---
> --
> 1.9.2.459.g68773ac

Acked-by: Colin Cross <ccross@android.com>
