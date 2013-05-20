Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3ETTmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:42:22 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:28709 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab3ETTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:42:20 -0400
Date: Mon, 20 May 2013 21:42:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/matrox/matroxfb_maven: Use module_i2c_driver to
 register driver
Message-ID: <20130520214206.078bc580@endymion.delvare>
In-Reply-To: <1369078578-3138-1-git-send-email-peterhuewe@gmx.de>
References: <1369078578-3138-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013 21:36:18 +0200, Peter Huewe wrote:
> Removing some boilerplate by using module_i2c_driver instead of calling
> register and unregister in the otherwise empty init/exit functions
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/video/matrox/matroxfb_maven.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
> index 217678e..fd4b64e 100644
> --- a/drivers/video/matrox/matroxfb_maven.c
> +++ b/drivers/video/matrox/matroxfb_maven.c
> @@ -1283,19 +1283,8 @@ static struct i2c_driver maven_driver={
>  	.id_table	= maven_id,
>  };
>  
> -static int __init matroxfb_maven_init(void)
> -{
> -	return i2c_add_driver(&maven_driver);
> -}
> -
> -static void __exit matroxfb_maven_exit(void)
> -{
> -	i2c_del_driver(&maven_driver);
> -}
> -
> +module_i2c_driver(maven_driver);
>  MODULE_AUTHOR("(c) 1999-2002 Petr Vandrovec <vandrove@vc.cvut.cz>");
>  MODULE_DESCRIPTION("Matrox G200/G400 Matrox MGA-TVO driver");
>  MODULE_LICENSE("GPL");
> -module_init(matroxfb_maven_init);
> -module_exit(matroxfb_maven_exit);
>  /* we do not have __setup() yet */

This last comment could certainly go away as well, AFAICT it's a now
meaningless relic.

Other than this:

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
