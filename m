Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaKUKYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:24:10 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52718 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbaKUKYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:24:08 -0500
Message-ID: <1416565445.6958.3.camel@x220>
Subject: Re: [PATCH v5 08/24] amdkfd: Add amdkfd skeleton driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Ben Goz <ben.goz@amd.com>, Jay Cornwall <jay.cornwall@amd.com>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>
Date: Fri, 21 Nov 2014 11:24:05 +0100
In-Reply-To: <1415471865-1893-9-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	 <1415471865-1893-9-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2014 10:24:05.0653 (UTC) FILETIME=[4722F450:01D00575]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-08 at 20:37 +0200, Oded Gabbay wrote:
> This patch adds the amdkfd skeleton driver. The driver does nothing except
> define a /dev/kfd device.
> 
> It returns -ENODEV on all amdkfd IOCTLs.
> 
> v3: Move bool field to the end of structure, removed the pmc ioctls and added
> a meaningful error message for ioctl error.
> 
> v5:
> 
> Create a new folder drm/amd and move amdkfd from drm/radeon/ to drm/amd/
> Remove scheduler_class from kfd_priv.h as it was never used
> Add skeleton implementation of the Get Version IOCTL
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

It seems v6 of this patch is included in today's linux-next (ie,
next-20141121).

>  drivers/gpu/drm/Kconfig                  |   2 +
>  drivers/gpu/drm/Makefile                 |   1 +
>  drivers/gpu/drm/amd/amdkfd/Kconfig       |  10 ++
>  drivers/gpu/drm/amd/amdkfd/Makefile      |   9 ++
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 210 +++++++++++++++++++++++++++++++
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c  | 130 +++++++++++++++++++
>  drivers/gpu/drm/amd/amdkfd/kfd_module.c  | 101 +++++++++++++++
>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  81 ++++++++++++
>  8 files changed, 544 insertions(+)
> [...]
> diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
> new file mode 100644
> index 0000000..a2ae6d4
> --- /dev/null
> +++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Heterogenous system architecture configuration
> +#
> +
> +config HSA_AMD
> +	tristate "HSA kernel driver for AMD GPU devices"
> +	depends on (DRM_RADEON || DRM_AMDGPU) && AMD_IOMMU_V2 && X86_64

There's currently no Kconfig symbol DRM_AMDGPU (nor anything similar).
Will that symbol be added in a future patch?

> +	default m
> +	help
> +	  Enable this if you want to use HSA features on AMD GPU devices.


Paul Bolle

