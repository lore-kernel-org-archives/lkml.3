Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaAVNre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:47:34 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45199 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaAVNrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <1390398040-31088-1-git-send-email-bergwolf@gmail.com>
References: <1390398040-31088-1-git-send-email-bergwolf@gmail.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 22 Jan 2014 21:47:12 +0800
Message-ID: <CA+a=Yy48ZD-ueNzMq7URJScGZeBDkMSHMXuyg26ahKifXfyX9g@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging/lustre/o2iblnd: fix is_vmalloc_addr build warning
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>, Laura Abbott <lauraa@codeaurora.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I got gmail failure after git send-email sent the first two patches.
Please drop the two and I'll resend the whole series.

Thanks,
Tao

On Wed, Jan 22, 2014 at 9:40 PM, Peng Tao <bergwolf@gmail.com> wrote:
> I got this building Lustre:
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function ‘kiblnd_kvaddr_to_page’:
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:532:2: warning: passing argument 1 of ‘is_vmalloc_addr’ makes pointer from integer without a cast [enabled by default]
>
> Cc: Laura Abbott <lauraa@codeaurora.org>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> ---
>  .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
> index 9364863..6f58ead 100644
> --- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
> +++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
> @@ -529,7 +529,7 @@ kiblnd_kvaddr_to_page (unsigned long vaddr)
>  {
>         struct page *page;
>
> -       if (is_vmalloc_addr(vaddr)) {
> +       if (is_vmalloc_addr((void *)vaddr)) {
>                 page = vmalloc_to_page ((void *)vaddr);
>                 LASSERT (page != NULL);
>                 return page;
> --
> 1.7.9.5
>
