Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaIPNnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:43:51 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46609 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaIPNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
Date: Tue, 16 Sep 2014 09:43:50 -0400
X-Google-Sender-Auth: D5JiXnzDoQ03g8kKxArhxuyd8Bc
Message-ID: <CA+5PVA5t5Q3gRPaHebM7npfKLpET7xm70DXDWMbV0L0nsviBvQ@mail.gmail.com>
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Thomas Hellstrom <thellstrom@vmware.com>, David Airlie <airlied@linux.ie>
Cc: Brian Paul <brianp@vmware.com>, dmarlin@redhat.com,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 1:19 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> The userspace drm.h include doesn't prefix the drm directory.  This can lead
> to compile failures as /usr/include/drm/ isn't in the standard gcc include
> paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
> header files that get installed into /usr/include/drm.
>
> Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759
>
> Fixes: 1d7a5cbf8f74e
> Reported-by: Jeffrey Bastian <jbastian@redhat.com>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Ping?  Did this get queued anywhere?

josh

> ---
>  include/uapi/drm/vmwgfx_drm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/drm/vmwgfx_drm.h b/include/uapi/drm/vmwgfx_drm.h
> index 4fc66f6b12ce..c472bedbe38e 100644
> --- a/include/uapi/drm/vmwgfx_drm.h
> +++ b/include/uapi/drm/vmwgfx_drm.h
> @@ -29,7 +29,7 @@
>  #define __VMWGFX_DRM_H__
>
>  #ifndef __KERNEL__
> -#include <drm.h>
> +#include <drm/drm.h>
>  #endif
>
>  #define DRM_VMW_MAX_SURFACE_FACES 6
> --
> 1.9.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
