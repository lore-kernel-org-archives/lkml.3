Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaHZFxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:53:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21546 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaHZFxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:53:50 -0400
X-AuditID: cbfee68d-f79c46d000000b84-16-53fc20ec292c
Message-id: <53FC20EC.7070209@samsung.com>
Date: Tue, 26 Aug 2014 14:53:48 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 14/15] drm/exynos/fimc: simplify buffer queuing
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-15-git-send-email-a.hajda@samsung.com>
In-reply-to: <1408693946-15456-15-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsWyRsSkRPeNwp9gg9X/ZC1urTvHanHl63s2
	i0n3J7BYvLh3kcXibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDI6991mLpgjXXF99zTmBsZLol2MnBwSAiYSr+/vZYWwxSQu3FvP
	BmILCSxllGjsLIWp+f1yD0sXIxdQfDqjxO+W81DOK0aJlv5PLCBVvAJaEpOOfGLsYuTgYBFQ
	lZi1QxYkzCagJ3Fn23EmEFtUIETizfF2dohyQYkfk++BtYoIeEjMf7OHGcRmFjjDJPF1vS6I
	LSzgLLF20TEmiIPqJC73zATr5RRwlTj25zg7yCpmoPn3L2pBtMpLbF7zlhnkNAmBc+wST+/v
	ApvPIiAg8W3yIRaQegkBWYlNB5gh/pKUOLjiBssERrFZSC6ahTB1FpKpCxiZVzGKphYkFxQn
	pRcZ6hUn5haX5qXrJefnbmIERtzpf896dzDePmB9iFGAg1GJh/dG/O9gIdbEsuLK3EOMpkBH
	TGSWEk3OB8Z1Xkm8obGZkYWpiamxkbmlmZI4r6LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjM3Lk/Xr102uPmNvHDRZbdLv4tCbcxszNi2dt2ltUBODbtvkRAHuqlfLVi+d8X7GsqlC
	J5YdmfMhS6o2f6InJ3PyOlUVvRS9ScUGd34FPwpeLGPvL6EXb33JS+DTlaUnbfa7Cc68z90j
	XnhMT2tP7NYJyuJyp2MXXF+gpn5l/6bLdT+DLyy8sFyJpTgj0VCLuag4EQCAznpkswIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd03Cn+CDZqWi1ncWneO1eLK1/ds
	FpPuT2CxeHHvIovF2aY37BaXd81hs5hxfh+Txdojd9ktZkx+yebA6XG/+ziTR9+WVYwenzfJ
	BTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM6Nx3m7lgjnTF9d3TmBsY
	L4l2MXJySAiYSPx+uYcFwhaTuHBvPVsXIxeHkMB0RonfLedZIJxXjBIt/Z/AqngFtCQmHfnE
	2MXIwcEioCoxa4csSJhNQE/izrbjTCC2qECIxJvj7ewQ5YISPybfA2sVEfCQmP9mDzOIzSxw
	hkni63pdEFtYwFli7aJjYL1CAnUSl3tmgvVyCrhKHPtznB1kFTPQ/PsXtSBa5SU2r3nLPIFR
	YBaSDbMQqmYhqVrAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziin0ntYFzZYHGIUYCD
	UYmH90b872Ah1sSy4srcQ4wSHMxKIrwMD4FCvCmJlVWpRfnxRaU5qcWHGE2B3p/ILCWanA9M
	Nnkl8YbGJmZGlkbmhhZGxuZK4rwHWq0DhQTSE0tSs1NTC1KLYPqYODilGhg7Na5smHHub+za
	7YzHujqn29Xd5zdMYzqUc3y56p3/Sx+ETbtwQkS/inG6+CF3rZtSG4t/lE51rjJ7u+lh7sOK
	bOmcV1fdNnk9n/vfKubGhEWfv3X3/J0w/y3bhtmaTo99fBI/3vBfueRJv1vGv9QkB/GNG4I0
	vcNsnOou2O7kMbz9sCjpwwIuJZbijERDLeai4kQAkWLoH/4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
