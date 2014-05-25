Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaEYMIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 08:08:50 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38030 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEYMIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 08:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net>
References: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net>
Date: Sun, 25 May 2014 14:08:48 +0200
Message-ID: <CANq1E4QdGeHeuCu9LvPkbGZX5C+ax4fWVqq4kJ5wMUBx5uWZrQ@mail.gmail.com>
Subject: Re: [PATCH linux-next] DRM: Armada: update dma_buf_export use
From: David Herrmann <dh.herrmann@gmail.com>
To: =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, May 24, 2014 at 11:05 PM, Vincent Stehlé
<vincent.stehle@laposte.net> wrote:
> The dma_buf_export function was updated in commit 4bcec44ffaf9 'dma-buf: use
> reservation objects' to take a reservation object parameter; update Armada
> export method accordingly.
>
> This fixes the following compilation error:
>
>   drivers/gpu/drm/armada/armada_gem.c: In function ‘armada_gem_prime_export’:
>   drivers/gpu/drm/armada/armada_gem.c:544:16: error: macro "dma_buf_export" requires 5 arguments, but only 4 given
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>
> Hi,
>
> This can be seen with e.g. linux next-20140523 and arm allmodconfig.
>
> Best regards,
>
> V.
>
>  drivers/gpu/drm/armada/armada_gem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
> index 887816f..7adb0c3 100644
> --- a/drivers/gpu/drm/armada/armada_gem.c
> +++ b/drivers/gpu/drm/armada/armada_gem.c
> @@ -541,7 +541,7 @@ armada_gem_prime_export(struct drm_device *dev, struct drm_gem_object *obj,
>         int flags)
>  {
>         return dma_buf_export(obj, &armada_gem_prime_dmabuf_ops, obj->size,
> -                             O_RDWR);
> +                             O_RDWR, NULL);
>  }
>
>  struct drm_gem_object *
> --
> 2.0.0.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
