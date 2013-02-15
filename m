Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161281Ab3BOGtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:49:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54812 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965030Ab3BOGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:49:39 -0500
Message-ID: <1360910978.2089.3.camel@joe-AO722>
Subject: Re: [PATCH V2 07/11] rtc: rtc-rs5c313: use pr_err() instead of
 printk()
From: Joe Perches <joe@perches.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Date: Thu, 14 Feb 2013 22:49:38 -0800
In-Reply-To: <002501ce0b48$36cf28e0$a46d7aa0$%han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
	 <002501ce0b48$36cf28e0$a46d7aa0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 15:46 +0900, Jingoo Han wrote:
> Fixed the checkpatch warning as below:
[]
> diff --git a/drivers/rtc/rtc-rs5c313.c b/drivers/rtc/rtc-rs5c313.c
[]
> @@ -39,6 +39,8 @@
>   *	1.13	Nobuhiro Iwamatsu: Updata driver.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/err.h>
>  #include <linux/rtc.h>
> @@ -352,8 +354,7 @@ static void rs5c313_check_xstp_bit(void)
>  		tm.tm_year 	= 2000 - 1900;
>  
>  		rs5c313_rtc_set_time(NULL, &tm);
> -		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "
> -				"1 Jan 2000\n");
> +		pr_err("RICHO RS5C313: invalid value, resetting to 1 Jan 2000\n");

You could remove the "RICH0 RS5C313: "prefix,
pr_fmt adds it (more or less).


