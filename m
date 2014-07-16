Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394AbaGPPmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:42:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:29120 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915AbaGPPml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:42:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,673,1400050800"; 
   d="scan'208";a="457720954"
Message-ID: <53C69D6C.3010705@iki.fi>
Date: Wed, 16 Jul 2014 18:42:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:29.0) Gecko/20100101 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v4 04/21] leds: Reorder include directives
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com> <1405087464-13762-5-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1405087464-13762-5-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

Jacek Anaszewski wrote:
> Reorder include directives so that they are arranged
> in alphabetical order.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>   drivers/leds/led-class.c |   13 +++++++------
>   drivers/leds/led-core.c  |    3 ++-
>   include/linux/leds.h     |    2 +-
>   3 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index da79bbb..0127783 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -9,16 +9,17 @@
>    * published by the Free Software Foundation.
>    */
>
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> +#include <linux/ctype.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
>   #include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/leds.h>
>   #include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>

Do you also need slab.h?

>   #include <linux/spinlock.h>
> -#include <linux/device.h>
>   #include <linux/timer.h>
> -#include <linux/err.h>
> -#include <linux/ctype.h>
> -#include <linux/leds.h>
>   #include "leds.h"
>
>   static struct class *leds_class;
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 0ac06ed..d156fb6 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -12,10 +12,11 @@
>    */
>
>   #include <linux/kernel.h>
> +#include <linux/leds.h>
>   #include <linux/list.h>
>   #include <linux/module.h>
> +#include <linux/mutex.h>

And mutex.h here?

With that fixed, if there are some other patches that are essentially 
cleanups that could go in well before the rest of the set. Some of the 
patches will take a little longer, I presume.

I'll let you know if/when there's an update regarding the compound 
controls patchset.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
