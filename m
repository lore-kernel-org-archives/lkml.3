Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaLTVZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 16:25:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLTVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 16:25:21 -0500
Date: Sat, 20 Dec 2014 13:25:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jerome Glisse <j.glisse@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, John Bridgman <John.Bridgman@amd.com>,
        Alexander.Deucher@amd.com
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
Message-ID: <20141220212515.GA30589@kroah.com>
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
 <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 10:46:12PM +0200, Oded Gabbay wrote:
> When amdkfd and radeon are compiled inside the kernel image (not as modules),
> radeon will load before amdkfd and will set *kfd2kgd to its interface
> structure. Therefore, we must not set *kfd2kgd to NULL when amdkfd is loaded
> because it will override radeon's initialization and cause kernel BUG.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_module.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
> index 95d5af1..236562f 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
> @@ -34,7 +34,7 @@
>  #define KFD_DRIVER_MINOR	7
>  #define KFD_DRIVER_PATCHLEVEL	0
>  
> -const struct kfd2kgd_calls *kfd2kgd;
> +const struct kfd2kgd_calls *kfd2kgd = NULL;

This change does nothing, that is what the original code did already.

thanks,

greg k-h
