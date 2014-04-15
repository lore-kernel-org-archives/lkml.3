Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaDOHAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:00:42 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:57939 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOHAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:00:41 -0400
Date: Tue, 15 Apr 2014 03:00:35 -0400 (EDT)
From: Ben Skeggs <bskeggs@redhat.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <1876072135.7241792.1397545235729.JavaMail.zimbra@redhat.com>
In-Reply-To: <3009531.aHrQhHYAOc@daeseok-laptop.cloud.net>
References: <3009531.aHrQhHYAOc@daeseok-laptop.cloud.net>
Subject: Re: [PATCH] drm/nouveau/clk: fix possible NULL pointer dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC34 (Linux)/8.0.6_GA_5922)
Thread-Topic: drm/nouveau/clk: fix possible NULL pointer dereference
Thread-Index: A0MaHsv+gxFlldNZImOIhYbCpbv0ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Daeseok Youn" <daeseok.youn@gmail.com>
> To: airlied@linux.ie
> Cc: bskeggs@redhat.com, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
> Sent: Tuesday, 15 April, 2014 11:56:49 AM
> Subject: [PATCH] drm/nouveau/clk: fix possible NULL pointer dereference
> 
> 
> It need to be checking NULL before dereferencing.
There's no dereference here.  It's an address calculation only.

> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/gpu/drm/nouveau/core/subdev/clock/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> index dd62bae..a586d030 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> @@ -290,9 +290,9 @@ nouveau_pstate_new(struct nouveau_clock *clk, int idx)
>  		return 0;
>  
>  	pstate = kzalloc(sizeof(*pstate), GFP_KERNEL);
> -	cstate = &pstate->base;
>  	if (!pstate)
>  		return -ENOMEM;
> +	cstate = &pstate->base;
>  
>  	INIT_LIST_HEAD(&pstate->list);
>  
> --
> 1.7.4.4
> 
> 
> 
