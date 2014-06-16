Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaFPHfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:35:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:35170 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaFPHfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:35:53 -0400
Message-ID: <1402904135.7661.34.camel@pasglop>
Subject: Re: [PATCH] offb: Fix little-endian support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Cedric Le Goater <clg@fr.ibm.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 17:35:35 +1000
In-Reply-To: <1400073709-15012-1-git-send-email-tiwai@suse.de>
References: <1400073709-15012-1-git-send-email-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 15:21 +0200, Takashi Iwai wrote:
>         case 16:                /* RGB 565 */
>                 var->bits_per_pixel = 16;
> -               var->red.offset = 11;
> +               if (fb_be_math(info)) {
> +                       var->red.offset = 11;
> +                       var->green.offset = 5;
> +                       var->blue.offset = 0;
> +               } else {
> +                       var->red.offset = 0;
> +                       var->green.offset = 5;
> +                       var->blue.offset = 11;
> +               }
>                 var->red.length = 5;
> -               var->green.offset = 5;
>                 var->green.length = 6;
> -               var->blue.offset = 0;
>                 var->blue.length = 5;
>                 var->transp.offset = 0;
>                 var->transp.length = 0;
>                 break;

I somewhat doubt that this (and 5:5:5) actually work, do they ? the
green gets split into two separate fields, which we can't express
properly here...

Cheers,
Ben.


