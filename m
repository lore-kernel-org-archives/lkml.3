Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaFMVXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:23:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbaFMVXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:23:06 -0400
Date: Fri, 13 Jun 2014 23:23:00 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Christoph Jaeger <christophjaeger@linux.com>
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-taos-evm: Use module_serio_driver()
Message-ID: <20140613232300.45ebf96f@endymion.delvare>
In-Reply-To: <1402689144-20259-1-git-send-email-christophjaeger@linux.com>
References: <1402689144-20259-1-git-send-email-christophjaeger@linux.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014 21:52:24 +0200, Christoph Jaeger wrote:
> Get rid of some boilerplate code by using module_serio_driver().
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
> ---
>  drivers/i2c/busses/i2c-taos-evm.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-taos-evm.c b/drivers/i2c/busses/i2c-taos-evm.c
> index 0576026..10855a0 100644
> --- a/drivers/i2c/busses/i2c-taos-evm.c
> +++ b/drivers/i2c/busses/i2c-taos-evm.c
> @@ -311,19 +311,8 @@ static struct serio_driver taos_drv = {
>  	.interrupt	= taos_interrupt,
>  };
>  
> -static int __init taos_init(void)
> -{
> -	return serio_register_driver(&taos_drv);
> -}
> -
> -static void __exit taos_exit(void)
> -{
> -	serio_unregister_driver(&taos_drv);
> -}
> +module_serio_driver(taos_drv);
>  
>  MODULE_AUTHOR("Jean Delvare <jdelvare@suse.de>");
>  MODULE_DESCRIPTION("TAOS evaluation module driver");
>  MODULE_LICENSE("GPL");
> -
> -module_init(taos_init);
> -module_exit(taos_exit);

Reviewed-by: Jean Delvare <jdelvare@suse.de>

Thanks,
-- 
Jean Delvare
SUSE L3 Support
