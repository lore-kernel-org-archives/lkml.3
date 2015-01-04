Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbbADP4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:56:09 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbbADP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:56:08 -0500
Message-ID: <54A96294.1090008@nod.at>
Date: Sun, 04 Jan 2015 16:56:04 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, daniel.lezcano@linaro.org,
        tglx@linutronix.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        d.walter@0x90.at
Subject: Re: [PATCH] drivers/clocksource/Kconfig: Let SH_TIMER_CMT depend
 on HAS_IOMEM
References: <542D546C.8030205@gmail.com>
In-Reply-To: <542D546C.8030205@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen,

Am 02.10.2014 um 15:34 schrieb Chen Gang:
> SH_TIMER_CMT will use IO memory features which needs HAS_IOMEM, so need
> depend on it. The related error (with allmodconfig under um):
> 
>     CC      drivers/clocksource/sh_cmt.o
>   drivers/clocksource/sh_cmt.c: In function 'sh_cmt_map_memory':
>   drivers/clocksource/sh_cmt.c:920:2: error: implicit declaration of function 'ioremap_nocache' [-Werror=implicit-function-declaration]
>     cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
>     ^
>   drivers/clocksource/sh_cmt.c:920:15: warning: assignment makes pointer from integer without a cast [enabled by default]
>     cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
>                  ^
>   drivers/clocksource/sh_cmt.c: In function 'sh_cmt_setup':
>   drivers/clocksource/sh_cmt.c:1034:2: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
>     iounmap(cmt->mapbase);
>     ^

what is the status of this patch?
I'd like to have this build issue resolved.

Thanks,
//richard
