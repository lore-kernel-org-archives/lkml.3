Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaIHMCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:02:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38633 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaIHMCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:02:36 -0400
Message-ID: <540D9A9B.6070706@gmail.com>
Date: Mon, 08 Sep 2014 13:01:31 +0100
From: Emil Velikov <emil.l.velikov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>, David Airlie <airlied@linux.ie>
CC: emil.l.velikov@gmail.com, dmarlin@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
In-Reply-To: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh

On 05/09/14 18:19, Josh Boyer wrote:
> The userspace drm.h include doesn't prefix the drm directory.  This can lead
> to compile failures as /usr/include/drm/ isn't in the standard gcc include
> paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
> header files that get installed into /usr/include/drm.
> 
Is this an actual issue or a hypothetical one ? Afaict no-one is using the
kernel drm headers, but instead the ones from libdrm are in place.
linux-headers does not even ship /usr/include/drm on my Archlinux box.

Additionally most (all?) vmwgfx components (mesa, ddx) use a local version of
the header, which albeit not ideal should not cause issues.

Or perhaps I'm missing something ?


To the VMware guys,

Any objections if we update the libdrm header and drop the mesa/ddx copies ?

Cheers,
Emil

P.S. I'm against the patch in any way :)

> Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759
> 
> Fixes: 1d7a5cbf8f74e
> Reported-by: Jeffrey Bastian <jbastian@redhat.com>
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
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
> 

