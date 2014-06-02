Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaFBHsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:48:42 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:34302 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaFBHsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:48:41 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.2
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de D14AE6A4376
Message-ID: <538C2C49.9060000@vodafone.de>
Date: Mon, 02 Jun 2014 09:48:25 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] gpu: drm: radeon: r600_cp.c: Cleaning up uninitialized
 variables
References: <1401577805-4609-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401577805-4609-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.06.2014 01:10, schrieb Rickard Strandqvist:
> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

On the one hand it looks like a valid fix to me, but on the other hand 
the r600_cp.c code is deprecated for something like five years now.

I would like to avoid touching it in any way and just let it rest 
peacefully until we can remove it entirely.

Christian.

> ---
>   drivers/gpu/drm/radeon/r600_cp.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/r600_cp.c b/drivers/gpu/drm/radeon/r600_cp.c
> index 8c9b7e2..0770ad6 100644
> --- a/drivers/gpu/drm/radeon/r600_cp.c
> +++ b/drivers/gpu/drm/radeon/r600_cp.c
> @@ -2615,7 +2615,7 @@ int r600_cs_legacy_ioctl(struct drm_device *dev, void *data, struct drm_file *fp
>   	struct drm_radeon_cs *cs = data;
>   	struct drm_buf *buf;
>   	unsigned family;
> -	int l, r = 0;
> +	int l = 0, r = 0;
>   	u32 *ib, cs_id = 0;
>   
>   	if (dev_priv == NULL) {

