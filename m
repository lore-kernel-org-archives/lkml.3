Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3DXVCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:02:17 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45870 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3DXVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:02:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 0/6] Davinci fbdev driver and enable it for DMx platform
Date: Wed, 24 Apr 2013 23:02:15 +0200
Message-ID: <1780031.B4OAypccep@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Wednesday 24 April 2013 17:30:02 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch series adds an fbdev driver for Texas
> Instruments Davinci SoC.The display subsystem consists
> of OSD and VENC, with OSD supporting 2 RGb planes and
> 2 video planes.
> http://focus.ti.com/general/docs/lit/
> getliterature.tsp?literatureNumber=sprue37d&fileType=pdf
> 
> A good amount of the OSD and VENC enabling code is
> present in the kernel, and this patch series adds the
> fbdev interface.
> 
> The fbdev driver exports 4 nodes representing each
> plane to the user - from fb0 to fb3.

The obvious question is: why not a KMS driver instead ? :-)

> Lad, Prabhakar (6):
>   media: davinci: vpbe: fix checkpatch warning for CamelCase
>   media: davinci: vpbe: enable vpbe for fbdev addition
>   davinci: vpbe: add fbdev driver
>   ARM: davinci: dm355: enable fbdev driver
>   ARM: davinci: dm365: enable fbdev driver
>   ARM: davinci: dm644x: enable fbdev driver
> 
>  arch/arm/mach-davinci/dm355.c                 |   24 +-
>  arch/arm/mach-davinci/dm365.c                 |   10 +
>  arch/arm/mach-davinci/dm644x.c                |   10 +
>  drivers/media/platform/davinci/vpbe_display.c |    8 +-
>  drivers/media/platform/davinci/vpbe_osd.c     |  820 ++++++++-
>  drivers/media/platform/davinci/vpbe_venc.c    |   43 +
>  drivers/video/Kconfig                         |   12 +
>  drivers/video/Makefile                        |    1 +
>  drivers/video/davincifb.c                     | 2523 ++++++++++++++++++++++
>  drivers/video/davincifb.h                     |  194 ++
>  include/media/davinci/vpbe_osd.h              |   66 +-
>  include/media/davinci/vpbe_venc.h             |   21 +
>  12 files changed, 3702 insertions(+), 30 deletions(-)
>  create mode 100644 drivers/video/davincifb.c
>  create mode 100644 drivers/video/davincifb.h

-- 
Regards,

Laurent Pinchart

