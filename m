Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbbAKVWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:22:41 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55468 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbAKVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:22:40 -0500
Message-ID: <54B2E455.7050707@gmail.com>
Date: Sun, 11 Jan 2015 22:00:05 +0100
From: Samuel Pitoiset <samuel.pitoiset@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: nouveau: core: engine: perfmon: base: Remove unused
 function
References: <1420999965-22216-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420999965-22216-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

Thanks for submitting this patch, but I already submitted the same a few 
weeks ago. :-)

This function will be removed when I will submit my work on this area.

Greetings,
Samuel Pitoiset.

On 01/11/2015 07:12 PM, Rickard Strandqvist wrote:
> Remove the function nouveau_perfsig_wrap() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/gpu/drm/nouveau/core/engine/perfmon/base.c |   20 --------------------
>   drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h |    5 -----
>   2 files changed, 25 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
> index 6301381..d0c5255 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
> +++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c
> @@ -80,26 +80,6 @@ nouveau_perfsig_find(struct nouveau_perfmon *ppm, const char *name, u32 size,
>   	return nouveau_perfsig_find_(dom, name, size);
>   }
>   
> -struct nouveau_perfctr *
> -nouveau_perfsig_wrap(struct nouveau_perfmon *ppm, const char *name,
> -		     struct nouveau_perfdom **pdom)
> -{
> -	struct nouveau_perfsig *sig;
> -	struct nouveau_perfctr *ctr;
> -
> -	sig = nouveau_perfsig_find(ppm, name, strlen(name), pdom);
> -	if (!sig)
> -		return NULL;
> -
> -	ctr = kzalloc(sizeof(*ctr), GFP_KERNEL);
> -	if (ctr) {
> -		ctr->signal[0] = sig;
> -		ctr->logic_op = 0xaaaa;
> -	}
> -
> -	return ctr;
> -}
> -
>   /*******************************************************************************
>    * Perfmon object classes
>    ******************************************************************************/
> diff --git a/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h b/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
> index 0ac8714..1a0989e 100644
> --- a/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
> +++ b/drivers/gpu/drm/nouveau/core/engine/perfmon/priv.h
> @@ -30,11 +30,6 @@ struct nouveau_perfsig {
>   	const char *name;
>   };
>   
> -struct nouveau_perfdom;
> -struct nouveau_perfctr *
> -nouveau_perfsig_wrap(struct nouveau_perfmon *, const char *,
> -		     struct nouveau_perfdom **);
> -
>   struct nouveau_specdom {
>   	u16 signal_nr;
>   	const struct nouveau_specsig *signal;

