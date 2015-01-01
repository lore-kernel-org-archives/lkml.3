Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbbAAUET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 15:04:19 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57878 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbbAAUER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 15:04:17 -0500
MIME-Version: 1.0
In-Reply-To: <1420131342-30418-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420131342-30418-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Thu, 1 Jan 2015 21:04:15 +0100
Message-ID: <CAMeQTsZv2x5CMM2Kf6hwohy9tGHB64DusiEwk9oGFJHp2oYvyg@mail.gmail.com>
Subject: Re: [PATCH] gpu: drm: gma500: mmu.c: Remove unused function
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Airlie <airlied@linux.ie>, "H. Peter Anvin" <hpa@linux.intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 5:55 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function psb_get_default_pd_addr() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Hej Rickard

I'd like to keep that function since it's relevant to getting the MSVDX running.
I'm not working on it but someone else might be.

> ---
>  drivers/gpu/drm/gma500/mmu.c |    9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
> index 0eaf11c..557cae7 100644
> --- a/drivers/gpu/drm/gma500/mmu.c
> +++ b/drivers/gpu/drm/gma500/mmu.c
> @@ -426,15 +426,6 @@ struct psb_mmu_pd *psb_mmu_get_default_pd(struct psb_mmu_driver *driver)
>         return pd;
>  }
>
> -/* Returns the physical address of the PD shared by sgx/msvdx */
> -uint32_t psb_get_default_pd_addr(struct psb_mmu_driver *driver)
> -{
> -       struct psb_mmu_pd *pd;
> -
> -       pd = psb_mmu_get_default_pd(driver);
> -       return page_to_pfn(pd->p) << PAGE_SHIFT;
> -}
> -
>  void psb_mmu_driver_takedown(struct psb_mmu_driver *driver)
>  {
>         struct drm_device *dev = driver->dev;
> --
> 1.7.10.4
>
