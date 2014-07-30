Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaG3TRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:17:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39859 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaG3TRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:17:11 -0400
X-Originating-IP: 78.210.48.61
Date: Wed, 30 Jul 2014 21:16:40 +0200
From: Guillaume Clement <gclement@baobob.org>
To: Fernando Apesteguia <fernando.apesteguia@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH] Staging: vt6655: staticfy variable
Message-ID: <20140730191638.GA5493@pleinair.baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Add static to variable.
> Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
> ---
>  drivers/staging/vt6655/ioctl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/vt6655/ioctl.c
> b/drivers/staging/vt6655/ioctl.c
> index 65e5933..cc6e47b 100644
> --- a/drivers/staging/vt6655/ioctl.c
> +++ b/drivers/staging/vt6655/ioctl.c
> @@ -41,7 +41,7 @@
>  static int msglevel = MSG_LEVEL_INFO;
>
>  #ifdef WPA_SM_Transtatus
> -SWPAResult wpa_Result;
> +static SWPAResult wpa_Result;
>  #endif

This changes breaks the compilation (actually the linking). wpa_Result
is actually used in device_main.c in device_open with the following:

> #ifdef WPA_SM_Transtatus
> 	extern SWPAResult wpa_Result;
> #endif
