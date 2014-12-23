Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaLWRCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:02:44 -0500
Received: from lists.s-osg.org ([54.187.51.154]:41716 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbaLWRCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:02:42 -0500
Date: Tue, 23 Dec 2014 15:02:32 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: gregkh@linuxfoundation.org, shijie8@gmail.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: tlg2300: disable building the driver
Message-ID: <20141223150232.1780e447@concha.lan.sisa.samsung.com>
In-Reply-To: <1419279945-16777-1-git-send-email-jim.epost@gmail.com>
References: <1419279945-16777-1-git-send-email-jim.epost@gmail.com>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 22 Dec 2014 13:25:45 -0700
Jim Davis <jim.epost@gmail.com> escreveu:

> This driver doesn't build with the current kernel, as reported in
> linux-next (https://lkml.org/lkml/2014/12/18/483) and by the 0-day
> build system
> (https://www.mail-archive.com/linux-media@vger.kernel.org/msg83501.html).
> Since it's scheduled for removal, disable building it for now.
> 
> Signed-off-by: Jim Davis <jim.epost@gmail.com>
> ---
>  drivers/staging/media/tlg2300/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/tlg2300/Kconfig b/drivers/staging/media/tlg2300/Kconfig
> index 81784c6f7b88..87181b0f77fd 100644
> --- a/drivers/staging/media/tlg2300/Kconfig
> +++ b/drivers/staging/media/tlg2300/Kconfig
> @@ -7,6 +7,7 @@ config VIDEO_TLG2300
>  	select VIDEOBUF_VMALLOC
>  	select SND_PCM
>  	select VIDEOBUF_DVB
> +	depends on BROKEN

Actually, what it was missing on the original driver were to preserve
the original dependency. In this case, it should be dependent of
MEDIA_USB_SUPPORT.

> 
>  	---help---
>  	  This is a video4linux driver for Telegent tlg2300 based TV cards.


-- 

Cheers,
Mauro
