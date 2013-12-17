Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3LQHZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:25:33 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55710 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3LQHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:25:32 -0500
MIME-Version: 1.0
In-Reply-To: <1387256873-21350-2-git-send-email-john.stultz@linaro.org>
References: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
	<1387256873-21350-2-git-send-email-john.stultz@linaro.org>
Date: Mon, 16 Dec 2013 23:25:31 -0800
X-Google-Sender-Auth: FXKAQ-EBWTrrUnfeHkkAihP0MBU
Message-ID: <CAMbhsRSZAME6YDiexwUsqBGNJXnjxiA7gk_tCNoM=qcm74sfdg@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: ion: Add HAVE_MEMBLOCK config dependency
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Colin Cross <ccross@android.com>

On Mon, Dec 16, 2013 at 9:07 PM, John Stultz <john.stultz@linaro.org> wrote:
> The kbuild test robot reported a build issue w/ ION on m68k:
>
> drivers/staging/android/ion/ion.c: In function 'ion_reserve':
> drivers/staging/android/ion/ion.c:1526:4: error: implicit declaration of function 'memblock_alloc_base' [-Werror=implicit-function-declaration]
> drivers/staging/android/ion/ion.c:1528:11: error: 'MEMBLOCK_ALLOC_ANYWHERE' undeclared (first use in this function)
> drivers/staging/android/ion/ion.c:1528:11: note: each undeclared identifier is reported only once for each function it appears in
> drivers/staging/android/ion/ion.c:1537:4: error: implicit declaration of function 'memblock_reserve' [-Werror=implicit-function-declaration]
>    cc1: some warnings being treated as errors
>
> This is caused by ION using memblock functionality which m68k doesn't support.
>
> This patch adds a HAVE_MEMBLOCK dependency to the ION config.
>
> Cc: Colin Cross <ccross@android.com>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: kbuild test robot <fengguang.wu@intel.com>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
> index b95281e..a9a64ea 100644
> --- a/drivers/staging/android/ion/Kconfig
> +++ b/drivers/staging/android/ion/Kconfig
> @@ -1,5 +1,6 @@
>  menuconfig ION
>         bool "Ion Memory Manager"
> +       depends on HAVE_MEMBLOCK
>         select GENERIC_ALLOCATOR
>         select DMA_SHARED_BUFFER
>         ---help---
> --
> 1.8.3.2
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
