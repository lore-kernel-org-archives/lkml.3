Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3HLKFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:05:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60235 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab3HLKFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:05:40 -0400
Date: Mon, 12 Aug 2013 12:05:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, mujeeb.adil@gmail.com,
        harsh1kumar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] Staging: winbond: wb35reg: avoided use of extern
 function
Message-ID: <20130812100539.GC21492@amd.pavel.ucw.cz>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
 <1375696712-5276-4-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375696712-5276-4-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-08-05 11:58:29, Iker Pedrosa wrote:
> Prototype of a function added to the header to avoid the use of extern.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

ACK.

> ---
>  drivers/staging/winbond/phy_calibration.h | 1 +
>  drivers/staging/winbond/wb35reg.c         | 3 +--
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/winbond/phy_calibration.h b/drivers/staging/winbond/phy_calibration.h
> index 84f6e84..78fc680 100644
> --- a/drivers/staging/winbond/phy_calibration.h
> +++ b/drivers/staging/winbond/phy_calibration.h
> @@ -79,6 +79,7 @@
>  #define SHIFT_IQCAL_TONE_Q(x)	((x) >> 13)
>  
>  void phy_set_rf_data(struct hw_data *pHwData, u32 index, u32 value);
> +void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency);
>  #define phy_init_rf(_A)		/* RFSynthesizer_initial(_A) */
>  
>  #endif
> diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
> index 1314f93..a500904 100644
> --- a/drivers/staging/winbond/wb35reg.c
> +++ b/drivers/staging/winbond/wb35reg.c
> @@ -1,10 +1,9 @@
>  #include "wb35reg_f.h"
> +#include "phy_calibration.h"
>  
>  #include <linux/usb.h>
>  #include <linux/slab.h>
>  
> -extern void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency);
> -
>  /*
>   * true  : read command process successfully
>   * false : register not support

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
