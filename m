Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbaHZGf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:35:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65009 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbaHZGfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:35:25 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ea-53fc2aaa5b58
Message-id: <53FC2AA1.7030605@samsung.com>
Date: Tue, 26 Aug 2014 08:35:13 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 15/15] drm/exynos/fimc: fix source buffer registers
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-16-git-send-email-a.hajda@samsung.com>
 <53FC21DF.1010504@samsung.com>
In-reply-to: <53FC21DF.1010504@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xq7qrtP4EGxz+omZx5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Rz4PC4332cyaNvyypGj8+b5AKYo7hs
	UlJzMstSi/TtErgyrk1dz1qwWLhi9TXhBsYn/F2MHBwSAiYSfRtUuxg5gUwxiQv31rN1MXJx
	CAksZZT4t/AHC4TziVFiwdt5jCBVvAJaEnNnfWIDsVkEVCXePp0JFmcT0JT4u/kmWFxUIEzi
	2a+DTBD1ghI/Jt9jAbFFBHwltvx/zQgylFlgAZPEtwcdYEXCAu4SXzdsZgaxhQTmM0pM3cwN
	YnMKaEsc/NXOCnIps4CexP2LWiBhZgF5ic1r3jJPYBSYhWTFLISqWUiqFjAyr2IUTS1NLihO
	Ss810itOzC0uzUvXS87P3cQICeuvOxiXHrM6xCjAwajEw/sg7XewEGtiWXFl7iFGCQ5mJRFe
	hodAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxsh374x4aXxaR/TJXpesojHTZjxzqbBTv2Xrx3
	7FLsvjnreCaHRmaf8ttUx2gto/tIaG38FG271pltr+dbrXRnYJ+il7yEO2z1odjDzx7MEg97
	lx2btvu0ioLuXJP7DU5TQrh2fF8/bVddWHBM7Y+FN6qmiEpVBmZ+sZRaYPLhTRpzp3jNrxtK
	LMUZiYZazEXFiQCt1CICSQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 07:57 AM, Joonyoung Shim wrote:
> Hi Andrzej,
>
> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>> FIMC in default mode of operation uses only one input buffer,
>> but the driver used also second buffer, as a result only the
>> first frame was processed correctly. The patch fixes it.
> I can't understand well, then we don't need to distinguish buf_id in
> fimc_src_set_addr()?
Yes. FIMC in default operation mode uses only one input buffer pointer
which should
be updated when processing of the previous buffer has been finished.

There exists also ping-pong mode which uses two buffer pointers, as I
have spotted in
specs. However I have not seen it was implemented neither in drm,
neither in camera drivers.
I will try to implement it later.

Regards
Andrzej

>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_fimc.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>> index b20078e..e985253 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>> @@ -720,24 +720,24 @@ static int fimc_src_set_addr(struct device *dev,
>>  	case IPP_BUF_ENQUEUE:
>>  		config = &property->config[EXYNOS_DRM_OPS_SRC];
>>  		fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_Y],
>> -			EXYNOS_CIIYSA(buf_id));
>> +			EXYNOS_CIIYSA0);
>>  
>>  		if (config->fmt == DRM_FORMAT_YVU420) {
>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
>> -				EXYNOS_CIICBSA(buf_id));
>> +				EXYNOS_CIICBSA0);
>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
>> -				EXYNOS_CIICRSA(buf_id));
>> +				EXYNOS_CIICRSA0);
>>  		} else {
>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
>> -				EXYNOS_CIICBSA(buf_id));
>> +				EXYNOS_CIICBSA0);
>>  			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
>> -				EXYNOS_CIICRSA(buf_id));
>> +				EXYNOS_CIICRSA0);
>>  		}
>>  		break;
>>  	case IPP_BUF_DEQUEUE:
>> -		fimc_write(ctx, 0x0, EXYNOS_CIIYSA(buf_id));
>> -		fimc_write(ctx, 0x0, EXYNOS_CIICBSA(buf_id));
>> -		fimc_write(ctx, 0x0, EXYNOS_CIICRSA(buf_id));
>> +		fimc_write(ctx, 0x0, EXYNOS_CIIYSA0);
>> +		fimc_write(ctx, 0x0, EXYNOS_CIICBSA0);
>> +		fimc_write(ctx, 0x0, EXYNOS_CIICRSA0);
>>  		break;
>>  	default:
>>  		/* bypass */
>>
>

