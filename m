Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaBKMhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:37:54 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46718 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKMhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:37:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Date: Tue, 11 Feb 2014 13:38:51 +0100
Message-ID: <1600194.93iSF4Yz3E@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392117421.5686.4.camel@x220>
References: <1391958577.25424.22.camel@x220> <1409428.L7JLLEda5C@avalon> <1392117421.5686.4.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Tuesday 11 February 2014 12:17:01 Paul Bolle wrote:
> Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> camera interface - Build system") added a Kconfig entry for
> VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> 
> This entry was apparently copied from a similar entry for "OMAP 3
> Camera debug messages". The OMAP 3 entry is used to set the DEBUG
> compiler flag, which enables calls of dev_dbg().
> 
> So add a Makefile line to do that for omap4iss too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
> 0) v1 was called "[media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG". This
> versions implements Laurent's alternative (which is much better).

Thanks :-)

> 1) Still untested.
> 
>  drivers/staging/media/omap4iss/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/media/omap4iss/Makefile
> b/drivers/staging/media/omap4iss/Makefile index a716ce9..f46c6bd 100644
> --- a/drivers/staging/media/omap4iss/Makefile
> +++ b/drivers/staging/media/omap4iss/Makefile
> @@ -1,5 +1,7 @@
>  # Makefile for OMAP4 ISS driver
> 
> +ccflags-$(CONFIG_VIDEO_OMAP4_DEBUG) += -DDEBUG
> +
>  omap4-iss-objs += \
>  	iss.o iss_csi2.o iss_csiphy.o iss_ipipeif.o iss_ipipe.o iss_resizer.o
> iss_video.o

-- 
Regards,

Laurent Pinchart

