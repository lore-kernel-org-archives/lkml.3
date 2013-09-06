Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3IFNXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:23:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36756 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3IFNX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:23:29 -0400
Date: Fri, 6 Sep 2013 09:23:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Jeyaraman R <jeyaraman.rangasamy@lge.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Howells <dhowells@redhat.com>, dsaxena@linaro.org,
        Dave Airlie <airlied@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] DRM: TTM: Fix memory leak issue in ttm_agp_tt_create().
Message-ID: <20130906132300.GH2590@phenom.dumpdata.com>
References: <1378276090-10130-1-git-send-email-manjunath.goudar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378276090-10130-1-git-send-email-manjunath.goudar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 11:58:10AM +0530, Manjunath Goudar wrote:
> From: Jeyaraman R <jeyaraman.rangasamy@lge.com> 
> 
> This patch adds kfree() in ttm_agp_tt_create() to avoide the
> memory leak, without this there is a chance of memory leak in
> ttm_tt_init() fail case.
> 
> Signed-off-by: Jeyaraman R <jeyaraman.rangasamy@lge.com>
> Signed-off-by: Manjunath Goudar <manjunath.goudar@linaro.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> ---
>  drivers/gpu/drm/ttm/ttm_agp_backend.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
> index 3302f99..764be36 100644
> --- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
> +++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
> @@ -126,6 +126,7 @@ struct ttm_tt *ttm_agp_tt_create(struct ttm_bo_device *bdev,
>  	agp_be->ttm.func = &ttm_agp_func;
>  
>  	if (ttm_tt_init(&agp_be->ttm, bdev, size, page_flags, dummy_read_page)) {
> +		kfree(agp_be);
>  		return NULL;
>  	}
>  
> -- 
> 1.8.1.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
