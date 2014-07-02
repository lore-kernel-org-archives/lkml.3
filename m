Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaGBJJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:09:25 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49634 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaGBJJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <1403760814-26148-1-git-send-email-acourbot@nvidia.com>
References: <1403760814-26148-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 2 Jul 2014 18:09:03 +0900
Message-ID: <CAAVeFu+O+Z7kQ3Sre=WKkcYoxXYUx4zCzZK8cVMj1WAtwA5eMg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] drm/nouveau: support for probing platform devices
To: Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Ben Skeggs <bskeggs@redhat.com>, Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 2:33 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> This series adds support for probing platform devices on Nouveau, as well as
> the DT bindings for GK20A. It doesn't enable the GPU yet on Tegra boards since
> a few extra things need to be supported before that.
>
> This version is mostly identical to v2 but fixes an important issue: the drvdata
> must be set to the drm_device for sysfs to work, so the platform device
> structure now includes the nouveau_device flattened into it to let us compute
> the address of one from the other. Since the platform device resources (clocks,
> regulators, ...) need to live longer than the nouveau_device, they are stored
> into their own structure which is allocated separately.
>
> Changes since v2:
> * Allocate the nouveau_device flattened into the nouveau_platform_device to
>   be able to compute one from another easily, without having to ressort on the
>   drvdata which is required to store the drm_device.
> * Only propose the platform driver if a supported arch (Tegra for now) is
>   enabled.
> * Move structure definitions into their own header file as some subdevs (e.g.
>   clocks) will need to use them.
>
> Changes since v1:
> * Moved the platform device driver to its own module. This allows it to be more
>   self-contained and saves us the need to export too many functions from
>   nouveau_drm and nouveau_platform.
> * Register the DRM device without using the platform helpers, which is made
>   possible by drm_dev_set_unique(). This allows us to catch and register the
>   DRM device during platform probe.
> * Fixed the clock names in the DT bindings.
> * Removed the patches enabling GK20A on Venice2 and Jetson TK1 as support
>   is not complete yet.

Stephen, Thierry,

Ben has merged the first patch of this series into the Nouveau tree.
Could you get patches 2 and 3 through the Tegra tree? Thanks!
