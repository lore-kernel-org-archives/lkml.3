Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaJ1OGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:06:22 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:65359 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJ1OGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <1414419297.8884.5.camel@perches.com>
References: <cover.1414387334.git.joe@perches.com>
	<88c64cce88264069e0e1637fc874e699e5b226f6.1414387334.git.joe@perches.com>
	<544E0D0E.6080206@daenzer.net>
	<1414419297.8884.5.camel@perches.com>
Date: Tue, 28 Oct 2014 10:06:20 -0400
Message-ID: <CADnq5_PCaBUMrUTAXJ5DswQR0jajoEJoAa-Jjhz79OrZUn6XGw@mail.gmail.com>
Subject: Re: [PATCH 02/11 V2] radeon: evergreen: Fix probable mask then right
 shift defect
From: Alex Deucher <alexdeucher@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:14 AM, Joe Perches <joe@perches.com> wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
>
> Add parentheses around the mask.
>
> Use the already #defined values instead of hardcoding.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>> I think this should be NUM_SHADER_ENGINES_SHIFT?
>
> (Joe can't type)
>
> exactly right, thanks Michel

Applied with a compile fix.

Thanks,

Alex

>
>  drivers/gpu/drm/radeon/evergreen.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
> index a31f1ca..a97a685 100644
> --- a/drivers/gpu/drm/radeon/evergreen.c
> +++ b/drivers/gpu/drm/radeon/evergreen.c
> @@ -3303,7 +3303,8 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
>         rdev->config.evergreen.tile_config |=
>                 ((gb_addr_config & 0x30000000) >> 28) << 12;
>
> -       num_shader_engines = (gb_addr_config & NUM_SHADER_ENGINES(3) >> 12) + 1;
> +       num_shader_engines = ((gb_addr_config & NUM_SHADER_ENGINES_MASK)
> +                             >> NUM_SHADER_ENGINES_SHIFT) + 1;
>
>         if ((rdev->family >= CHIP_CEDAR) && (rdev->family <= CHIP_HEMLOCK)) {
>                 u32 efuse_straps_4;
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
