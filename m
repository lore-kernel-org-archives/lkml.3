Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3EMCIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:08:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54233 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3EMCIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <1367803801-17111-3-git-send-email-chao.xie@marvell.com>
References: <1367803801-17111-1-git-send-email-chao.xie@marvell.com> <1367803801-17111-3-git-send-email-chao.xie@marvell.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 13 May 2013 10:08:17 +0800
Message-ID: <CAMPhdO-66YfMuzSbdbDoi3OjBzN9yqw7jGQ8Hk8dGRJNNLAsXA@mail.gmail.com>
Subject: Re: [PATCH V4 2/3] pwm: pxa: use module_platform_driver()
To: Chao Xie <chao.xie@marvell.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chao Xie <xiechao.mail@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:30 AM, Chao Xie <chao.xie@marvell.com> wrote:
> Old pwm-pxa.c will register driver by arch_initcall. Then other
> drivers based on the PWM driver can successully call old
> pwm_request because arch_initcall make sure the PWM driver will
> be registered earlier.
> Now, pwm_request is re-written and done by common layer code. It
> will return -EPROBE_DEFER if the PWM device is not probed.
> The driver based on PWM driver can make use of -EPROBE_DEFER
> to delay its probing.
> So arch_initcall can be replaced by module_platform_driver.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>

Looks good to me,

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/pwm/pwm-pxa.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index dee6ab55..aa4bea7 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -187,16 +187,6 @@ static struct platform_driver pwm_driver = {
>         .id_table       = pwm_id_table,
>  };
>
> -static int __init pwm_init(void)
> -{
> -       return platform_driver_register(&pwm_driver);
> -}
> -arch_initcall(pwm_init);
> -
> -static void __exit pwm_exit(void)
> -{
> -       platform_driver_unregister(&pwm_driver);
> -}
> -module_exit(pwm_exit);
> +module_platform_driver(pwm_driver);
>
>  MODULE_LICENSE("GPL v2");
> --
> 1.7.4.1
>
