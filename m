Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaBKR3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:29:51 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64213 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBKR3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <1392133181.3755.14.camel@x220>
References: <1392133181.3755.14.camel@x220>
Date: Tue, 11 Feb 2014 12:29:49 -0500
Message-ID: <CAF6AEGuezz14GCVfRA1m-5kKcQEHjzSLJ2xoPyU5jinjzwOm6A@mail.gmail.com>
Subject: Re: drm/msm: CONFIG_MSM_OCMEM?
From: Rob Clark <robdclark@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:39 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Rob,
>
> Commit 55459968176f ("drm/msm: add a330/apq8x74") added preprocessor
> checks for CONFIG_MSM_OCMEM. But I couldn't find a Kconfig symbol
> MSM_OCMEM (nor a preprocessor define for a macro of that name). Why were
> those preprocessor checks added?

At the moment, CONFIG_MSM_OCMEM is only in downstream kernel.. not
100% sure about how we'll handle that upstream when there is more than
just drm/msm using OCMEM (which can be shared between gpu, video
enc/dec, etc).

> Please note that lines 197-201 currently read:
>     /* Set the OCMEM base address for A330, etc */
>     if (a3xx_gpu->ocmem_hdl) {
>             gpu_write(gpu, REG_A3XX_RB_GMEM_BASE_ADDR,
>                     (unsigned int)(a3xx_gpu->ocmem_base >> 14));
>     }
>
> ocmem_hdl and ocmem_base are used uninitialized here, aren't they? So it
> seems these lines should be wrapped with a preprocessor check for
> CONFIG_MSM_OCMEM too.

in this case ocmem_hdl will be NULL (since a3xx_gpu is kzalloc'd).
The #ifdef's could be added here, but not required.

BR,
-R

>
> Paul Bolle
>
