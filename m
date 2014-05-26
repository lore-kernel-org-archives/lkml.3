Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaEZTPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:15:07 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:7595 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaEZTPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:15:06 -0400
Message-ID: <1401131688.18997.12.camel@localhost.localdomain>
Subject: Re: [PATCH 1/3] driver core/platform: don't leak memory allocated
 for dma_mask
From: Yann Droneaud <ydroneaud@opteya.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Mon, 26 May 2014 21:14:48 +0200
In-Reply-To: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emil,

Le lundi 26 mai 2014 à 18:41 +0200, Emil Goode a écrit :

> The first two patches in the series are created from v4 of the
> original patch, since I have not changed how the code works I think
> it is correct to keep the original author and Signed-off-by line.
> 
> Best regards,

Thanks for the update.

I wasn't interested in splitting the patch in two separate chunks,
thinking that shrinking the size of the structure then increasing it of
roughly the same amount was not the best way to sell the changes :)

Unfortunately, as noted by Uwe, you not only split the patch but also
broke it ;)

If we're going to split the patch, it should be split in:
1) replace name[1] by name[] (or name[0]) to remove the implicit padding
from platform_device structure
2) add dma_mask to platform_object structure and use it to initialize
   dev.dma_mask.

Anyway, as Russel explained in another mail, unconditionally set
dev.dma_mask pointer is probably going to break, so this part (2) need
some rework, I'm gonna try to do.

Thanks for reminding me about this patch.

Regards.

-- 
Yann Droneaud
OPTEYA


