Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342Ab3BNW5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:57:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10138 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030250Ab3BNW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:57:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+/cOaHwNCcWCL2nQ7ph7B9
Date: Thu, 14 Feb 2013 14:57:50 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH 9/9] [media] davinci: do not include mach/hardware.h
Message-ID: <20130214225749.GJ11362@atomide.com>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360882071-4072668-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130214 14:51]:
> It is now possible to build the davinci vpss code
> on multiplatform kernels, which causes a problem
> since the driver tries to incude the davinci
> platform specific mach/hardware.h file. Fortunately
> that file is not required at all in the driver,
> so we can simply remove the #include statement.
> 
> Without this patch, building allyesconfig results in:
> 
> drivers/media/platform/davinci/vpss.c:28:27: fatal error: mach/hardware.h: No such file or directory
> compilation terminated.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: "Lad, Prabhakar" <prabhakar.lad@ti.com>

All mach and plat includes from drivers should be fixed
and removed as that adds nasty dependencies between core SoC
code and the drivers.

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/media/platform/davinci/vpss.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
> index 494d322..a19c552 100644
> --- a/drivers/media/platform/davinci/vpss.c
> +++ b/drivers/media/platform/davinci/vpss.c
> @@ -25,7 +25,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/compiler.h>
>  #include <linux/io.h>
> -#include <mach/hardware.h>
>  #include <media/davinci/vpss.h>
>  
>  MODULE_LICENSE("GPL");
> -- 
> 1.8.1.2
> 
