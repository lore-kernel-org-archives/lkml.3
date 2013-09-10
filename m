Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3IJXda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:33:30 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:59299 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3IJXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-Qzopm8EmcFOAnHk_UAks9FTFKnaS_4Xd3jnzPOtLChQ@mail.gmail.com>
References: <CAPgLHd-Qzopm8EmcFOAnHk_UAks9FTFKnaS_4Xd3jnzPOtLChQ@mail.gmail.com>
Date: Tue, 10 Sep 2013 19:33:27 -0400
Message-ID: <CAF6AEGt9icLy3uz=245rYGLiWMsiW7H9MqCL5mX3VU+6CDAnxw@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: fix return value check in ERR_PTR()
From: Rob Clark <robdclark@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: David Airlie <airlied@linux.ie>, yongjun_wei@trendmicro.com.cn,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 6:56 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function drm_prime_pages_to_sg() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

good catch, thanks

Signed-off-by: Rob Clark <robdclark@gmail.com>

> ---
>  drivers/gpu/drm/msm/msm_gem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
> index 6b5a6c8..3462def 100644
> --- a/drivers/gpu/drm/msm/msm_gem.c
> +++ b/drivers/gpu/drm/msm/msm_gem.c
> @@ -40,9 +40,9 @@ static struct page **get_pages(struct drm_gem_object *obj)
>                 }
>
>                 msm_obj->sgt = drm_prime_pages_to_sg(p, npages);
> -               if (!msm_obj->sgt) {
> +               if (IS_ERR(msm_obj->sgt)) {
>                         dev_err(dev->dev, "failed to allocate sgt\n");
> -                       return ERR_PTR(-ENOMEM);
> +                       return ERR_CAST(msm_obj->sgt);
>                 }
>
>                 msm_obj->pages = p;
>
