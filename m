Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaJPGh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:37:59 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51319 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaJPGh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:37:57 -0400
Message-ID: <543F678E.1030401@ahsoftware.de>
Date: Thu, 16 Oct 2014 08:37:02 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 00/27] Fix common bug in most nand drivers not showing
 a device in sysfs
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wonder if anyone else will fix this in a maintainer-approved style 
which doesn't use these evil leftovers from C666 called functions.

Or will the sysfs for most NAND drivers be knowingly broken forever?

Regards,

Alexander Holler

Am 27.05.2014 00:12, schrieb Alexander Holler:
> A comment in mtdcore.c function add_mtd_device() which is called by
> mtd_device_parse_register() made me wonder:
>
> "Caller should have set dev.parent to match the physical device."
>
> In fact this is not done by most nand drivers.
>
> What follows is a series which fixes this.
>
> Tested: orion and omap2
> Compile-Tested: atmel, gpio, fsmc, gpmi, plat, pxa3xx, s3c2410, sh_flctl,
> 		sharpsl, tmio, docg4, davinci, lpc32xx_mlc, lpc32xx_slc, mxc
> Not tested at all (only be view, patches 19-27): bcm47, fsl_elbc, fsl_upm,
> 		fsl_ifc, jz4740, mpc5121m, ndfc, txx9ndfmx, socrates
>
> The overall stat is
>
> 27 files changed, 36 insertions(+), 80 deletions(-)
>
> and it fixes 21 of these bugs.
>
> Regards,
>
> Alexander Holler
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

