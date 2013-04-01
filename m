Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3DAHWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:22:07 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60922 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3DAHWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:22:06 -0400
MIME-Version: 1.0
In-Reply-To: <1364746327.12810.1.camel@phoenix>
References: <1364746327.12810.1.camel@phoenix>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 1 Apr 2013 15:21:44 +0800
Message-ID: <CAMPhdO_EHEs82ffKGTuJ1j=ruOHYd0HCYPash9xNu9gdkX2=YQ@mail.gmail.com>
Subject: Re: [PATCH] pwm: pxa: Use driver_data field to store pwm_nr
To: Axel Lin <axel.lin@ingics.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 12:12 AM, Axel Lin <axel.lin@ingics.com> wrote:
> The driver_data field was used to store information about PWM_ID_BASE and
> HAS_SECONDARY_PWM. PWM_ID_BASE is not used now after convert to pwm framework.
> This patch stores the pwm_nr in driver_data field to simplify the code.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pwm/pwm-pxa.c |   11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index b789882..019a8e0 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -22,13 +22,10 @@
>
>  #include <asm/div64.h>
>
> -#define HAS_SECONDARY_PWM      0x10
> -#define PWM_ID_BASE(d)         ((d) & 0xf)
> -
>  static const struct platform_device_id pwm_id_table[] = {
> -       /*   PWM    has_secondary_pwm? */
> -       { "pxa25x-pwm", 0 },
> -       { "pxa27x-pwm", 0 | HAS_SECONDARY_PWM },
> +       /*   PWM    pwm_nr */
> +       { "pxa25x-pwm", 1 },
> +       { "pxa27x-pwm", 2 },
>         { "pxa168-pwm", 1 },
>         { "pxa910-pwm", 1 },
>         { },
> @@ -145,7 +142,7 @@ static int pwm_probe(struct platform_device *pdev)
>         pwm->chip.dev = &pdev->dev;
>         pwm->chip.ops = &pxa_pwm_ops;
>         pwm->chip.base = -1;
> -       pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
> +       pwm->chip.npwm = id->driver_data;

I'd rather keep the flag for a bit more readability?

>
>         r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (r == NULL) {
> --
> 1.7.10.4
>
>
>
