Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaAHQkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:40:31 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33848 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbaAHQk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <8af55c93ab10b11d473f9c731eddd6710ae7a418.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
	<8af55c93ab10b11d473f9c731eddd6710ae7a418.1389018324.git.rashika.kheria@gmail.com>
Date: Wed, 8 Jan 2014 11:40:28 -0500
Message-ID: <CADnq5_OrzQ+Jr0G6pzLq99ivA7WEc2dnEmY6S3y6FKWwXZ09TA@mail.gmail.com>
Subject: Re: [PATCH 22/85] drivers: gpu: Mark functions as static in radeon_device.c
From: Alex Deucher <alexdeucher@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 10:21 AM, Rashika Kheria
<rashika.kheria@gmail.com> wrote:
> Mark functions radeon_doorbell_init() and radeon_doorbell_fini() as
> static in drm/radeon/radeon_device.c because they are not used outside
> this file.
>
> This eliminates the following warning in drm/radeon/radeon_device.c:
> drivers/gpu/drm/radeon/radeon_device.c:252:5: warning: no previous prototype for ‘radeon_doorbell_init’ [-Wmissing-prototypes]
> drivers/gpu/drm/radeon/radeon_device.c:281:6: warning: no previous prototype for ‘radeon_doorbell_fini’ [-Wmissing-prototypes]
>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I've pulled in a subset of these patches:
http://cgit.freedesktop.org/~agd5f/linux/log/?h=drm-next-3.14-wip
I held off on some of the others as I'd rather fix up the headers
properly rather than just cramming everything in radeon.h or
radeon-asic.h for now.

Thanks!

Alex

> ---
>  drivers/gpu/drm/radeon/radeon_device.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 39b033b..caf4975 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -249,7 +249,7 @@ void radeon_scratch_free(struct radeon_device *rdev, uint32_t reg)
>   * Init doorbell driver information (CIK)
>   * Returns 0 on success, error on failure.
>   */
> -int radeon_doorbell_init(struct radeon_device *rdev)
> +static int radeon_doorbell_init(struct radeon_device *rdev)
>  {
>         /* doorbell bar mapping */
>         rdev->doorbell.base = pci_resource_start(rdev->pdev, 2);
> @@ -278,7 +278,7 @@ int radeon_doorbell_init(struct radeon_device *rdev)
>   *
>   * Tear down doorbell driver information (CIK)
>   */
> -void radeon_doorbell_fini(struct radeon_device *rdev)
> +static void radeon_doorbell_fini(struct radeon_device *rdev)
>  {
>         iounmap(rdev->doorbell.ptr);
>         rdev->doorbell.ptr = NULL;
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
