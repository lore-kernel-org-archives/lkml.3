Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbaHZFAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:00:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46423 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933725AbaHZFAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:00:17 -0400
X-AuditID: cbfee690-f79ce6d00000115a-99-53fc145fc54a
Message-id: <53FC1460.5090000@samsung.com>
Date: Tue, 26 Aug 2014 14:00:16 +0900
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
Subject: Re: [PATCH 06/15] drm/exynos/ipp: free partially allocated resources
 on error
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-7-git-send-email-a.hajda@samsung.com>
In-reply-to: <1408693946-15456-7-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWyRsSkSDde5E+wwZReVYtb686xWlz5+p7N
	YtL9CSwWL+5dZLE42/SG3eLyrjlsFjPO72OyWHvkLrvFjMkv2Rw4Pe53H2fy6NuyitHj8ya5
	AOYoLpuU1JzMstQifbsErox1+1axFawRr5jaeJqtgfGMUBcjJ4eEgInEg79XmCFsMYkL99az
	dTFycQgJLGWU2PvsGCtM0dEjq1kgEtMZJY73tUE5rxgl+tb+AKviFdCSeLf/AhuIzSKgKrF9
	01mwOJuAnsSdbceZQGxRgRCJN8fb2SHqBSV+TL7HAmKLCHhIzH+zB+wMZoEzTBJf1+uC2MIC
	ERJ/Tx4HqxESqJVY/2gm0EwODk4BF4nDTdwgJjPQ+PsXtSA65SU2r3nLDHKahMA5dokdhxpZ
	Ic4RkPg2+RALSL2EgKzEpgNQD0tKHFxxg2UCo9gsJAfNQpg6C8nUBYzMqxhFUwuSC4qT0otM
	9IoTc4tL89L1kvNzNzECY+70v2cTdjDeO2B9iFGAg1GJh/dG/O9gIdbEsuLK3EOMpkBHTGSW
	Ek3OB0Z2Xkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GBV1GxZb3BSU21+2OXhfy+s9a2VkJ+hqm2RM1Xu8bKaqzJ0Fp2b6XrymHeMv9tHuzbp2nUdV
	mq9OiD8JULR+Idw065dzzIGQh9zGT1XFQ1XXzPO8Eq/8N71hz9oL/gv3HanO3sujf+l6nPGf
	Xou0lt2M+/zkF4aoata/WbiR02ta8MQPnum/QpRYijMSDbWYi4oTAdFdIG60AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd14kT/BBo9/y1rcWneO1eLK1/ds
	FpPuT2CxeHHvIovF2aY37BaXd81hs5hxfh+Txdojd9ktZkx+yebA6XG/+ziTR9+WVYwenzfJ
	BTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWLdvFVvBGvGKqY2n2RoY
	zwh1MXJySAiYSBw9spoFwhaTuHBvPVsXIxeHkMB0RonjfW0sEM4rRom+tT9YQap4BbQk3u2/
	wAZiswioSmzfdBYsziagJ3Fn23EmEFtUIETizfF2doh6QYkfk++BbRAR8JCY/2YPM4jNLHCG
	SeLrel0QW1ggQuLvyeNgNUICtRLrH80EmsnBwSngInG4iRvEZAYaf/+iFkSnvMTmNW+ZJzAK
	zEKyYBZC1SwkVQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf0M+kdjKsaLA4xCnAw
	KvHw3oj/HSzEmlhWXJl7iFGCg1lJhJfhIVCINyWxsiq1KD++qDQntfgQoynQ+xOZpUST84HJ
	Jq8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUAyOX8Q62vOn21tqX
	D3PJFaqv+7hI2bfegb3f17hCszb3lfdGJ6ZjkzKY18Qb+5yenpM6OXvpzoK+qr+/F3Icty/U
	3PtO/n/Zwl9/Vi3afjxZenXS7Rk/eC56MPvEm759c33t7fXfqgtnWRoqmPOt7pTPSr+6aHoK
	W9oX85zdXFN+N0kZeaVM3KDEUpyRaKjFXFScCADwHi5H/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
> In case of allocation errors some already allocated buffers
> were not freed. The patch fixes it.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 68 ++++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> index 060a198..728f3b9 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
> @@ -599,6 +599,37 @@ static int ipp_set_mem_node(struct exynos_drm_ippdrv *ippdrv,
>  	return ret;
>  }
>  
> +static int ipp_put_mem_node(struct drm_device *drm_dev,
> +		struct drm_exynos_ipp_cmd_node *c_node,
> +		struct drm_exynos_ipp_mem_node *m_node)
> +{
> +	int i;
> +
> +	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
> +
> +	if (!m_node) {
> +		DRM_ERROR("invalid dequeue node.\n");
> +		return -EFAULT;
> +	}
> +
> +	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
> +
> +	/* put gem buffer */
> +	for_each_ipp_planar(i) {
> +		unsigned long handle = m_node->buf_info.handles[i];
> +		if (handle)
> +			exynos_drm_gem_put_dma_addr(drm_dev, handle,
> +							c_node->filp);
> +	}
> +
> +	/* conditionally remove from queue */
> +	if (m_node->list.next)

How about do INIT_LIST_HEAD for list in ipp_get_mem_node()?

> +		list_del(&m_node->list);
> +	kfree(m_node);
> +
> +	return 0;
> +}
> +
>  static struct drm_exynos_ipp_mem_node
>  		*ipp_get_mem_node(struct drm_device *drm_dev,
>  		struct drm_file *file,
> @@ -634,7 +665,8 @@ static struct drm_exynos_ipp_mem_node
>  					qbuf->handle[i], file);
>  			if (IS_ERR(addr)) {
>  				DRM_ERROR("failed to get addr.\n");
> -				goto err_clear;
> +				ipp_put_mem_node(drm_dev, c_node, m_node);
> +				return ERR_PTR(-EFAULT);
>  			}
>  
>  			buf_info->handles[i] = qbuf->handle[i];
> @@ -649,40 +681,6 @@ static struct drm_exynos_ipp_mem_node
>  	mutex_unlock(&c_node->mem_lock);
>  
>  	return m_node;
> -
> -err_clear:
> -	kfree(m_node);
> -	return ERR_PTR(-EFAULT);
> -}
> -
> -static int ipp_put_mem_node(struct drm_device *drm_dev,
> -		struct drm_exynos_ipp_cmd_node *c_node,
> -		struct drm_exynos_ipp_mem_node *m_node)
> -{
> -	int i;
> -
> -	DRM_DEBUG_KMS("node[0x%x]\n", (int)m_node);
> -
> -	if (!m_node) {
> -		DRM_ERROR("invalid dequeue node.\n");
> -		return -EFAULT;
> -	}
> -
> -	DRM_DEBUG_KMS("ops_id[%d]\n", m_node->ops_id);
> -
> -	/* put gem buffer */
> -	for_each_ipp_planar(i) {
> -		unsigned long handle = m_node->buf_info.handles[i];
> -		if (handle)
> -			exynos_drm_gem_put_dma_addr(drm_dev, handle,
> -							c_node->filp);
> -	}
> -
> -	/* delete list in queue */
> -	list_del(&m_node->list);
> -	kfree(m_node);
> -
> -	return 0;
>  }
>  
>  static void ipp_free_event(struct drm_pending_event *event)
> 

