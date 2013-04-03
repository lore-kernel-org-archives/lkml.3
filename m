Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132Ab3DCLuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:50:01 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:37833 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab3DCLuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <1364427259-25658-1-git-send-email-haojian.zhuang@linaro.org>
References: <1364427259-25658-1-git-send-email-haojian.zhuang@linaro.org>
Date: Wed, 3 Apr 2013 13:49:59 +0200
Message-ID: <CACRpkdab-JOa3PK0k4cm1JseTbmA4r7urSf+uA9hX57PRLVwtw@mail.gmail.com>
Subject: Re: [PATCH resend] pinctrl: core: add dependence of GPIOLIB
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:34 AM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:

> In file included from drivers/pinctrl/core.c:30:0:
> include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
> include/asm-generic/gpio.h:270:2: error: implicit declaration of
> function '__gpio_get_value' [-Werror=implicit-function-declaration]
> include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
> include/asm-generic/gpio.h:276:2: error: implicit declaration of
> function '__gpio_set_value' [-Werror=implicit-function-declaration]
> drivers/pinctrl/core.c: In function 'pinctrl_ready_for_gpio_range':
> drivers/pinctrl/core.c:297:9: error: implicit declaration of function
> 'gpio_to_chip' [-Werror=implicit-function-declaration]
> drivers/pinctrl/core.c:297:27: warning: initialization makes pointer
> from integer without a cast [enabled by default]
> drivers/pinctrl/core.c:304:45: error: dereferencing pointer to
> incomplete type
> drivers/pinctrl/core.c:305:26: error: dereferencing pointer to
> incomplete type
> drivers/pinctrl/core.c:305:39: error: dereferencing pointer to
> incomplete type
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/pinctrl/core.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> It's caused by CONFIG_GPIOLIB isn't enabled for some platform. So
> add the dependence on pinctrl_ready_for_gpio_range().
>
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Patch applied, thanks!

Yours,
Linus Walleij
