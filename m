Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaBNKjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:39:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34726 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaBNKjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:39:33 -0500
Date: Fri, 14 Feb 2014 11:39:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Petr =?utf-8?B?UMOtc2HFmQ==?= <petr.pisar@atlas.cz>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?Jean-Fran=E7ois?= Moine <moinejf@free.fr>
Subject: Re: [PATCH] vt: Fix secure clear screen
Message-ID: <20140214103929.GA3933@amd.pavel.ucw.cz>
References: <1391716883-31383-1-git-send-email-petr.pisar@atlas.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391716883-31383-1-git-send-email-petr.pisar@atlas.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> \E[3J console code (secure clear screen) needs to update_screen(vc)
> in order to write-through blanks into off-screen video memory.

I guess it is also suitable for stable, right?

Thanks,
								Pavel

> This has been removed accidentally in 3.6 by:
> 
> commit 81732c3b2fede049a692e58a7ceabb6d18ffb18c
> Author: Jean-François Moine <moinejf@free.fr>
> Date:   Thu Sep 6 19:24:13 2012 +0200
> 
>     tty vt: Fix line garbage in virtual console on command line edition
> 
> Signed-off-by: Petr Písař <petr.pisar@atlas.cz>
> ---
>  drivers/tty/vt/vt.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index 61b1137..23b5d32 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -1164,6 +1164,8 @@ static void csi_J(struct vc_data *vc, int vpar)
>  			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
>  				    vc->vc_screenbuf_size >> 1);
>  			set_origin(vc);
> +			if (CON_IS_VISIBLE(vc))
> +				update_screen(vc);
>  			/* fall through */
>  		case 2: /* erase whole display */
>  			count = vc->vc_cols * vc->vc_rows;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
