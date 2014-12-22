Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaLVQ64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:58:56 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:60711 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaLVQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:58:43 -0500
MIME-Version: 1.0
In-Reply-To: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
Date: Mon, 22 Dec 2014 11:58:43 -0500
Message-ID: <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
From: Alex Deucher <alexdeucher@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Alexander Deucher <Alexander.Deucher@amd.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>, LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Huang Ying <ying.huang@intel.com>, LKP ML <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 6:11 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> amdkfd driver can be compiled only in 64-bit kernel. Therefore, there is no
> point in trying to initialize amdkfd in 32-bit kernel.
>
> In addition, in case of specific configuration of 32-bit kernel, no modules and
> random kernel base, the symbol_request function doesn't work as expected - It
> doesn't return NULL if the symbol doesn't exists. That makes the kernel panic.
> Therefore, the as amdkfd doesn't compile in 32-bit kernel, the best way is just
> to return false immediately.
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/radeon_kfd.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
> index 242fd8b..cb77e5c 100644
> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
> @@ -101,6 +101,7 @@ static const struct kgd2kfd_calls *kgd2kfd;
>
>  bool radeon_kfd_init(void)
>  {
> +#ifdef CONFIG_X86_64
>         bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
>                                 const struct kgd2kfd_calls**);
>
> @@ -117,6 +118,9 @@ bool radeon_kfd_init(void)
>         }
>
>         return true;
> +#else
> +       return false;
> +#endif
>  }
>
>  void radeon_kfd_fini(void)
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
