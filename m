Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaBKUAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:00:09 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61408 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595AbaBKUAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:00:05 -0500
Message-ID: <1392148802.9682.36.camel@x220>
Subject: Re: drm/msm: CONFIG_MSM_OCMEM?
From: Paul Bolle <pebolle@tiscali.nl>
To: Rob Clark <robdclark@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Date: Tue, 11 Feb 2014 21:00:02 +0100
In-Reply-To: <CAF6AEGuezz14GCVfRA1m-5kKcQEHjzSLJ2xoPyU5jinjzwOm6A@mail.gmail.com>
References: <1392133181.3755.14.camel@x220>
	 <CAF6AEGuezz14GCVfRA1m-5kKcQEHjzSLJ2xoPyU5jinjzwOm6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 20:00:03.0067 (UTC) FILETIME=[DA0E9CB0:01CF2763]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 12:29 -0500, Rob Clark wrote:
> On Tue, Feb 11, 2014 at 10:39 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Commit 55459968176f ("drm/msm: add a330/apq8x74") added preprocessor
> > checks for CONFIG_MSM_OCMEM. But I couldn't find a Kconfig symbol
> > MSM_OCMEM (nor a preprocessor define for a macro of that name). Why were
> > those preprocessor checks added?
> 
> At the moment, CONFIG_MSM_OCMEM is only in downstream kernel.. not
> 100% sure about how we'll handle that upstream when there is more than
> just drm/msm using OCMEM (which can be shared between gpu, video
> enc/dec, etc).

I see. (Wouldn't that be an upstream kernel, actually?)

> > Please note that lines 197-201 currently read:
> >     /* Set the OCMEM base address for A330, etc */
> >     if (a3xx_gpu->ocmem_hdl) {
> >             gpu_write(gpu, REG_A3XX_RB_GMEM_BASE_ADDR,
> >                     (unsigned int)(a3xx_gpu->ocmem_base >> 14));
> >     }
> >
> > ocmem_hdl and ocmem_base are used uninitialized here, aren't they? So it
> > seems these lines should be wrapped with a preprocessor check for
> > CONFIG_MSM_OCMEM too.
> 
> in this case ocmem_hdl will be NULL (since a3xx_gpu is kzalloc'd).
> The #ifdef's could be added here, but not required.

I missed that. So whether or not to #ifdef this would be mostly a matter
of style.

Thanks,


Paul Bolle

