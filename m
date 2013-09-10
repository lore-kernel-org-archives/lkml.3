Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3IJNkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:40:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49655 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3IJNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:40:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522F212D.3010208@roeck-us.net>
Date: Tue, 10 Sep 2013 06:39:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>
Subject: Re: [PATCH] drivers: of: fix build break if asm/dma-contiguous.h
 is missing
References: <1378804400-31716-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1378804400-31716-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 02:13 AM, Marek Szyprowski wrote:
> It is not needed to include asm/dma-contiguous.h header to compile
> reserved memory initialization code, so remove it to avoid build break
> on architectures without CMA support.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/of/of_reserved_mem.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index a754b84..0fe40c7 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -11,8 +11,6 @@
>    * License or (at your optional) any later version of the license.
>    */
>
> -#include <asm/dma-contiguous.h>
> -
>   #include <linux/memblock.h>
>   #include <linux/err.h>
>   #include <linux/of.h>
>

