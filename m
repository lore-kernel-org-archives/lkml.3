Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3A2PZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:25:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3A2PZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:25:05 -0500
Message-ID: <5107E9C7.1090302@ti.com>
Date: Tue, 29 Jan 2013 09:24:55 -0600
From: Rob Clark <rob@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Gross <andy.gross@ti.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        "Vincent Penquerc'h" <vincent.penquerch@collabora.co.uk>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/omapdrm: Use kmemdup rather than duplicating
 its implementation
References: <1359157213-626-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1359157213-626-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 05:40 PM, Peter Huewe wrote:
> Found with coccicheck.
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Signed-off-by: Rob Clark <rob@ti.com>

> ---
>   drivers/staging/omapdrm/omap_gem.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
> index 08f1e292..f9297eb 100644
> --- a/drivers/staging/omapdrm/omap_gem.c
> +++ b/drivers/staging/omapdrm/omap_gem.c
> @@ -1267,12 +1267,12 @@ int omap_gem_set_sync_object(struct drm_gem_object *obj, void *syncobj)
>   
>   	if ((omap_obj->flags & OMAP_BO_EXT_SYNC) && !syncobj) {
>   		/* clearing a previously set syncobj */
> -		syncobj = kzalloc(sizeof(*omap_obj->sync), GFP_ATOMIC);
> +		syncobj = kmemdup(omap_obj->sync, sizeof(*omap_obj->sync),
> +				  GFP_ATOMIC);
>   		if (!syncobj) {
>   			ret = -ENOMEM;
>   			goto unlock;
>   		}
> -		memcpy(syncobj, omap_obj->sync, sizeof(*omap_obj->sync));
>   		omap_obj->flags &= ~OMAP_BO_EXT_SYNC;
>   		omap_obj->sync = syncobj;
>   	} else if (syncobj && !(omap_obj->flags & OMAP_BO_EXT_SYNC)) {

