Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaBJOMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:12:34 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:39640 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:12:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: omap4iss: Remove VIDEO_OMAP4_DEBUG
Date: Mon, 10 Feb 2014 15:13:30 +0100
Message-ID: <3300576.MqDnfacnEA@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1391958577.25424.22.camel@x220>
References: <1391958577.25424.22.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for the patch.

On Sunday 09 February 2014 16:09:37 Paul Bolle wrote:
> Commit d632dfefd36f ("[media] v4l: omap4iss: Add support for OMAP4
> camera interface - Build system") added a Kconfig entry for
> VIDEO_OMAP4_DEBUG. But nothing uses that symbol.
> 
> This entry was apparently copied from a similar entry for "OMAP 3
> Camera debug messages". But a corresponding Makefile line is missing.
> Besides, the debug code also depends on a mysterious ISS_ISR_DEBUG
> macro. This Kconfig entry can be removed.

What about adding the associated Makefile line instead to #define DEBUG when 
VIDEO_OMAP4_DEBUG is selected, as with the OMAP3 ISP driver ?
 
> Someone familiar with the code might be able to say what to do with the
> code depending on the DEBUG and ISS_ISR_DEBUG macros.

ISS_ISR_DEBUG is expected to be set by manually modifying the source code, as 
it prints lots of messages in interrupt context.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  drivers/staging/media/omap4iss/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/Kconfig
> b/drivers/staging/media/omap4iss/Kconfig index b9fe753..78b0fba 100644
> --- a/drivers/staging/media/omap4iss/Kconfig
> +++ b/drivers/staging/media/omap4iss/Kconfig
> @@ -4,9 +4,3 @@ config VIDEO_OMAP4
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  Driver for an OMAP 4 ISS controller.
> -
> -config VIDEO_OMAP4_DEBUG
> -	bool "OMAP 4 Camera debug messages"
> -	depends on VIDEO_OMAP4
> -	---help---
> -	  Enable debug messages on OMAP 4 ISS controller driver.

-- 
Regards,

Laurent Pinchart

