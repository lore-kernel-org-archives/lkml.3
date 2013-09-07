Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3IGLQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 07:16:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54831 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3IGLQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 07:16:23 -0400
MIME-Version: 1.0
In-Reply-To: <1378468153-1375-1-git-send-email-teg@jklm.no>
References: <1378467880-1040-1-git-send-email-teg@jklm.no>
	<1378468153-1375-1-git-send-email-teg@jklm.no>
Date: Sat, 7 Sep 2013 13:16:23 +0200
Message-ID: <CANq1E4Rxo3Az0hwCzzQyKz6z_uyVq-9bgAzNzm9StkWoAbkN_A@mail.gmail.com>
Subject: Re: [PATCH] simplefb: print some info about the registered fb
From: David Herrmann <dh.herrmann@gmail.com>
To: Tom Gundersen <teg@jklm.no>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom

On Fri, Sep 6, 2013 at 1:49 PM, Tom Gundersen <teg@jklm.no> wrote:
> This is similar to the output printed by efifb.
>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> ---
>
> Hi,
>
> Sorry for the resend, got the ml address wrong.
>
> -t
>
>  drivers/video/simplefb.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> index 8d78106..4196686 100644
> --- a/drivers/video/simplefb.c
> +++ b/drivers/video/simplefb.c
> @@ -220,6 +220,14 @@ static int simplefb_probe(struct platform_device *pdev)
>         }
>         info->pseudo_palette = (void *)(info + 1);
>
> +       dev_info(&pdev->dev, "framebuffer at 0x%lx, mapped to 0x%p\n",
> +                            info->fix.smem_start, info->screen_base);

Could we get smem_len, too? Something like:
      dev_info(&pdev->dev, "framebuffer at 0x%lx, 0x%lx bytes, mapped
to 0x%p\n",
                           info->fix.smem_start, (unsigned
long)info->fix.smem_len, info->screen_base);

(smem_len is __u32, so cast it to avoid truncation if it's defined as
long somewhere. Not sure whether we actually have 16bit int somewhere,
though)

Cheers
David

> +       dev_info(&pdev->dev, "format=%s, mode=%dx%dx%d, linelength=%d\n",
> +                            params.format->name,
> +                            info->var.xres, info->var.yres,
> +                            info->var.bits_per_pixel,
> +                            info->fix.line_length);
> +
>         ret = register_framebuffer(info);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "Unable to register simplefb: %d\n", ret);
> --
> 1.8.4
>