> The patch removes redundant checks, redundant HW reads
> and simplifies code.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c | 64 ++++++++------------------------
>  1 file changed, 15 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> index bd6628d..b20078e 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
> @@ -1124,67 +1124,34 @@ static int fimc_dst_set_size(struct device *dev, int swap,
>  	return 0;
>  }
>  
> -static int fimc_dst_get_buf_count(struct fimc_context *ctx)
> -{
> -	u32 cfg, buf_num;
> -
> -	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
> -
> -	buf_num = hweight32(cfg);
> -
> -	DRM_DEBUG_KMS("buf_num[%d]\n", buf_num);
> -
> -	return buf_num;
> -}
> -
> -static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
> +static void fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
>  		enum drm_exynos_ipp_buf_type buf_type)
>  {
> -	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
> -	bool enable;
> -	u32 cfg;
> -	u32 mask = 0x00000001 << buf_id;
> -	int ret = 0;
>  	unsigned long flags;
> +	u32 buf_num;
> +	u32 cfg;
>  
>  	DRM_DEBUG_KMS("buf_id[%d]buf_type[%d]\n", buf_id, buf_type);
>  
>  	spin_lock_irqsave(&ctx->lock, flags);
>  
> -	/* mask register set */
>  	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
>  
> -	switch (buf_type) {
> -	case IPP_BUF_ENQUEUE:
> -		enable = true;
> -		break;
> -	case IPP_BUF_DEQUEUE:
> -		enable = false;
> -		break;
> -	default:
> -		dev_err(ippdrv->dev, "invalid buf ctrl parameter.\n");
> -		ret =  -EINVAL;
> -		goto err_unlock;
> -	}
> +	if (buf_type == IPP_BUF_ENQUEUE)
> +		cfg |= (1 << buf_id);
> +	else
> +		cfg &= (1 << buf_id);

~ Missing?

>  
> -	/* sequence id */
> -	cfg &= ~mask;
> -	cfg |= (enable << buf_id);
>  	fimc_write(ctx, cfg, EXYNOS_CIFCNTSEQ);
>  
> -	/* interrupt enable */
> -	if (buf_type == IPP_BUF_ENQUEUE &&
> -	    fimc_dst_get_buf_count(ctx) >= FIMC_BUF_START)
> -		fimc_mask_irq(ctx, true);
> +	buf_num = hweight32(cfg);
>  
> -	/* interrupt disable */
> -	if (buf_type == IPP_BUF_DEQUEUE &&
> -	    fimc_dst_get_buf_count(ctx) <= FIMC_BUF_STOP)
> +	if (buf_type == IPP_BUF_ENQUEUE && buf_num >= FIMC_BUF_START)
> +		fimc_mask_irq(ctx, true);
> +	else if (buf_type == IPP_BUF_DEQUEUE && buf_num <= FIMC_BUF_STOP)
>  		fimc_mask_irq(ctx, false);
>  
> -err_unlock:
>  	spin_unlock_irqrestore(&ctx->lock, flags);
> -	return ret;
>  }
>  
>  static int fimc_dst_set_addr(struct device *dev,
> @@ -1242,7 +1209,9 @@ static int fimc_dst_set_addr(struct device *dev,
>  		break;
>  	}
>  
> -	return fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
> +	fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
> +
> +	return 0;
>  }
>  
>  static struct exynos_drm_ipp_ops fimc_dst_ops = {
> @@ -1297,10 +1266,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
>  
>  	DRM_DEBUG_KMS("buf_id[%d]\n", buf_id);
>  
> -	if (fimc_dst_set_buf_seq(ctx, buf_id, IPP_BUF_DEQUEUE) < 0) {
> -		DRM_ERROR("failed to dequeue.\n");
> -		return IRQ_HANDLED;
> -	}
> +	fimc_dst_set_buf_seq(ctx, buf_id, IPP_BUF_DEQUEUE);
>  
>  	event_work->ippdrv = ippdrv;
>  	event_work->buf_id[EXYNOS_DRM_OPS_DST] = buf_id;
> 

