Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3BLR20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:28:26 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:62459 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3BLR2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:28:25 -0500
Date: Tue, 12 Feb 2013 09:28:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drm: missing idr_preload_end in drm_gem_flink_ioctl
Message-ID: <20130212172820.GC7348@htj.dyndns.org>
References: <1360496945-4694-1-git-send-email-artem.savkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360496945-4694-1-git-send-email-artem.savkov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andrew)

Hello,

On Sun, Feb 10, 2013 at 03:49:05PM +0400, Artem Savkov wrote:
> Added missing idr_preload_end calls in drm_gem_flink_ioctl().
> Without those preemption stays disabled resulting in lots of "scheduling while
> atomic" BUGs.
> 
> Introduced in 4e486fae707d9a79c76f1be6dcacffc4a721cc1b (linux-next.git)
> 
> Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
> ---
>  drivers/gpu/drm/drm_gem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 6577514..f1700ef 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -456,6 +456,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
>  		obj->name = ret;
>  		args->name = (uint64_t) obj->name;
>  		spin_unlock(&dev->object_name_lock);
> +		idr_preload_end();
>  
>  		if (ret < 0)
>  			goto err;
> @@ -465,6 +466,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
>  	} else {
>  		args->name = (uint64_t) obj->name;
>  		spin_unlock(&dev->object_name_lock);
> +		idr_preload_end();
>  		ret = 0;

Oops, sorry about that.

 Acked-by: Tejun Heo <tj@kernel.org>

Andrew, the original patch can be found at

 http://article.gmane.org/gmane.linux.kernel/1439101/raw

Thanks.

-- 
tejun
