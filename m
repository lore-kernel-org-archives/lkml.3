Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaGWFlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:41:46 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36214 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaGWFlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <1406041261-5716-1-git-send-email-linux@roeck-us.net>
References: <1406041261-5716-1-git-send-email-linux@roeck-us.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 23 Jul 2014 14:41:23 +0900
Message-ID: <CAAVeFu+oWYiKJsaqt6Gc3mzJqSReZpd4m-iJbvuoUGARdyr4xA@mail.gmail.com>
Subject: Re: [PATCH v3] gpiolib: Export gpiochip_request_own_desc and gpiochip_free_own_desc
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:01 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> Both functions were introduced to let gpio drivers request their own
> gpio pins. Without exporting the functions, this can however only be
> used by gpio drivers built into the kernel.
>
> Secondary impact is that the functions can not currently be used by
> platform initialization code associated with the gpio-pca953x driver.
> This code permits auto-export of gpio pins through platform data, but
> if this functionality is used, the module can no longer be unloaded due
> to the problem solved with the introduction of gpiochip_request_own_desc
> and gpiochip_free_own_desc.
>
> Export both function so they can be used from modules and from
> platform initialization code.
>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Makes sense to have them there.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
