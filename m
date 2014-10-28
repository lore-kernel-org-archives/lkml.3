Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbaJ1H3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:29:00 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:54508 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753424AbaJ1DmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:42:14 -0400
Message-ID: <544F108D.30906@daenzer.net>
Date: Tue, 28 Oct 2014 12:42:05 +0900
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:32.0) Gecko/20100101 Icedove/32.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11 V2] radeon: evergreen: Fix probable mask
 then right shift defect
References: <cover.1414387334.git.joe@perches.com> <88c64cce88264069e0e1637fc874e699e5b226f6.1414387334.git.joe@perches.com> <544E0D0E.6080206@daenzer.net> <1414419297.8884.5.camel@perches.com>
In-Reply-To: <1414419297.8884.5.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.10.2014 23:14, Joe Perches wrote:
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
>
>   drivers/gpu/drm/radeon/evergreen.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
> index a31f1ca..a97a685 100644
> --- a/drivers/gpu/drm/radeon/evergreen.c
> +++ b/drivers/gpu/drm/radeon/evergreen.c
> @@ -3303,7 +3303,8 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
>   	rdev->config.evergreen.tile_config |=
>   		((gb_addr_config & 0x30000000) >> 28) << 12;
>
> -	num_shader_engines = (gb_addr_config & NUM_SHADER_ENGINES(3) >> 12) + 1;
> +	num_shader_engines = ((gb_addr_config & NUM_SHADER_ENGINES_MASK)
> +			      >> NUM_SHADER_ENGINES_SHIFT) + 1;
>
>   	if ((rdev->family >= CHIP_CEDAR) && (rdev->family <= CHIP_HEMLOCK)) {
>   		u32 efuse_straps_4;

Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
