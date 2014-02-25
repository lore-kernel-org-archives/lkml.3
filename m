Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaBYQGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:06:43 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53135 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBYQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:06:42 -0500
MIME-Version: 1.0
In-Reply-To: <1393343227-13092-1-git-send-email-ajax@redhat.com>
References: <1222713404-1097-1-git-send-email-ajax@redhat.com>
	<1393343227-13092-1-git-send-email-ajax@redhat.com>
Date: Tue, 25 Feb 2014 11:06:41 -0500
X-Google-Sender-Auth: 8ItxfDyquss8iun0Ym2QDNj_zI8
Message-ID: <CA+5PVA6zHH_rj_2cawnWxQ_JRiyybFsNM3d30cCN=FpMiMuXxg@mail.gmail.com>
Subject: Re: [PATCH] i8042: Don't print an error message just because there's
 no chip
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-input@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:47 AM, Adam Jackson <ajax@redhat.com> wrote:
> From: Peter Jones <pjones@redhat.com>
>
> Some systems, such as EFI-based Apple systems, won't necessarily have an
> i8042 to initialize. We shouldn't be printing an error message in this
> case, since not detecting the chip is the correct behavior.
>
> v2: Downgrade to pr_notice instead of pr_err.
>
> Signed-off-by: Adam Jackson <ajax@redhat.com>

Reviewed-by:  Josh Boyer <jwboyer@fedoraproject.org>

> ---
>  drivers/input/serio/i8042.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index 020053f..05c6285 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c
> @@ -855,7 +855,7 @@ static int __init i8042_check_aux(void)
>  static int i8042_controller_check(void)
>  {
>         if (i8042_flush()) {
> -               pr_err("No controller found\n");
> +               pr_notice("No controller found\n");
>                 return -ENODEV;
>         }
>
