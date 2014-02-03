Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBCRdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:33:53 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:55848 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaBCRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:33:51 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Date: Mon, 3 Feb 2014 18:33:51 +0100
X-Google-Sender-Auth: _9lCElPmW8PU-2gIm6U9SbqQCH0
Message-ID: <CAKMK7uHr7D_VqnkbLPpRpvq9-BimBaEoUtmdxQg5ePZg12ZC3g@mail.gmail.com>
Subject: Re: [RFC 00/16] drm/nouveau: initial support for GK20A (Tegra K1)
From: Daniel Vetter <daniel@ffwll.ch>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>, gnurou@gmail.com,
        Eric Brower <ebrower@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 4:16 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Finally, support for probing GK20A is added in the last 2 patches. It should be
> noted that contrary to what Nouveau currently expects, GK20A does not embed any
> display hardware (that part being handled by tegradrm). So this driver should
> really be only used through DRM render-nodes and collaborate with the display
> driver using PRIME. I have not yet figured out how to turn GK20A's instantiation
> of Nouveau into a render-node only driver without breaking support for existing
> desktop GPUs, and consequently the driver spawns a /dev/dri/cardX node which we
> should try to get rid of.

tbh I wouldn't care about the lagecy dev nodes - we have hw platforms
on intel with similar setup (i.e. just rendering and no outputs) and
we don't bother to hide the legacy node. kms ioctl will still be
there, but as long as no encoder/connector/crtc/... gets set up by the
driver the only thing userspace can do is create framebuffers. Which
is rather harmless ;-)

And having legacy dev nodes around helps on older userspace (e.g.
X/Prime with dri2 which uses flink).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
