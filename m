Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaLMS7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 13:59:45 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:54402 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaLMS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 13:59:43 -0500
Date: Sat, 13 Dec 2014 10:59:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: LW@KARO-electronics.de, B38611@freescale.com, maksqwe1@ukr.net,
        jg1.han@samsung.com, linux@rasmusvillemoes.dk, fabf@skynet.be,
        joe@perches.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: edt-ft5x06: fixed a macro coding style issue
Message-ID: <20141213185937.GA22702@dtor-ws>
References: <20141209080816.GA19581@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209080816.GA19581@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 10:08:16AM +0200, Asaf Vertz wrote:
> Fixed a coding style error, macros with complex values should be
> enclosed in parentheses.
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>

Applied, thank you.

> ---
> Changes in v2:
>   - use do {...} while (0)  instead of {...}
> 
>  drivers/input/touchscreen/edt-ft5x06.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
> index ee3434f..d22ed56 100644
> --- a/drivers/input/touchscreen/edt-ft5x06.c
> +++ b/drivers/input/touchscreen/edt-ft5x06.c
> @@ -850,9 +850,11 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
>  }
>  
>  #define EDT_ATTR_CHECKSET(name, reg) \
> +do {								\
>  	if (pdata->name >= edt_ft5x06_attr_##name.limit_low &&		\
>  	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
> -		edt_ft5x06_register_write(tsdata, reg, pdata->name)
> +		edt_ft5x06_register_write(tsdata, reg, pdata->name);	\
> +} while (0)
>  
>  #define EDT_GET_PROP(name, reg) {				\
>  	u32 val;						\
> -- 
> 1.7.0.4
> 

-- 
Dmitry
