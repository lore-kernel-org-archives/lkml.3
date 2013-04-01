Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3DAJKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:10:13 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60638 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3DAJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <1364802082.6252.1.camel@phoenix>
References: <1364802082.6252.1.camel@phoenix>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 1 Apr 2013 17:09:51 +0800
Message-ID: <CAMPhdO9H3PzYczEYELuTk+uz5mKd8RoQiZEAQBoQTqumLWtCVA@mail.gmail.com>
Subject: Re: [PATCH] pwm: pxa: Remove PWM_ID_BASE macro
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 3:41 PM, Axel Lin <axel.lin@ingics.com> wrote:
> PWM_ID_BASE() is not used after convert to PWM framework, remove it.
> Also update driver_data field of struct platform_device_id accordingly.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> This is v2 of [PATCH] pwm: pxa: Use driver_data field to store pwm_nr.
> I change the subject line to meet the change in v2.
>
>  drivers/pwm/pwm-pxa.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index b789882..dee6ab55 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -23,14 +23,13 @@
>  #include <asm/div64.h>
>
>  #define HAS_SECONDARY_PWM      0x10
> -#define PWM_ID_BASE(d)         ((d) & 0xf)
>
>  static const struct platform_device_id pwm_id_table[] = {
>         /*   PWM    has_secondary_pwm? */
>         { "pxa25x-pwm", 0 },
> -       { "pxa27x-pwm", 0 | HAS_SECONDARY_PWM },
> -       { "pxa168-pwm", 1 },
> -       { "pxa910-pwm", 1 },
> +       { "pxa27x-pwm", HAS_SECONDARY_PWM },
> +       { "pxa168-pwm", 0 },
> +       { "pxa910-pwm", 0 },
>         { },
>  };
>  MODULE_DEVICE_TABLE(platform, pwm_id_table);

Looks good to me, Acked-by: Eric Miao <eric.y.miao@gmail.com>
